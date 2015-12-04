module Correlation
  module Sidekiq
    class ClientMiddleware
      def call(_worker_class, msg, _queue)
        # NOTE: the reason why we're doing ||= instead of a simple setter
        # is because in the case of retries, the `correlation_id` key was
        # already set (i.e. from the web request), and we don't want the
        # correlation_id to be stomped over.
        msg['correlation_id'] ||= Correlation.correlation_id
        yield
      end
    end
  end
end

if defined?(::Sidekiq)
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
  end
end
