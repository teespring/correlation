module Correlation
  module Rack
    class Honeybadger
      def initialize(app)
        @app = app
      end

      def call(env)
        Correlation.with_correlation_id do |correlation_id|
          ::Honeybadger.context(correlation_id: correlation_id)

          @app.call(env)
        end
      end
    end
  end
end
