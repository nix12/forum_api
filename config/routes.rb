require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :j, controller: 'jets', only: [:create, :update, :show, :destroy] do
        namespace :comments do
          resources :posts, path: '', param: :hashid, only: [:create, :update, :show, :destroy]
        end
      end
    end
  end
end
