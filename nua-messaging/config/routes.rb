Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages do
    get 'new_reply', on: :member
    post 'create_reply', on: :member
  end
end
