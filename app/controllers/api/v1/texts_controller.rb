# frozen_string_literal: true

class Api::V1::TextsController < ApplicationController
  before_action :set_text, except: %i[index create show]
  before_action :update_rules, only: %i[create show]

  def index
    @texts = Text.all

    render json: @texts, status: :ok
  end

  def create
    @text = Text.new(text_params)
    @text.author = current_user

    if @text.save
      @text.upvote_by current_user
      render json: @text, status: :created
    else
      render json: { errors: @text.errors }, status: :unprocessable_entity
    end
  end

  def show
    # if current_user
    #   JSON.parse(current_user.rules).each do |rule|
    #     next unless rule['actions'][0] == 'manage' &&
    #                 rule['subject'][0] == 'Text'

    #     @text = Text.with_deleted.friendly.find(params[:hash_id])

    #     render json: {
    #       text: @text,
    #       comments: nested_comments(@text)
    #     }, status: :ok
    #   end
    # else
      @text = Text.friendly.find(params[:hash_id])

      render json: {
        text: @text,
        comments: nested_comments(@text)
      }, status: :ok
    # end
  end

  def update
    if @text.update_attributes(text_params)
      render json: @text, status: :no_content
    else
      render json: { errors: @text.errors }, status: :internal_server_error
    end
  end

  def destroy
    @text.destroy if @text.present?
  end

  def upvote
    @text.upvote_by current_user
  end

  def downvote
    @text.downvote_by current_user
  end

  def unvote
    @text.unvote_by current_user
  end

  private

  def set_text
    @text = Text.friendly.find(params[:hash_id])
  end

  def text_params
    params.require(:text).permit(:title, :body, :jet_id)
  end

  def nested_comments(text)
    comments = []

    text.comments.map do |comments_branch|
      comments << comments_branch.subtree.arrange_serializable(order: :cached_votes_score)
    end

    comments
  end
end
