require 'correlation/sidekiq/server_middleware'
require 'correlation/sidekiq/client_middleware2'
require 'correlation/sidekiq/client_middleware3'

module Correlation
  module Sidekiq
    def self.configure!
      ::Sidekiq.configure_client do |config|
        config.client_middleware do |chain|
          chain.remove client_middleware_class
          chain.add client_middleware_class
        end
      end

      ::Sidekiq.configure_server do |config|
        config.client_middleware do |chain|
          chain.remove client_middleware_class
          chain.add client_middleware_class
        end

        config.server_middleware do |chain|
          chain.remove Correlation::Sidekiq::ServerMiddleware
          chain.add Correlation::Sidekiq::ServerMiddleware
        end
      end
    end

    def self.sidekiq_major_version
      ::Sidekiq::VERSION.split(".").first.to_i
    end

    def self.client_middleware_class
      if sidekiq_major_version == 2
        Correlation::Sidekiq::ClientMiddleware2
      else
        Correlation::Sidekiq::ClientMiddleware3
      end
    end
  end
end

if defined?(::Sidekiq)
  Correlation::Sidekiq.configure!
end
