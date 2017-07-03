Rails.application.routes.draw do
	devise_for :admins
  mount RailsAdmin::Engine => '/', as: 'rails_admin'

	root to: "rails_admin/main#dashboard"
end
