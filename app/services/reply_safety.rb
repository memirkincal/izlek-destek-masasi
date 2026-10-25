class ReplySafety
  CHECKS = [
    [ :national_id, /\b\d{11}\b/ ],
    [ :payment_card, /\b(?:\d[ -]?){13,19}\b/ ],
    [ :secret, /\b(?:AQ\.[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{30,}|ya29\.[A-Za-z0-9_-]{20,}|(?:api[_ -]?key|secret|access[_ -]?token)\s*[:=]\s*\S+)/i ]
  ].freeze

  def self.warnings(text)
    body = text.to_s
    CHECKS.filter_map { |name, pattern| name if body.match?(pattern) }
  end
end
