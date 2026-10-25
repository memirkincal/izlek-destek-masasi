class SupportAgentController < ApplicationController
  before_action :require_requester

  def show
    @message = ""
    prepare_assistant_state
  end

  def respond
    raw_message = params[:message].to_s.strip
    redaction = PrivacyMasker.call(raw_message)
    @message = redaction.text
    @redacted_types = redaction.types
    prepare_assistant_state

    if raw_message.blank? || raw_message.length > 2_000
      @error = t(raw_message.blank? ? "assistant.message_required" : "assistant.message_too_long")
      render :show, status: :unprocessable_entity
      return
    end

    @assistant = TicketAssistant.new(nil, organization: current_user.organization, text: @message)
    @related_tickets = @assistant.related_tickets

    if params[:handoff] == "1"
      create_handoff_ticket
    elsif @gemini_configured
      answer_with_gemini
    else
      answer_with_local_matcher
    end
  end

  private

  def prepare_assistant_state
    @gemini_configured = GeminiSupportAssistant.configured?
    @assistant_mode = @gemini_configured ? :gemini_ready : :local
  end

  def answer_with_gemini
    result = GeminiSupportAssistant.call(
      text: @message,
      articles: @assistant.knowledge_articles,
      locale: I18n.locale
    )

    if result.handoff?
      @articles = []
      @handoff_reason = result.reason
      create_handoff_ticket
      return
    end

    source = @assistant.knowledge_articles.find { |article| article.fetch("id") == result.article_id }
    @articles = [ knowledge_result(source, result.answer) ]
    @answer = @articles.first
    @assistant_mode = :gemini
    render :show
  rescue GeminiSupportAssistant::Unavailable => error
    Rails.logger.warn("Gemini support assistant unavailable: #{error.message}")
    @gemini_configured = true
    @assistant_mode = :fallback
    answer_with_local_matcher
  end

  def answer_with_local_matcher
    @assistant ||= TicketAssistant.new(nil, organization: current_user.organization, text: @message)
    @articles = @assistant.knowledge_results

    if @articles.empty?
      create_handoff_ticket
    else
      @answer = @articles.first
      render :show
    end
  end

  def knowledge_result(article, answer)
    TicketAssistant::KnowledgeResult.new(
      id: article.fetch("id"),
      title: article.fetch("title"),
      body: article.fetch("body"),
      reply: answer,
      score: 0
    )
  end

  def create_handoff_ticket
    @ticket = current_user.organization.tickets.new(
      subject: ticket_subject(@message),
      description: @message,
      priority: "normal",
      requester_user: current_user,
      requester_name: current_user.name,
      requester_email: current_user.email_address
    )

    if @ticket.save
      @ticket.replies.create!(
        author_name: t("assistant.agent_name"),
        body: [ t("assistant.handoff_note"), t("assistant.handoff_privacy_note") ].join(" "),
        internal: true
      )
      redirect_to @ticket, notice: t("tickets.assistant_handoff_created")
    else
      @error = @ticket.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def ticket_subject(message)
    first_sentence = message.to_s.split(/[.!?\n]/).first.to_s.squish
    subject = first_sentence.presence || message.to_s.squish
    subject.length > 120 ? "#{subject.first(117).rstrip}…" : subject
  end

  def require_requester
    return if current_user&.requester?

    redirect_to root_path, alert: t("assistant.requester_only")
  end
end
