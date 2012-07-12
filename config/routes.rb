Konacha::Engine.routes.draw do
  match "/"     => "konacha/specs#specs"
  match "spec/javascripts/fixtures/*path" => "konacha/fixtures#fixtures"
  match "*path" => "konacha/specs#specs"
end
