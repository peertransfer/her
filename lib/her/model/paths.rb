module Her
  module Model
    module Paths
      def request_path
        self.class.build_request_path(@data)
      end
    end

    module PathsClassMethods
      def collection_path(path=nil)
        return @her_collection_path unless path
        @her_resource_path = "#{path}/:id"
        @her_collection_path = path
      end

      def resource_path(path=nil)
        return @her_resource_path unless path
        @her_resource_path = path
      end

      def build_request_path(path=nil, parameters={})
        unless path.is_a?(String)
          parameters = path || {}
          path = parameters.include?(:id) ? @her_resource_path : @her_collection_path
        end
        path.gsub(/:([\w_]+)/) do
          # Look for :key or :_key, otherwise raise an exception
          parameters[$1.to_sym] || parameters["_#{$1}".to_sym] || raise(Her::Errors::PathError.new("Missing :_#{$1} parameter to build the request path (#{path})."))
        end
      end
    end
  end
end
