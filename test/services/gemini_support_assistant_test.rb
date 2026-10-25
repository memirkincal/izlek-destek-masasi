require "test_helper"
require "net/http"

class GeminiSupportAssistantTest < ActiveSupport::TestCase
  test "sends a structured Interactions request and parses the selected source" do
    article = {
      "id" => "invoice-download",
      "title" => "Fatura",
      "body" => "Fatura bağlantısını yeni sekmede açın.",
      "reply" => "Bağlantıyı yeni sekmede deneyin."
    }
    model_output = { decision: "answer", article_id: "invoice-download", answer: "Bağlantıyı yeni sekmede deneyin.", reason: "Fatura kaynağı" }
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@read, true)
    response.instance_variable_set(:@body, JSON.generate(
      status: "completed",
      steps: [ { type: "model_output", content: [ { type: "text", text: JSON.generate(model_output) } ] } ]
    ))

    captured_request = nil
    fake_http = Object.new
    fake_http.define_singleton_method(:request) do |http_request|
      captured_request = http_request
      response
    end

    original_start = Net::HTTP.method(:start)
    original_key = ENV["GEMINI_API_KEY"]
    ENV["GEMINI_API_KEY"] = "fake-test-key"
    Net::HTTP.define_singleton_method(:start) do |*_args, **_options, &block|
      block.call(fake_http)
    end

    result = GeminiSupportAssistant.call(text: "Faturamı indiremedim", articles: [ article ], locale: :tr)
    payload = JSON.parse(captured_request.body)

    assert_equal "invoice-download", result.article_id
    assert_equal "Bağlantıyı yeni sekmede deneyin.", result.answer
    assert_equal "fake-test-key", captured_request["x-goog-api-key"]
    assert_equal false, payload["store"]
    assert_equal "gemini-3.5-flash-lite", payload["model"]
    assert_equal "application/json", payload.dig("response_format", "mime_type")
    assert_includes payload.dig("response_format", "schema", "properties", "article_id", "enum"), "invoice-download"
    assert_includes payload["input"], "Faturamı indiremedim"
  ensure
    Net::HTTP.define_singleton_method(:start, original_start) if original_start
    ENV["GEMINI_API_KEY"] = original_key
  end

  test "retries a temporary Gemini outage before using the answer" do
    article = { "id" => "invoice-download", "title" => "Fatura", "body" => "Yeni sekmede açın.", "reply" => "Yeni sekmede açın." }
    unavailable = Net::HTTPServiceUnavailable.new("1.1", "503", "Unavailable")
    success = Net::HTTPOK.new("1.1", "200", "OK")
    success.instance_variable_set(:@read, true)
    success.instance_variable_set(:@body, JSON.generate(
      status: "completed",
      steps: [ { type: "model_output", content: [ { type: "text", text: JSON.generate(
        decision: "answer", article_id: "invoice-download", answer: "Yeni sekmede açın.", reason: "Fatura kaynağı"
      ) } ] } ]
    ))

    requests = 0
    fake_http = Object.new
    fake_http.define_singleton_method(:request) do |_request|
      requests += 1
      requests == 1 ? unavailable : success
    end

    original_start = Net::HTTP.method(:start)
    original_key = ENV["GEMINI_API_KEY"]
    ENV["GEMINI_API_KEY"] = "fake-test-key"
    Net::HTTP.define_singleton_method(:start) do |*_args, **_options, &block|
      block.call(fake_http)
    end

    assistant = GeminiSupportAssistant.new(text: "Faturamı indiremedim", articles: [ article ], locale: :tr)
    assistant.define_singleton_method(:sleep) { |_seconds| }
    result = assistant.call

    assert_equal 2, requests
    assert_equal "invoice-download", result.article_id
    assert_equal "Yeni sekmede açın.", result.answer
  ensure
    Net::HTTP.define_singleton_method(:start, original_start) if original_start
    ENV["GEMINI_API_KEY"] = original_key
  end
end
