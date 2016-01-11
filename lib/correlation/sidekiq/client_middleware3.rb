module Correlation
  module Sidekiq
    class ClientMiddleware3 < ClientMiddleware2
      def call(_worker_class, msg, _queue, _redis_pool)
        super(_worker_class, msg, _queue)
      end
    end
  end
end
