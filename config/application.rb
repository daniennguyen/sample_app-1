require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    require File.expand_path("../boot", __FILE__)
    require "rails/all"
    require "carrierwave"

    if defined? Bundler; end

    config.load_defaults 5.2

    config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    I18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
  end
end
