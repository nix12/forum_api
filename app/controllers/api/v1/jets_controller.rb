# frozen_string_literal: true

class Api::V1::JetsController < ApplicationController
  def create
    jet = Jet.new(jet_params)

    if jet.save
      render json: jet, status: :created_at
    else
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  def show
    jet = Jet.friendly.find(params[:id])
    posts = jet.posts

    render json: posts, status: :ok
  end

  def update; end

  def destroy; end

  private

  def jet_params
    params.require(:jet).permit(:name)
  end
end
