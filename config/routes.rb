Matcha::Engine.routes.draw do
  match "/"      => "matcha/specs#index"
  match "/*spec" => "matcha/specs#show"
end
