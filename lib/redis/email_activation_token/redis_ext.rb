require 'redis'

class Redis
  class EmailActivationToken
    attr_reader :expire

    def initialize(email, opts = {})
      @email = email
      @expire = opts.delete(:expire) || 30
      @redis = opts.delete(:redis) || Redis.new(opts)

      freeze
    end

    def create
      if exists?
        false
      else
        set_key
        get
      end
    end

    def exists?
      @redis.exists @email
    end

    def get
      @redis.get @email
    end

    private

    def set_key
      @redis.set(@email, generate_token)
      @redis.expire(@email, @expire)
    end

    def generate_token
      SecureRandom.urlsafe_base64
    end

  end
end
