# frozen_string_literal: true

class Api::V1::JetsController < ApplicationController
  before_action :set_jet, except: %i[index create]
  before_action :update_rules, only: %i[create show]

  def index
    @jets = Jet.all

    render json: @jets, status: :ok
  end

  def create
    @jet = Jet.new(jet_params)
    @jet.owner = current_user

    if @jet.save
      render json: @jet, status: :created
    else
      render json: { errors: @jet.errors }, status: :unprocessable_entity
    end
  end

  def show
    # puts '-----'
    # puts current_user
    # puts '-----'
    # if current_user
    #   puts 'REGULAR AND DELETED POSTS'
    #   JSON.parse(current_user.rules).each do |rule|
    #     next unless rule['actions'][0] == 'manage' &&
    #                 rule['subject'][0] == 'Text'

    #     posts = @jet.posts.with_deleted

    #     render json: posts, status: :ok
    #   end
    # else
      # puts 'REGULAR POSTS'
      posts = Text.fetch_texts_and_links(@jet)

      render json: posts, status: :ok
    # end
  end

  private

  def set_jet
    @jet = Jet.friendly.find(params[:id])
  end

  def jet_params
    params.require(:jet).permit(:name, :description)
  end
end
