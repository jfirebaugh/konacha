Konacha::Engine.routes.draw do
  get '/iframe/*name' => 'specs#iframe', :as => :iframe
  get '/'             => 'specs#parent'
  get '*path'         => 'specs#parent'
end
