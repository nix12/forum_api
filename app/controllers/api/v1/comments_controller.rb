# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  def create
    if params[:comment][:parent_id]
      parent = Comment.find_by(hash_id: params[:comment][:parent_id])
      comment = parent.children.new(comment_params)
      comment.parent_id = parent.hash_id
    else
      comment = Comment.new(comment_params)
    end

    comment.author = current_user

    if comment.save
      comment.upvote_by current_user
      render json: comment, status: :created
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def update
    comment = Comment.friendly.find(params[:hash_id])

    if comment.update_attributes(comment_params)
      render json: comment, status: :no_content
    else
      render json: { errors: comment.errors }, status: :internal_server_error
    end
  end

  def destroy; end

  def upvote
    comment = Comment.friendly.find(params[:hash_id])
    comment.upvote_by current_user
  end

  def downvote
    comment = Comment.friendly.find(params[:hash_id])
    comment.downvote_by current_user
  end

  def unvote
    comment = Comment.friendly.find(params[:hash_id])
    comment.unvote_by current_user
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :commentable_id, :commentable_type, :parent_id)
  end
end
