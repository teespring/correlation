require 'correlation/sidekiq/server_middleware'
require 'correlation/sidekiq/client_middleware'

module Correlation
  module Sidekiq
    def self.configure!
      ::Sidekiq.configure_client do |config|
        config.client_middleware do |chain|
          chain.remove Correlation::Sidekiq::ClientMiddleware
          chain.add Correlation::Sidekiq::ClientMiddleware
        end
      end

      ::Sidekiq.configure_server do |config|
        config.client_middleware do |chain|
          chain.remove Correlation::Sidekiq::ClientMiddleware
          chain.add Correlation::Sidekiq::ClientMiddleware
        end

        config.server_middleware do |chain|
          chain.remove Correlation::Sidekiq::ServerMiddleware
          chain.add Correlation::Sidekiq::ServerMiddleware
        end
      end
    end
  end
end

if defined?(::Sidekiq)
  Correlation::Sidekiq.configure!
end
