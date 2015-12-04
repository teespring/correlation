module Correlation
  class Rails < ::Rails::Engine
    initializer 'correlation' do |app|
      app.middleware.insert_before "Rails::Rack::Logger", Correlation::Rack::Request
    end
  end if defined?(::Rails)
end
