module Her
  class API
    attr_reader :base_uri, :connection

    def self.setup(attrs={}, &block)
      @@default_api = new
      @@default_api.setup(attrs, &block)
    end

    def setup(attrs={})
      @base_uri = attrs[:base_uri]
      @connection = Faraday.new(:url => @base_uri) do |connection|
        yield connection.builder if block_given?
      end
    end

    def request(attrs={})
      method = attrs.delete(:_method)
      path = attrs.delete(:_path)
      attrs.delete_if { |key, value| key.to_s =~ /^_/ }
      response = @connection.send method do |request|
        if method == :get
          request.url(path, attrs)
        else
          request.url path
          request.body = attrs
        end
      end
      response.env[:body]
    end

    protected

    def self.default_api
      defined?(@@default_api) ? @@default_api : nil
    end
  end
end
