Rails.application.routes.draw do
  require "sidekiq/web"
  require 'sidekiq/cron/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if ['production','staging'].include?(Rails.env)
  mount Sidekiq::Web, at: :queue, as: :queue
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
