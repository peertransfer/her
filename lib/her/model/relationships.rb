module Her
  module Model
    module Relationships
      def relationships
        @her_relationships ||= {}
      end

      def parse_relationships(data)
        self.relationships.each_pair do |type, relationships|
          relationships.each do |relationship|
            name_key = relationship[:name]
            if data.include?(name_key)
              klass = self.nearby_class(relationship[:class_name])
              if type == :has_many
                data[name_key] = data[name_key].map{ |data| klass.new(data) }
              else
                data[name_key] = klass.new(data[name_key])
              end
            end
          end
        end
        data
      end

      def has_many(name, attrs={})
        attrs = {
          :class_name => name.to_s.classify,
          :name => name,
          :path => "/#{name}"
        }.merge(attrs)
        (self.relationships[:has_many] ||= []) << attrs

        define_method(name) do
          klass = self.class.nearby_class(attrs[:class_name])
          @data[name] ||= klass.get_collection("#{self.class.build_request_path(:id => id)}#{attrs[:path]}")
        end
      end

      def has_one(name, attrs={})
        attrs = {
          :class_name => name.to_s.classify,
          :name => name,
          :path => "/#{name}"
        }.merge(attrs)
        (self.relationships[:has_one] ||= []) << attrs

        define_method(name) do
          klass = self.class.nearby_class(attrs[:class_name])
          @data[name] ||= klass.get_resource("#{self.class.build_request_path(:id => id)}#{attrs[:path]}")
        end
      end

      def belongs_to(name, attrs={})
        attrs = {
          :class_name => name.to_s.classify,
          :name => name,
          :foreign_key => "#{name}_id",
          :path => "/#{name.to_s.pluralize}/:id"
        }.merge(attrs)
        (self.relationships[:belongs_to] ||= []) << attrs

        define_method(name) do
          klass = self.class.nearby_class(attrs[:class_name])
          @data[name] ||= klass.get_resource("#{klass.build_request_path(attrs[:path], :id => @data[attrs[:foreign_key].to_sym])}")
        end
      end
    end
  end
end
