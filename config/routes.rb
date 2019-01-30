Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/about"
    get "static_pages/contact"
    root "static_pages#home"
  end
end
