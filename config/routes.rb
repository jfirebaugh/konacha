Konacha::Engine.routes.draw do
  match "/"     => "konacha/specs#specs"
  match "*path" => "konacha/specs#specs"
end
