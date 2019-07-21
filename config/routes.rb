# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :jets, only: %i[create update show destroy] do
        resources :posts, param: :hash_id, only: %i[create update show destroy] do
          member do
            put 'upvote', to: 'posts#upvote'
            put 'downvote', to: 'posts#downvote'
          end

          resources :comments, param: :hash_id, only: %i[create update destroy] do
            member do
              put 'upvote', to: 'comments#upvote'
              put 'downvote', to: 'comments#downvote'
            end
          end
        end
      end
    end
  end
end
