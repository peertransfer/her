module Her
  module Model
    module HTTP
      def set_api(api)
        @her_api = api
      end

      def request(attrs={}, &block)
        yield @her_api.request(attrs)
      end

      def get(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        get_raw(path, attrs) do |parsed_data|
          if parsed_data[:data].is_a?(Array)
            new_collection(parsed_data[:data])
          else
            new(parsed_data[:data])
          end
        end
      end

      def get_raw(path, attrs={}, &block)
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        request(attrs.merge(:_method => :get, :_path => path), &block)
      end

      def get_collection(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        get_raw(path, attrs) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def get_resource(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        get_raw(path, attrs) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def post(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        post_raw(path, attrs) do |parsed_data|
          if parsed_data[:data].is_a?(Array)
            new_collection(parsed_data[:data])
          else
            new(parsed_data[:data])
          end
        end
      end

      def post_raw(path, attrs={}, &block)
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        request(attrs.merge(:_method => :post, :_path => path), &block)
      end

      def post_collection(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        post_raw(path, attrs) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def post_resource(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        post_raw(path, attrs) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def put(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        put_raw(path, attrs) do |parsed_data|
          if parsed_data[:data].is_a?(Array)
            new_collection(parsed_data[:data])
          else
            new(parsed_data[:data])
          end
        end
      end

      def put_raw(path, attrs={}, &block)
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        request(attrs.merge(:_method => :put, :_path => path), &block)
      end

      def put_collection(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        put_raw(path, attrs) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def put_resource(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        put_raw(path, attrs) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def patch(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        patch_raw(path, attrs) do |parsed_data|
          if parsed_data[:data].is_a?(Array)
            new_collection(parsed_data[:data])
          else
            new(parsed_data[:data])
          end
        end
      end

      def patch_raw(path, attrs={}, &block)
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        request(attrs.merge(:_method => :patch, :_path => path), &block)
      end

      def patch_collection(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        patch_raw(path, attrs) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def patch_resource(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        patch_raw(path, attrs) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def delete(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        delete_raw(path, attrs) do |parsed_data|
          if parsed_data[:data].is_a?(Array)
            new_collection(parsed_data[:data])
          else
            new(parsed_data[:data])
          end
        end
      end

      def delete_raw(path, attrs={}, &block)
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        request(attrs.merge(:_method => :delete, :_path => path), &block)
      end

      def delete_collection(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        delete_raw(path, attrs) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def delete_resource(path, attrs={})
        path = "#{build_request_path(attrs)}/#{path}" if path.is_a?(Symbol)
        delete_raw(path, attrs) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def custom_get(*paths)
        metaclass = (class << self; self; end)
        paths.each do |path|
          metaclass.send(:define_method, path.to_sym) do |*attrs|
            get(path, attrs.first || Hash.new)
          end
        end
      end

      def custom_post(*paths)
        metaclass = (class << self; self; end)
        paths.each do |path|
          metaclass.send(:define_method, path.to_sym) do |*attrs|
            post(path, attrs.first || Hash.new)
          end
        end
      end

      def custom_put(*paths)
        metaclass = (class << self; self; end)
        paths.each do |path|
          metaclass.send(:define_method, path.to_sym) do |*attrs|
            put(path, attrs.first || Hash.new)
          end
        end
      end

      def custom_patch(*paths)
        metaclass = (class << self; self; end)
        paths.each do |path|
          metaclass.send(:define_method, path.to_sym) do |*attrs|
            patch(path, attrs.first || Hash.new)
          end
        end
      end

      def custom_delete(*paths)
        metaclass = (class << self; self; end)
        paths.each do |path|
          metaclass.send(:define_method, path.to_sym) do |*attrs|
            delete(path, attrs.first || Hash.new)
          end
        end
      end
    end
  end
end
