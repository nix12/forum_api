# frozen_string_literal: true

require 'jwt'
require 'json'

class ApplicationController < ActionController::API
  def current_user
    data = nil

    if request.headers['HTTP_ACCESS_TOKEN']
      data = JWT.decode(
        request.headers['HTTP_ACCESS_TOKEN'],
        Rails.application.credentials.jwt_secret,
        true,
        algorithm: 'HS512'
      )[0]
    end

    @current_user = data ? Voter.find_or_create_by(username: data['username']) : nil
  end

  def update_rules
    if request.headers['HTTP_ACCESS_TOKEN']
      data = JWT.decode(
        request.headers['HTTP_ACCESS_TOKEN'],
        Rails.application.credentials.jwt_secret,
        true,
        algorithm: 'HS512'
      )[0]
    end

    current_user&.update(rules: data['rules'].to_json)
  end
end
