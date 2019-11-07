# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :jets, only: %i[index create update show] do
        resources :posts, param: :hash_id, only: %i[create update show destroy] do
          member do
            put 'upvote', to: 'posts#upvote'
            put 'downvote', to: 'posts#downvote'
            put 'unvote', to: 'posts#unvote'
          end

          resources :comments, param: :hash_id, only: %i[create update destroy] do
            member do
              put 'upvote', to: 'comments#upvote'
              put 'downvote', to: 'comments#downvote'
              put 'unvote', to: 'comments#unvote'
            end
          end
        end
      end

      resources :voters, param: :username, only: [:show]
    end
  end
end
