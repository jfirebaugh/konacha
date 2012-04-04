Konacha::Engine.routes.draw do
  match "/"     => "specs#specs"
  match "*path" => "specs#specs"
end

Rails.application.routes.draw do
  mount Konacha::Engine => "/konacha"
end
