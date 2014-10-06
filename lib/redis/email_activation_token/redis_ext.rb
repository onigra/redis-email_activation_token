require 'redis'

class Redis
  class EmailActivationToken
    def initialize(opts = {})
      @redis = opts.delete(:redis) || Redis.new(opts)
    end

    def generate(email, expire: 259200)
      token = generate_token
      set_key(email, token, expire)
      token
    end

    def get(token)
      get_key token
    end

    def get_email(token)
      @redis.hget(token, "email")
    end

    def get_created_at(token)
      Time.parse @redis.hget(token, "created_at")
    end

    private

    def set_key(email, token, expire)
      @redis.hset(token, "email", email)
      @redis.hset(token, "created_at", Time.now)
      @redis.expire(token, expire)
    end

    def get_key(token)
      { token: token, email: get_email(token), created_at: get_created_at(token) } 
    end

    def generate_token
      SecureRandom.urlsafe_base64
    end
  end
end
