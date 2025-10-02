Rails.application.routes.draw do
  mount Reported::Engine => "/reported"
end
