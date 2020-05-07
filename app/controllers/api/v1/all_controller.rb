# frozen_string_literal: true

class Api::V1::AllController < ApplicationController
  def all
    @all = (Text.all + Link.all).sort_by do |text|
      [text.cached_votes_score, text.created_at]
    end.reverse!

    render json: @all, status: :ok
  end
end
