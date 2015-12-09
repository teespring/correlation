require 'correlation/utils'
require 'correlation/rack/request'
require 'correlation/rack/honeybadger'
require 'correlation/rails'
require 'correlation/sidekiq'

module Correlation
  class << self
    def with_correlation_id(correlation_id = nil)
      if Utils.str_not_empty?(self.correlation_id) && Utils.str_not_empty?(correlation_id)
        fail "Cannot set the correlation_id when it has already been set. Check the stack to see where the #with_correlation_id has been called earlier"
      end

      self.correlation_id ||= correlation_id || generate_correlation_id

      yield(self.correlation_id)
    ensure
      self.correlation_id = nil
    end

    def correlation_id
      Thread.current[:correlation_id]
    end

    private

    def correlation_id=(id)
      if Utils.str_not_empty?(id) && Utils.str_not_empty?(correlation_id)
        fail "correlation_id variable already set in current Thread context"
      end

      Thread.current[:correlation_id] = id
    end

    def generate_correlation_id
      SecureRandom.uuid
    end
  end
end
