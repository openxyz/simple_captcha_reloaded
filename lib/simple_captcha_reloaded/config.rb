class SimpleCaptchaReloaded::Config
  cattr_accessor :captcha_path
  cattr_accessor :image
  cattr_accessor :characters
  cattr_accessor :length

  def self.image_url(code, request)
    time = Time.now.to_i
    path = captcha_path + "?code=#{code}&time=#{time}"
    if request && defined?(request.protocol)
      "#{request.protocol}#{request.host_with_port}#{ENV['RAILS_RELATIVE_URL_ROOT']}#{path}"
    else
      "#{ENV['RAILS_RELATIVE_URL_ROOT']}#{path}"
    end
  end

  def self.refresh_url(id, request)
    path = captcha_path
    if request && defined?(request.protocol)
      "#{request.protocol}#{request.host_with_port}#{ENV['RAILS_RELATIVE_URL_ROOT']}#{path}"
    else
      "#{ENV['RAILS_RELATIVE_URL_ROOT']}#{path}.js"
    end
  end

  def self.generate_challenge
    key = Digest::MD5.hexdigest(Time.now.to_i.to_s)
    value = length.times.map do |i|
      characters.sample
    end
    [ key, value.join ]
  end
end

SimpleCaptchaReloaded::Config.tap do |config|
  config.captcha_path = '/simple_captcha'
  config.image = SimpleCaptchaReloaded::Image.new
  config.characters = %w[a b c d e f g h j k m n p q r s t u v w x y z 0 2 3 4 5 6 8 9]
  config.length = 6
end

