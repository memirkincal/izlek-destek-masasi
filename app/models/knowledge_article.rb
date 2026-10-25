class KnowledgeArticle < ApplicationRecord
  belongs_to :organization

  LOCALES = %w[tr en].freeze

  validates :locale, inclusion: { in: LOCALES }
  validates :source_key, presence: true, uniqueness: { scope: [ :organization_id, :locale ] }
  validates :title, presence: true, length: { maximum: 120 }
  validates :terms, :body, :reply, presence: true
  validates :terms, length: { maximum: 1_000 }
  validates :body, :reply, length: { maximum: 4_000 }

  scope :published, -> { where(published: true) }

  before_validation :assign_source_key, on: :create

  def self.seed_defaults_for(organization)
    templates = YAML.safe_load_file(Rails.root.join("config/support_knowledge.yml"), aliases: false)
    templates.each do |locale, articles|
      articles.each do |article|
        organization.knowledge_articles.create!(
          locale: locale,
          source_key: article.fetch("id"),
          title: article.fetch("title"),
          terms: article.fetch("terms"),
          body: article.fetch("body"),
          reply: article.fetch("reply"),
          published: true
        )
      end
    end
  end

  private

  def assign_source_key
    self.source_key ||= SecureRandom.hex(8)
  end
end
