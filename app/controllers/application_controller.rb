# frozen_string_literal: true

require 'jwt'
require 'ostruct'

class ApplicationController < ActionController::API
  def current_user
    data = JWT.decode(
      request.headers['HTTP_ACCESS_TOKEN'],
      Rails.application.credentials.jwt_secret,
      true,
      algorithm: 'HS512'
    )[0]
    struct_data = OpenStruct.new(data)
    @current_user ||= struct_data
  end
end
