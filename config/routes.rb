# frozen_string_literal: true

# Copyright (C) 2025 Zachary Bensley
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home_page#index"

  resource :session
  resources :passwords, param: :token

  namespace :api do
    namespace :v3 do
      resource :session, only: [:create, :destroy]

      resources :modules, param: :slug, only: [:index, :show, :destroy]
      patch "modules/:slug", to: "modules#deprecate", as: :module_deprecate

      resources :releases, param: :slug, only: [:index, :create, :destroy]
      get "releases/:slug", to: "releases#show", as: :release_show, format: false, constraints: {slug: /[A-Za-z0-9.\-]+/}

      resources :search_filters, only: [:index, :show, :destroy]
      resources :users, param: :slug, only: [:index, :show]
    end
  end
end
