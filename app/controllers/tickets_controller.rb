class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show assign open solve reopen replies]

  def index
    @filter = params[:filter].presence_in(%w[all new open solved]) || "all"
    @tickets = Ticket.includes(:replies).ordered_for_attention
    @tickets = @tickets.where(status: @filter) unless @filter == "all"
    @tickets = @tickets.where("subject LIKE :q OR requester_name LIKE :q OR requester_email LIKE :q", q: "%#{Ticket.sanitize_sql_like(params[:q].to_s)}%") if params[:q].present?
    @counts = Ticket.group(:status).count
  end

  def show
    @reply = @ticket.replies.new
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      redirect_to @ticket, notice: "Talep kuyruğa eklendi. İlk yanıt için 4 saatlik süre başladı."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def assign
    if @ticket.update(assignee: params[:assignee])
      redirect_to @ticket, notice: "Talep #{helpers.display_assignee(@ticket.assignee)} kişisine atandı."
    else
      redirect_to @ticket, alert: "Geçerli bir ekip üyesi seç."
    end
  end

  def open
    @ticket.open! ? redirect_to(@ticket, notice: "Talep açıldı.") : redirect_to(@ticket, alert: "Bu talep açılamıyor.")
  end

  def solve
    @ticket.solve! ? redirect_to(@ticket, notice: "Talep çözüldü.") : redirect_to(@ticket, alert: "Önce talebi aç, sonra çözüldü olarak işaretle.")
  end

  def reopen
    @ticket.reopen! ? redirect_to(@ticket, notice: "Talep yeniden açıldı.") : redirect_to(@ticket, alert: "Bu talep yeniden açılamıyor.")
  end

  def replies
    @reply = @ticket.replies.new(reply_params.merge(author_name: "Ece Demir", internal: false))
    if @ticket.status == "solved"
      redirect_to @ticket, alert: "Yanıt göndermeden önce talebi yeniden aç."
    elsif @reply.save
      redirect_to @ticket, notice: "Yanıt gönderildi. İlk yanıt süresi kaydedildi."
    else
      flash.now[:alert] = "Yanıt boş olamaz."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:requester_name, :requester_email, :subject, :description, :priority)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end
end
