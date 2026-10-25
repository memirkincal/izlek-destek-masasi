require "test_helper"

class KnowledgeBaseWorkflowTest < ActionDispatch::IntegrationTest
  test "a new workspace receives localized starter sources" do
    assert_difference "Organization.count", 1 do
      assert_difference "KnowledgeArticle.count", 8 do
        post registrations_path, params: {
          organization: { name: "New demo workspace" },
          user: { name: "Demo Admin", email_address: "new-admin@example.com", password: "password123", password_confirmation: "password123" }
        }
      end
    end

    assert_redirected_to root_path
    organization = Organization.order(:id).last
    assert_equal 4, organization.knowledge_articles.published.where(locale: "tr").count
    assert_equal 4, organization.knowledge_articles.published.where(locale: "en").count
  end

  test "requester sees an obvious assistant entry but cannot open the knowledge base" do
    sign_in_as(users(:two))

    get root_path
    assert_select ".assistant-entry a[href='#{support_agent_path}']", 1

    get new_ticket_path
    assert_select ".assistant-entry a[href='#{support_agent_path}']", 1

    get knowledge_articles_path
    assert_redirected_to root_path
  end

  test "admin can draft and publish a source used by the assistant" do
    sign_in_as(users(:one))

    assert_difference "KnowledgeArticle.count", 1 do
      post knowledge_articles_path, params: { knowledge_article: {
        locale: "tr", title: "Demo garanti belgesi", terms: "garanti belge sertifika",
        body: "Garanti belgesi Hesabım bölümünden indirilir.",
        reply: "Hesabım bölümünden garanti belgesini indirebilirsin.", published: "0"
      } }
    end

    article = KnowledgeArticle.order(:id).last
    assert_redirected_to knowledge_articles_path(language: "tr")
    assert_not article.published?
    assert_empty TicketAssistant.new(nil, organization: users(:one).organization, text: "Garanti kaydım nerede?").knowledge_results

    patch knowledge_article_path(article), params: { knowledge_article: { published: "1" } }
    assert_redirected_to knowledge_articles_path(language: "tr")
    assert article.reload.published?
    assert_equal article.source_key, TicketAssistant.new(nil, organization: users(:one).organization, text: "Garanti kaydım nerede?").knowledge_results.first.id

    other_organization = Organization.create!(name: "Other test workspace")
    assert_not_includes other_organization.knowledge_articles.pluck(:source_key), article.source_key
  end

  test "agent reads the knowledge base but cannot change sources" do
    agent = users(:one).organization.users.create!(name: "Fixture Agent", email_address: "agent@example.com", role: "agent", password: "password")
    sign_in_as(agent)

    get knowledge_articles_path
    assert_response :success
    assert_select ".knowledge-card", 4
    assert_select "a[href='#{new_knowledge_article_path}']", 0

    post knowledge_articles_path, params: { knowledge_article: { locale: "tr", title: "Unauthorized" } }
    assert_redirected_to knowledge_articles_path
  end
end
