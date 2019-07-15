class Api::V1::Comments::CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)

    if comment.save
      render json: comment, status: :created_at
    else
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end

private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
