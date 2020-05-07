# frozen_string_literal: true

class Api::V1::LinksController < ApplicationController
  before_action :set_link, except: %i[index create show]
  before_action :update_rules, only: %i[create show]

  def index
    @links = Link.all

    render json: @links, status: :ok
  end

  def create
    @link = Link.new(link_params)
    @link.author = current_user

    if @link.save
      @link.upvote_by current_user
      render json: @link, status: :created
    else
      render json: { errors: @link.errors }, status: :unprocessable_entity
    end
  end

  def show
    @link = Link.friendly.find(params[:hash_id])
    
    render json: {
      link: @link,
      comments: nested_comments(@link)
    }, status: :ok
  end

  def update
    if @link.update_attributes(post_params)
      render json: @link, status: :no_content
    else
      render json: { errors: @link.errors }, status: :internal_server_error
    end
  end

  def destroy
    @link.destroy if @link.present?
  end

  def upvote
    @link.upvote_by current_user
  end

  def downvote
    @link.downvote_by current_user
  end

  def unvote
    @link.unvote_by current_user
  end

  private

  def set_link
    @link = Link.friendly.find(params[:hash_id])
  end

  def link_params
    params.require(:link).permit(:title, :uri, :jet_id)
  end

  def nested_comments(link)
    comments = []

    link.comments.map do |comments_branch|
      comments << comments_branch.subtree.arrange_serializable(order: :cached_votes_score)
    end

    comments
  end
end
