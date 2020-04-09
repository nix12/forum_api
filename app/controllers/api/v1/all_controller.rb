# frozen_string_literal: true

class Api::V1::AllController < ApplicationController
  def all
    @all = (Post.all + Link.all).sort_by do |post|
      [post.cached_votes_score, post.created_at]
    end.reverse!

    render json: @all, status: :ok
  end
end
