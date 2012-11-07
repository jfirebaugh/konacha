Konacha::Engine.routes.draw do
  match '/iframe/*name' => 'specs#iframe'
  match '/'             => 'specs#parent'
  match '*path'         => 'specs#parent'
end
