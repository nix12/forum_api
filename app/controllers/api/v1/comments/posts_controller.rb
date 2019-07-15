class Api::V1::Comments::PostsController < ApplicationController
  def create
    post = Post.new(post_params)

    if post.save
      render json: post, status: :created_at
    else
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  def show
    post = Post.find(params[:hashid])
    comments = Comment.where('post_id = ?', post.id).order(:id, commentable_id: :asc)

    render json: {
      post: post,
      comments: comments
    }, status: :ok
  end

  def update
  end

  def destroy
  end

private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
