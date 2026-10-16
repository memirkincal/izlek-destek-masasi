class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 5, within: 1.hour, only: :create, with: -> { redirect_to new_registration_path, alert: I18n.t("auth.too_many_signups") }

  def new
    @user = User.new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(name: params.dig(:organization, :name))
    @user = @organization.users.new(registration_params.merge(role: "admin"))

    if @organization.valid? && @user.valid?
      Organization.transaction do
        @organization.save!
        @user.organization = @organization
        @user.save!
      end
      start_new_session_for @user
      redirect_to root_path, notice: t("auth.account_created")
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email_address, :taken)
    render :new, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
