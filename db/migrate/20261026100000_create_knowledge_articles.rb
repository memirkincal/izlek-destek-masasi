class CreateKnowledgeArticles < ActiveRecord::Migration[8.1]
  class MigrationOrganization < ActiveRecord::Base
    self.table_name = "organizations"
  end

  class MigrationKnowledgeArticle < ActiveRecord::Base
    self.table_name = "knowledge_articles"
  end

  def change
    create_table :knowledge_articles do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :source_key, null: false
      t.string :title, null: false
      t.text :terms, null: false
      t.text :body, null: false
      t.text :reply, null: false
      t.boolean :published, null: false, default: false
      t.timestamps
    end

    add_index :knowledge_articles, [ :organization_id, :locale, :source_key ], unique: true, name: "index_knowledge_articles_on_workspace_locale_source"

    reversible do |direction|
      direction.up do
        templates = YAML.safe_load_file(Rails.root.join("config/support_knowledge.yml"), aliases: false)
        MigrationOrganization.find_each do |organization|
          templates.each do |locale, articles|
            articles.each do |article|
              MigrationKnowledgeArticle.create!(
                organization_id: organization.id,
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
      end
    end
  end
end
