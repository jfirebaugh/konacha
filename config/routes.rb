Konacha::Engine.routes.draw do
  match "(*path)"  => "specs#specs"
end