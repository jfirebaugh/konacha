Konacha::Engine.routes.draw do
  match "/"     => "specs#specs"
  match "*path" => "specs#specs"
end
