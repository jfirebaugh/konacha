Konacha::Engine.routes.draw do
  match '/iframe'       => 'specs#iframe', :as => 'iframe'
  match '/iframe/*path' => 'specs#iframe'
  match '/'             => 'specs#parent', :as => 'parent'
  match '*path'         => 'specs#parent'
end
