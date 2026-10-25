class TicketAssistant
  STOP_WORDS = %w[
    ama ancak bana benim bize bizim bu da de daha diye için ile mi mı mu mü
    o olarak oluyor şu ve veya ya yada yardım yardımcı hakkında nasıl neden
    the and are was were with that this from your you have has can please
  ].freeze

  CONCEPTS = {
    payment: %w[odeme ucret kart cekim tahsil charge charged payment billing],
    order: %w[siparis sepet checkout order purchase satin],
    invoice: %w[fatura invoice pdf makbuz receipt],
    account: %w[hesap account profil profile],
    login: %w[giris oturum parola sifre login session password],
    email: %w[eposta mail email bildirim notification],
    team: %w[ekip uye kullanici member user davet invite],
    mobile: %w[mobil uygulama app telefon mobile],
    plan: %w[plan abonelik paket subscription pricing]
  }.freeze

  KnowledgeResult = Struct.new(:id, :title, :body, :reply, :score, keyword_init: true)
  RelatedTicket = Struct.new(:ticket, :score, keyword_init: true)

  def initialize(ticket = nil, organization: nil, text: nil)
    @ticket = ticket
    @organization = organization || ticket&.organization
    @input_text = text
  end

  def knowledge_results
    knowledge_articles.filter_map do |article|
      score = overlap_score(query_terms, terms_for(article.fetch("terms", [])))
      next if score.zero?

      KnowledgeResult.new(
        id: article.fetch("id"),
        title: article.fetch("title"),
        body: article.fetch("body"),
        reply: article.fetch("reply"),
        score: score
      )
    end.sort_by { |result| -result.score }.first(2)
  end

  def related_tickets(limit: 3)
    tickets = @organization.tickets
    tickets = tickets.where.not(id: @ticket.id) if @ticket&.persisted?
    tickets.includes(:requester_user).filter_map do |candidate|
      score = overlap_score(query_terms, terms_for([ candidate.subject, candidate.description ].join(" ")))
      next if score < 2

      RelatedTicket.new(ticket: candidate, score: score)
    end.sort_by { |result| [ -result.score, -result.ticket.updated_at.to_i ] }.first(limit)
  end

  def human_handoff?
    knowledge_results.empty?
  end

  def knowledge_articles
    @knowledge_articles ||= YAML.safe_load_file(
      Rails.root.join("config/support_knowledge.yml"),
      permitted_classes: [],
      aliases: false
    ).fetch(I18n.locale.to_s)
  end

  private

  def query_terms
    @query_terms ||= terms_for([
      @input_text,
      @ticket&.subject,
      @ticket&.description,
      @ticket&.replies&.where(internal: false)&.order(:created_at)&.pluck(:body)
    ].flatten.join(" "))
  end

  def terms_for(value)
    text = I18n.transliterate(value.to_s).downcase.gsub(/[^a-z0-9]+/, " ")
    words = text.split.filter_map do |word|
      next if word.length < 3 || STOP_WORDS.include?(word)

      word.sub(/(lar|ler|lari|leri|dan|den|tan|ten|nin|nın|nun|nün|in|ın|un|ün|im|um|imiz|umuz|dir|tir|iyor|yor|mis|mış|di|ti|i|ı|u|ü|e|a)\z/, "")
    end

    concepts = CONCEPTS.filter_map do |concept, variants|
      concept if variants.any? { |variant| words.any? { |word| word == variant || word.start_with?(variant) } }
    end.map(&:to_s)

    (words + concepts).uniq
  end

  def overlap_score(left, right)
    shared = left & right
    (shared.length * 2) + (shared.count { |term| CONCEPTS.key?(term.to_sym) } * 2)
  end
end
