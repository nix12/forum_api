class Api::V1::CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)

    if comment.save
      voter = VotingSession.create(voter_id: current_user.username, comment_id: comment.hash_id)
      comment.upvote_by voter
      render json: comment, status: :created
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def update
    comment = Comment.find(comment_params)

    if comment.save
      render json: comment, status: :no_content
    else
      render json: {error: 'Comment update failed.'}, status: :internal_server_error
    end
  end

  def destroy
  end

  def upvote
    comment = Comment.friendly.find(params[:hash_id])
    voter = VotingSession.where(voter_id: current_user.username, comment_id: comment.hash_id).first_or_create
    comment.upvote_by voter
  end

  def downvote
    comment = Comment.friendly.find(params[:hash_id])
    voter = VotingSession.where(voter_id: current_user.username, comment_id: comment.hash_id).first_or_create
    comment.downvote_by voter
  end

private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :commentable_id, :commentable_type)
  end
end
