module ApplicationHelper
  def status_label(status)
    { "new" => "Yeni", "open" => "Açık", "solved" => "Çözüldü" }.fetch(status, status)
  end

  def priority_label(priority)
    { "low" => "Düşük", "normal" => "Normal", "high" => "Yüksek", "urgent" => "Acil" }.fetch(priority, priority)
  end

  def display_assignee(name)
    name.presence || "Atanmadı"
  end

  def sla_label(ticket)
    { on_track: "SLA uygun", at_risk: "Yanıt yaklaşmalı", breached: "Süre aşıldı", responded: "İlk yanıt verildi" }.fetch(ticket.sla_state)
  end

  def initials(name)
    name.to_s.split.map { |part| part[0] }.first(2).join.upcase
  end

  def localized_time_ago(time)
    minutes = ((Time.current - time) / 60).floor
    return "az önce" if minutes < 1
    return "#{minutes} dakika" if minutes < 60

    hours = minutes / 60
    return "#{hours} saat" if hours < 24

    "#{hours / 24} gün"
  end
end
