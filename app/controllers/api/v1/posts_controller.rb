class Api::V1::PostsController < ApplicationController
  def create
    post = Post.new(post_params)

    if post.save
      voter = VotingSession.create(voter_id: current_user.username, post_id: post.hash_id)
      post.upvote_by voter
      render json: post, status: :created
    else
      render json: { errors: post.errors }, status: :unprocessable_entity
    end
  end

  def show
    post = Post.friendly.find(params[:id])
    comments = Comment.where('post_id = ?', post.id).order(:id, commentable_id: :asc)

    render json: {
      post: post,
      comments: comments
    }, status: :ok
  end

  def update
    post = Post.find(post_params)

    if post.save
      render json: post, status: :no_content
    else
      render json: {errors: 'Post update failed.'}, status: :internal_server_error
    end
  end

  def destroy
  end

  def upvote
    post = Post.friendly.find(params[:hash_id])
    voter = VotingSession.where(voter_id: current_user.username, post_id: post.hash_id).first_or_create
    post.upvote_by voter
  end

  def downvote
    post = Post.friendly.find(params[:hash_id])
    voter = VotingSession.where(voter_id: current_user.username, post_id: post.hash_id).first_or_create
    post.downvote_by voter
  end

private

  def post_params
    params.require(:post).permit(:title, :body, :jet_id)
  end
end
