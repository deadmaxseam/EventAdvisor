Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users, controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  resources :users

# Activities
  post 'events/:event_id/new_activity', to: 'pages#create_activity', as: 'post_new_activity'
  get 'events/:event_id/activities', to: 'pages#show_activities', as: 'show_activities_event'
  get "/pages/toogle_activities/:status/:event", to: 'pages#toogle_activities'
  delete "/pages/remove_activity/:event_id/:id", to: 'pages#remove_activity', as: 'remove_activity'

  
  get "/pages/toogle_guests/:status/:event", to: 'pages#toogle_guests'


# Tasks
  post 'events/:event_id/new_task', to: 'pages#create_task', as: 'post_new_task'
  get 'events/:event_id/tasks', to: 'pages#show_tasks', as: 'show_tasks_event'
  get "/pages/toogle_tasks/:status/:event", to: 'pages#toggle_tasks'
  delete "/pages/remove_task/:event_id/:id", to: 'pages#remove_task', as: 'remove_task'
  put '/task/update/:id', to: 'tasks#update'
  get 'my_tasks', to: 'pages#my_tasks'



# UserEdit
  get 'pages/edit_profile/:id', to: 'pages#edit_profile'
  get '/pages/change/:id', to: 'pages#change'
  put '/pages/update/:field/:id', to: 'pages#update'
  get '/pages/change_password/:id', to: 'pages#change_password'
  put '/pages/password_update/:id', to: 'pages#password_update'

# EventEdit
get '/pages/change_ev/:id', to: 'pages#change_ev'
put '/pages/update_ev/:field/:id', to: 'pages#update_ev'
get '/pages/edit_event/:id', to: 'pages#edit_event'




# Role Management
  post 'events/:event_id/add_guest/:user_id', to: 'pages#add_guest', as: 'add_guest_event'
  delete 'events/:event_id/remove_guest/:user_id', to: 'pages#remove_guest', as: 'remove_guest_event'
  post '/events/:event_id/add_organizer/:user_id', to: 'pages#add_organizer', as: 'add_organizer_event'
  delete '/events/:event_id/remove_organizer/:user_id', to: 'pages#remove_organizer', as: 'remove_organizer_event'

  get 'pages/profile/:id', to: 'pages#profile', as: 'profile'
  get 'events/:id', to: 'pages#show_event', as: 'event'
  delete 'events/:id', to: 'pages#destroy_event', as: 'destroy_event'
  get 'pages/new_event', to: 'pages#new_event', as: 'new_event'
  post 'pages/new_event', to: 'pages#create_event', as: 'post_new_event'
  get 'pages/show_all', to: 'pages#show_all', as: 'show_all'
 
end
