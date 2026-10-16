module ApplicationHelper
  def status_label(status)
    I18n.t("tickets.status_#{status}", default: status)
  end

  def priority_label(priority)
    I18n.t("tickets.priority_#{priority}", default: priority)
  end

  def display_assignee(name)
    name.presence || I18n.t("tickets.unassigned")
  end

  def sla_label(ticket)
    I18n.t("sla.#{ticket.sla_state}")
  end

  def initials(name)
    name.to_s.split.map { |part| part[0] }.first(2).join.upcase
  end

  def localized_time_ago(time)
    minutes = ((Time.current - time) / 60).floor
    return I18n.t("time.just_now") if minutes < 1
    return I18n.t("time.minutes", count: minutes) if minutes < 60

    hours = minutes / 60
    return I18n.t("time.hours", count: hours) if hours < 24

    I18n.t("time.days", count: hours / 24)
  end

  def role_label(role)
    I18n.t("nav.#{role}")
  end
end
