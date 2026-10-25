class KnowledgeArticlesController < ApplicationController
  before_action :require_support_staff
  before_action :require_admin, except: :index
  before_action :set_article, only: %i[edit update]

  def index
    @locale = params[:language].presence_in(KnowledgeArticle::LOCALES) || I18n.locale.to_s
    @articles = current_user.organization.knowledge_articles.where(locale: @locale).order(published: :desc, title: :asc)
  end

  def new
    @article = current_user.organization.knowledge_articles.new(locale: params[:language].presence_in(KnowledgeArticle::LOCALES) || I18n.locale.to_s)
  end

  def create
    @article = current_user.organization.knowledge_articles.new(article_params)
    if @article.save
      redirect_to knowledge_articles_path(language: @article.locale), notice: t("knowledge.saved")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to knowledge_articles_path(language: @article.locale), notice: t("knowledge.saved")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:knowledge_article).permit(:locale, :title, :terms, :body, :reply, :published)
  end

  def set_article
    @article = current_user.organization.knowledge_articles.find(params[:id])
  end

  def require_support_staff
    return if current_user.support_staff?

    redirect_to root_path, alert: t("knowledge.staff_only")
  end

  def require_admin
    return if current_user.admin?

    redirect_to knowledge_articles_path, alert: t("knowledge.admin_only")
  end
end
