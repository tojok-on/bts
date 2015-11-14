require "sinatra"
require "slim"

module Bts
  class Server < Sinatra::Base
    configure do
      set :root, Bts.root
      set :bind, "0.0.0.0"
      set :port, ENV["BTS_PORT"].to_i if ENV["BTS_PORT"]
    end

    get "/" do
      slim :index
    end

    post "/" do
      @filename = SettingTable.new(params).save
      slim :index
    end
  end
end
