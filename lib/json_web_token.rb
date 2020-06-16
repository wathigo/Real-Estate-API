class JsonWebToken
  SECRET = ENV['SECRET_KEY_BASE']
  class << self
    def encode(payload, exp = 24.hours.from_now)
      puts('DEBUG!!!!!!', payload, SECRET)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET) 
    end

    def decode(token)
      body = JWT.decode(token, SECRET)[0]
      HashWithIndifferentAccess.new body
    rescue # rubocop:disable Style/RescueStandardError
      nil
    end
  end
end
