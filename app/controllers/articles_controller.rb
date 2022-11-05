class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  def index
    @articles = Article.all.paginate(page: params[:page])
  end

  def search
    @articles = Article.search(search_params).records
  end

  def show; end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params_create)
    if @article.save
      redirect_to article_url(@article)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params_update)
      redirect_to article_url(@article)
    else
      render :edit
    end
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end
  def article_params_create
    params.require(:article).permit(:name, :content, :author)
  end
  def article_params_update
    params.require(:article).permit(:content)
  end
  def search_params
    params.require(:q) if params[:q].present?
  end
end
