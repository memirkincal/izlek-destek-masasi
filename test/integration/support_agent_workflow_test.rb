require "test_helper"

class SupportAgentWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:two))
  end

  test "local source answer masks email without opening a ticket" do
    stub_class_method(GeminiSupportAssistant, :configured?, -> { false }) do
      assert_no_difference "Ticket.count" do
        post support_agent_path, params: { message: "Faturamı indiremedim. E-posta adresim demo@example.com" }
      end
    end

    assert_response :success
    assert_select ".agent-answer-source", /Fatura PDF'i indirme/
    assert_select ".agent-ai-state", /Yerel bilgi bankası modu/
    assert_includes response.body, "[email masked]"
    assert_not_includes response.body, "demo@example.com"
  end

  test "unknown issue opens a private handoff ticket" do
    stub_class_method(GeminiSupportAssistant, :configured?, -> { false }) do
      assert_difference [ "Ticket.count", "Reply.count" ], 1 do
        post support_agent_path, params: { message: "Valizimin tekerleği koptu. Bana demo@example.com üzerinden ulaşın." }
      end
    end

    ticket = Ticket.order(:id).last
    assert_redirected_to ticket_path(ticket)
    assert_equal users(:two), ticket.requester_user
    assert_includes ticket.description, "[email masked]"
    assert ticket.replies.last.internal?

    get ticket_path(ticket)
    assert_not_includes response.body, I18n.t("assistant.handoff_note")

    sign_out
    sign_in_as(users(:one))
    get ticket_path(ticket)
    assert_includes response.body, I18n.t("assistant.handoff_note")
  end

  test "Gemini answer appears only with a validated local source" do
    result = GeminiSupportAssistant::Result.new(article_id: "invoice-download", answer: "Faturayı yeni sekmede açıp indirme simgesini deneyin.", reason: "invoice source")
    request_to_model = nil

    stub_class_method(GeminiSupportAssistant, :configured?, -> { true }) do
      stub_class_method(GeminiSupportAssistant, :call, ->(**kwargs) { request_to_model = kwargs; result }) do
        assert_no_difference "Ticket.count" do
          post support_agent_path, params: { message: "Faturamı indiremedim, e-postam demo@example.com" }
        end
      end
    end

    assert_response :success
    assert_includes request_to_model[:text], "[email masked]"
    assert_not_includes request_to_model[:text], "demo@example.com"
    assert_select ".agent-ai-state", /Gemini yanıtı/
    assert_select ".agent-answer-source", /Fatura PDF'i indirme/
    assert_includes response.body, result.answer
  end

  test "Gemini failure uses visibly labeled local fallback" do
    unavailable = ->(**_kwargs) { raise GeminiSupportAssistant::Unavailable, "simulated outage" }

    stub_class_method(GeminiSupportAssistant, :configured?, -> { true }) do
      stub_class_method(GeminiSupportAssistant, :call, unavailable) do
        post support_agent_path, params: { message: "Faturamı indiremedim" }
      end
    end

    assert_response :success
    assert_select ".agent-ai-state", /yerel yedek/
    assert_select ".agent-answer-source", /Fatura PDF'i indirme/
  end

  test "Gemini handoff decision creates a ticket" do
    result = GeminiSupportAssistant::Result.new(article_id: "none", answer: "", reason: "No matching source")

    stub_class_method(GeminiSupportAssistant, :configured?, -> { true }) do
      stub_class_method(GeminiSupportAssistant, :call, ->(**_kwargs) { result }) do
        assert_difference "Ticket.count", 1 do
          post support_agent_path, params: { message: "Valizim kayboldu" }
        end
      end
    end

    assert_redirected_to ticket_path(Ticket.order(:id).last)
  end

  test "internal note stays hidden from requester and does not stop SLA" do
    requester = users(:two)
    ticket = requester.organization.tickets.create!(
      requester_user: requester,
      requester_name: requester.name,
      requester_email: requester.email_address,
      subject: "Oturum sorunu",
      description: "Mobil oturumum kapanıyor"
    )

    sign_out
    sign_in_as(users(:one))
    post replies_ticket_path(ticket), params: { reply: { body: "Yalnızca ekibin göreceği not", internal: "1" } }

    assert_redirected_to ticket_path(ticket)
    assert ticket.replies.last.internal?
    assert_nil ticket.reload.first_response_at

    sign_out
    sign_in_as(requester)
    get ticket_path(ticket)
    assert_not_includes response.body, "Yalnızca ekibin göreceği not"
  end

  test "public reply with a secret pattern requires confirmation" do
    requester = users(:two)
    ticket = requester.organization.tickets.create!(
      requester_user: requester,
      requester_name: requester.name,
      requester_email: requester.email_address,
      subject: "Güvenlik kontrolü",
      description: "İncelenmesini istiyorum"
    )

    sign_out
    sign_in_as(users(:one))

    assert_no_difference "Reply.count" do
      post replies_ticket_path(ticket), params: { reply: { body: "API key: fake-demo-token", internal: "0" } }
    end
    assert_response :unprocessable_entity
    assert_select ".reply-safety-warning"

    assert_difference "Reply.count", 1 do
      post replies_ticket_path(ticket), params: { reply: { body: "API key: fake-demo-token", internal: "0" }, confirm_sensitive_send: "1" }
    end
    assert_redirected_to ticket_path(ticket)
  end

  private

  def stub_class_method(klass, name, implementation)
    original = klass.method(name)
    klass.define_singleton_method(name, &implementation)
    yield
  ensure
    klass.define_singleton_method(name, original)
  end
end
