# frozen_string_literal: true

class Api::V1::SavedCommentsController < ApplicationController
  before_action :set_type, only: %i[destroy]

  def index
    @saved_comment = SavedComment.where(voter_id: params[:voter_id])

    render 'saved_comment/index.json.jbuilder', status: :ok
  end

  def create
    @saved_post = SavedComment.new(saved_post_params)

    if @saved_post.save
      render 'saved_comment/create.json.jbuilder', status: :created
    else
      render json: { errors: @saved_post.errors }
    end
  end

  def destroy
    @saved_post.destroy if @saved_post.present?
  end

  private

  def saved_post_params
    params.require(:saved_post).permit(:comment_id, :voter_id)
  end

  def set_type
    @saved_post = Comment.friendly.find(params[:saved_post][:comment_id])
  end
end
