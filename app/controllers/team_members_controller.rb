class TeamMembersController < ApplicationController
  before_action :require_admin

  def index
    @members = current_user.organization.users.order(:role, :name)
    @member = current_user.organization.users.new(role: "agent")
  end

  def create
    @member = current_user.organization.users.new(member_params)
    @member.role = params.dig(:user, :role).presence_in(%w[agent requester]) || "requester"

    if @member.save
      redirect_to team_members_path, notice: t("team.member_added", name: @member.name)
    else
      @members = current_user.organization.users.order(:role, :name)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    return if current_user&.admin?

    redirect_to root_path, alert: t("team.admin_only")
  end

  def member_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
