Konacha::Engine.routes.draw do
  get '/iframe/*name' => 'specs#iframe', :format => false, :as => :iframe
  root :to    => 'specs#parent'
  get '*path' => 'specs#parent', :format => false
end
