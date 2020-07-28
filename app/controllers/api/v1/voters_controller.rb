# frozen_string_literal: true

class Api::V1::VotersController < ApplicationController
  before_action :set_voter, only: %i[show upvoted downvoted post_history]

  def show
    render json: @voter, status: :ok
  end

  def upvoted
    render 'voters/upvoted.json.jbuilder', status: :ok
  end

  def downvoted
    render 'voters/downvoted.json.jbuilder', status: :ok
  end

  def post_history
    render 'voters/post_history.json.jbuilder', status: :ok
  end

  private

  def set_voter
    @voter = Voter.find(params[:username])
  end
end
