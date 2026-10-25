class PrivacyMasker
  Result = Struct.new(:text, :types, keyword_init: true)

  REDACTIONS = [
    [ :api_secret, /\b(?:AQ\.[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{30,}|ya29\.[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9_-]{16,}|(?:api[_ -]?key|access[_ -]?token|secret)\s*[:=]\s*[^\s,;]+)/i, "[secret masked]" ],
    [ :email, /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i, "[email masked]" ],
    [ :payment_card, /(?<!\d)(?:\d[ -]?){13,19}(?!\d)/, "[card number masked]" ],
    [ :national_id, /(?<!\d)\d{11}(?!\d)/, "[identity number masked]" ],
    [ :phone, /(?<!\d)(?:\+90|0)?\s*\(?5\d{2}\)?(?:[\s.-]?\d{3})(?:[\s.-]?\d{2})(?:[\s.-]?\d{2})(?!\d)/, "[phone masked]" ]
  ].freeze

  def self.call(text)
    output = text.to_s.dup
    types = []
    REDACTIONS.each do |type, pattern, replacement|
      next unless output.match?(pattern)

      output.gsub!(pattern, replacement)
      types << type
    end
    Result.new(text: output, types: types.freeze)
  end
end
