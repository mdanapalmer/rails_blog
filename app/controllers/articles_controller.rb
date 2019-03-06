class ArticlesController < ApplicationController
  
  http_basic_authenticate_with name: "dhh", password: "secret",
except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    #The reason why we added @article = Article.new in the 
    #ArticlesController is that otherwise @article would be nil in our 
    #view, and calling @article.errors.any? would throw an error.
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render 'new'
      #we use render instead of redirect_to when save returns false. 
      #The render method is used so that the @article object is passed 
      #back to the new template when it is rendered. This rendering is 
      #done within the same request as the form submission, whereas the 
      #redirect_to will tell the browser to issue another request.
  end
end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

private
  def article_params
    params.require(:article).permit(:title, :text)
    #We have to whitelist our controller parameters to prevent wrongful
    #mass assignment. In this case, we want to both allow and require
    #the title and text parameters for valid use of create.
    #The syntax for this introduces require and permit.
  end
end

