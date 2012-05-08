module Her
  module Model
    module Introspection
      extend ActiveSupport::Concern

      module ClassMethods
        def nearby_class(name)
          sibling_class(name) || name.constantize rescue nil
        end

        protected

        def sibling_class(name)
          if mod = self.containing_module
            "#{mod.name}::#{name}".constantize rescue nil
          else
            name.constantize rescue nil
          end
        end

        def containing_module
          return unless self.name =~ /::/
          self.name.split("::")[0..-2].join("::").constantize
        end
      end

      def inspect
        "#<#{self.class}(#{self.class.build_request_path(@data)}) #{@data.inject([]) { |memo, item| key, value = item; memo << "#{key}=#{attribute_for_inspect(value)}"}.join(" ")}>"
      end

      private
      # @private
      def attribute_for_inspect(value)
        if value.is_a?(String) && value.length > 50
          "#{value[0..50]}...".inspect
        elsif value.is_a?(Date) || value.is_a?(Time)
          %("#{value}")
        else
          value.inspect
        end
      end
    end
  end
end
