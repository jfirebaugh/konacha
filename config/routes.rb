Konacha::Engine.routes.draw do
  match "/"      => "konacha/specs#index"
  match "/*spec" => "konacha/specs#show"
end
