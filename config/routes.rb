Reported::Engine.routes.draw do
  post 'csp-reports', to: 'csp_reports#create'
end
