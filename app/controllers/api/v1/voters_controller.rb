# frozen_string_literal: true

class Api::V1::VotersController < ApplicationController
  def show
    voter = Voter.find(params[:username])

    render json: voter, status: :ok
  end
end
