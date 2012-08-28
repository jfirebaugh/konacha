Konacha::Engine.routes.draw do
  match '/runner' => 'specs#specs', :as => 'runner'
  match '/runner/*path' => 'specs#specs'
  match '/' => 'specs#reporter', :as => 'reporter'
  match '*path' => 'specs#reporter'
end
