module Correlation
  module Sidekiq
    class ServerMiddleware
      def call(_worker, msg, _queue)
        correlation_id = msg['correlation_id']
        Correlation.with_correlation_id(correlation_id) do
          yield
        end
      end
    end
  end
end

if defined?(::Sidekiq)
  ::Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.remove self.class
      chain.add self.class, options
    end
  end
end
