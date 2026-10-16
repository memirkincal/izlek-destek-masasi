class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show assign open solve reopen replies]
  before_action :require_support_staff, only: %i[assign open solve]

  def index
    @filter = params[:filter].presence_in(%w[all new open solved unassigned]) || "all"
    @tickets = visible_tickets.includes(:requester_user, :assignee_user, :replies).ordered_for_attention
    if @filter == "unassigned"
      @tickets = @tickets.active.where(assignee_user_id: nil)
    elsif @filter != "all"
      @tickets = @tickets.where(status: @filter)
    end
    if params[:q].present?
      query = "%#{Ticket.sanitize_sql_like(params[:q].to_s)}%"
      @tickets = @tickets.joins(:requester_user).where("tickets.subject LIKE :q OR users.name LIKE :q OR users.email_address LIKE :q", q: query)
    end
    @counts = visible_tickets.group(:status).count
    @active_count = visible_tickets.active.count
    @risk_count = visible_tickets.active.includes(:replies).count { |ticket| %i[at_risk breached].include?(ticket.sla_state) }
  end

  def show
    @reply = @ticket.replies.new
    @agents = current_user.organization.users.where(role: %w[admin agent]).order(:name)
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params.merge(
      organization: current_user.organization,
      requester_user: current_user,
      requester_name: current_user.name,
      requester_email: current_user.email_address
    ))

    if @ticket.save
      redirect_to @ticket, notice: t("tickets.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def assign
    assignee = current_user.organization.users.where(role: %w[admin agent]).find_by(id: params[:assignee_user_id])
    if params[:assignee_user_id].blank? || assignee
      @ticket.update!(assignee_user: assignee, assignee: assignee&.name)
      redirect_to @ticket, notice: t("tickets.assigned")
    else
      redirect_to @ticket, alert: t("tickets.invalid_assignee")
    end
  end

  def open
    @ticket.open! ? redirect_to(@ticket, notice: t("tickets.opened")) : redirect_to(@ticket, alert: t("tickets.cannot_open"))
  end

  def solve
    @ticket.solve! ? redirect_to(@ticket, notice: t("tickets.solved")) : redirect_to(@ticket, alert: t("tickets.solve_open_first"))
  end

  def reopen
    @ticket.reopen! ? redirect_to(@ticket, notice: t("tickets.reopened")) : redirect_to(@ticket, alert: t("tickets.cannot_reopen"))
  end

  def replies
    if @ticket.status == "solved"
      unless current_user.requester?
        redirect_to @ticket, alert: t("tickets.reopen_before_reply")
        return
      end
    end

    @reply = @ticket.replies.new(reply_params.merge(author_name: current_user.name, user: current_user, internal: false))
    if @reply.valid?
      @ticket.reopen! if @ticket.status == "solved"
      @reply.save!
      redirect_to @ticket, notice: t("tickets.reply_sent")
    else
      @agents = current_user.organization.users.where(role: %w[admin agent]).order(:name)
      flash.now[:alert] = t("tickets.reply_empty")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def visible_tickets
    scope = current_user.organization.tickets
    current_user.requester? ? scope.where(requester_user: current_user) : scope
  end

  def set_ticket
    @ticket = visible_tickets.find(params[:id])
  end

  def require_support_staff
    return if current_user.support_staff?

    redirect_to root_path, alert: t("tickets.staff_only")
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :priority)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end
end
