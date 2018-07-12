class HomeController < ApplicationController
  def index
  end

  def new
    @p = Post.first
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to '/home/new'
  end
  
  private  # 컨트롤러안에서만 사용하는 메소드
  def post_params
     params.require(:post).permit(:title, :lat, :lng)
  end
end
