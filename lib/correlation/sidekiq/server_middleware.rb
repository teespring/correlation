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
