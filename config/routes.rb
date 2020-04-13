Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :historic_exchange_rates, only: [:index] do
          collection do
            get 'last'
          end
        end
        resources :scheduled_jobs, only: [:index, :destroy]
      end
    end
  end
end
