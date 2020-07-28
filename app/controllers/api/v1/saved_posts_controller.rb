# frozen_string_literal: true

class Api::V1::SavedPostsController < ApplicationController
  before_action :set_type, only: %i[destroy]

  def index
    @saved_posts = SavedPost.where(voter_id: params[:voter_id])

    render 'saved_posts/index.json.jbuilder', status: :ok
  end

  def create
    @saved_post = SavedPost.new(saved_post_params)

    if @saved_post.save
      render 'saved_posts/create.json.jbuilder', status: :created
    else
      render json: { errors: @saved_post.errors }
    end
  end

  def destroy
    @saved_post.destroy if @saved_post.present?
  end

  private

  def saved_post_params
    params.require(:saved_post).permit(:post_id, :comment_id, :voter_id)
  end

  def set_type
    @saved_post = if params[:saved_post][:comment_id]
                    puts '+++Comment+++'
                    p Comment.friendly.find(params[:saved_post][:comment_id])
                    Comment.friendly.find(params[:saved_post][:comment_id])
                  else
                    puts '+++Post+++'
                    p Post.friendly.find(params[:saved_post][:post_id])
                    Post.friendly.find(params[:saved_post][:post_id])
    end
  end
end
