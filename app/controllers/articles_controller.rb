# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show update edit]

  def create
    id = Articles.new.next_id
    @article = Article.new(
      id,
      params[:name],
      params[:author],
      params[:content],
      Time.now
    ).create

    # sleep before article creates in elastic
    sleep 1
    redirect_to article_path(id)
  end

  def edit; end

  def index
    @articles = Articles.new.articles.paginate(page: params[:page])
  end

  def new; end

  def search
    @articles = Articles.search(search_params)
  end

  def show; end

  def update
    @article.content = content_params[:content]
    @article.update

    # sleep before article create in elastic
    # need move that in redis
    sleep 1
    redirect_to article_path(@article.id)
  end

  private

  def content_params
    params.require(:article).permit(:content)
  end

  def find_article
    @article = Articles.new.find(params[:id])
    raise ActionController::RoutingError, 'Not Found' if @article.nil?

    @article
  end

  def search_params
    params.require(:q) if params[:q].present?
  end
end
