require "app_root"
require "easy_settings"

module Bts
  class << self
    def config
      EasySettings
    end

    def root
      AppRoot.path("config.ru")
    end
  end
end

EasySettings.source_file = Bts.root.join("config/settings.yml").to_s

require "bts/server"
