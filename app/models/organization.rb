class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :knowledge_articles, dependent: :destroy

  after_create :seed_knowledge_articles

  validates :name, presence: true, length: { maximum: 100 }

  private

  def seed_knowledge_articles
    KnowledgeArticle.seed_defaults_for(self)
  end
end
