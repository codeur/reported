# frozen_string_literal: true

Rails.application.routes.draw do
  mount Reported::Engine => '/reported'
end
