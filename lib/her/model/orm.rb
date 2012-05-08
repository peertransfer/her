module Her
  module Model
    module ORM
      def method_missing(method, attrs=nil)
        assignment_method = method.to_s =~ /\=$/
        method = method.to_s.gsub(/(\?|\!|\=)$/, "").to_sym
        if attrs and assignment_method
          @data[method] = attrs
        else
          @data.include?(method) ? @data[method] : super
        end
      end

      def id
        @data[:id]
      end

      def new?
        !self.id
      end

      def save
        params = @data.dup
        resource = self
        if new?
          self.class.class_eval do
            perform_hook(resource, :before, :create)
            perform_hook(resource, :before, :save)
          end
          self.class.request(params.merge(:_method => :post, :_path => "#{request_path}")) do |parsed_data|
            @data = parsed_data[:data]
          end
          self.class.class_eval do
            perform_hook(resource, :after, :save)
            perform_hook(resource, :after, :create)
          end
        else
          self.class.class_eval do
            perform_hook(resource, :before, :update)
            perform_hook(resource, :before, :save)
          end
          self.class.request(params.merge(:_method => :put, :_path => "#{request_path}")) do |parsed_data|
            @data = parsed_data[:data]
          end
          self.class.class_eval do
            perform_hook(resource, :after, :save)
            perform_hook(resource, :after, :update)
          end
          self
        end
        self
      end

      def destroy
        params = @data.dup
        resource = self
        self.class.class_eval { perform_hook(resource, :before, :destroy) }
        self.class.request(params.merge(:_method => :delete, :_path => "#{request_path}")) do |parsed_data|
          @data = parsed_data[:data]
        end
        self.class.class_eval { perform_hook(resource, :after, :destroy) }
        self
      end
    end

    module ORMClassMethods
      def new_collection(collection_data)
        collection_data.map{ |data| new(data) }
      end

      def find(id, params={})
        request(params.merge(:_method => :get, :_path => "#{build_request_path(params.merge(:id => id))}")) do |parsed_data|
          new(parsed_data[:data])
        end
      end

      def all(params={})
        request(params.merge(:_method => :get, :_path => "#{build_request_path(params)}")) do |parsed_data|
          new_collection(parsed_data[:data])
        end
      end

      def create(params={})
        resource = new(params)
        perform_hook(resource, :before, :create)
        perform_hook(resource, :before, :save)
        params = resource.instance_eval { @data }
        request(params.merge(:_method => :post, :_path => "#{build_request_path(params)}")) do |parsed_data|
          resource.instance_eval do
            @data = parsed_data[:data]
          end
        end
        perform_hook(resource, :after, :save)
        perform_hook(resource, :after, :create)

        resource
      end

      def update(id, params)
        new(params.merge(:id => id)).save
      end

      def destroy(id, params={})
        request(params.merge(:_method => :delete, :_path => "#{build_request_path(params.merge(:id => id))}")) do |parsed_data|
          new(parsed_data[:data])
        end
      end
    end
  end
end
