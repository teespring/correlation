module Correlation
  class Rails < ::Rails::Engine
    initializer 'correlation' do |app|
      app.middleware.insert_before "Rails::Rack::Logger", Correlation::Rack::Request

      if defined?(::Honeybadger)
        app.middleware.use Correlation::Rack::Honeybadger
      end
    end
  end if defined?(::Rails)
end
