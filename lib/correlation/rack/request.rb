module Correlation
  module Rack
    class Request
      def initialize(app)
        @app = app
      end

      def call(env)
        correlation_id = env["HTTP_X_REQUEST_ID"]

        Correlation.with_correlation_id(correlation_id) do |id|
          code, headers, body = @app.call(env)
          headers['X-Correlation-ID'] = id
          [code, headers, body]
        end
      end
    end
  end
end
