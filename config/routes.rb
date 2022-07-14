Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#login"
  get "/saml/init" => "saml#init"
  post "/saml/consume" => "saml#consume"

end
