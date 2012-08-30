Konacha::Engine.routes.draw do
  match '/runner' => 'specs#runner', :as => 'runner'
  match '/runner/*path' => 'specs#runner'
  match '/' => 'specs#reporter', :as => 'reporter'
  match '*path' => 'specs#reporter'
end
