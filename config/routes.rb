Konacha::Engine.routes.draw do
  get '/iframe/*name' => 'specs#iframe', :format => false, :as => :iframe
  get '/'             => 'specs#parent'
  get '*path'         => 'specs#parent'
end
