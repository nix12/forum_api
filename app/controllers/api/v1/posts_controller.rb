# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  before_action :set_post, except: %i[index create show]
  before_action :update_rules, only: %i[create show]

  def index
    @posts = Post.all

    render json: @posts, status: :ok
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.save
      @post.upvote_by current_user
      render json: @post, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def show
    # if current_user
    #   JSON.parse(current_user.rules).each do |rule|
    #     next unless rule['actions'][0] == 'manage' &&
    #                 rule['subject'][0] == 'Post'

    #     @post = Post.with_deleted.friendly.find(params[:hash_id])

    #     render json: {
    #       post: @post,
    #       comments: nested_comments(@post)
    #     }, status: :ok
    #   end
    # else
      @post = Post.friendly.find(params[:hash_id])

      render json: {
        post: @post,
        comments: nested_comments(@post)
      }, status: :ok
    # end
  end

  def update
    if @post.update_attributes(post_params)
      render json: @post, status: :no_content
    else
      render json: { errors: @post.errors }, status: :internal_server_error
    end
  end

  def destroy
    @post.destroy if @post.present?
  end

  def upvote
    @post.upvote_by current_user
  end

  def downvote
    @post.downvote_by current_user
  end

  def unvote
    @post.unvote_by current_user
  end

  private

  def set_post
    @post = Post.friendly.find(params[:hash_id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :jet_id)
  end

  def nested_comments(post)
    comments = []

    post.comments.map do |comments_branch|
      comments << comments_branch.subtree.arrange_serializable(order: :cached_votes_score)
    end

    comments
  end
end
