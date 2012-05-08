module Her
  module Model
    module Hooks
      def before_save(method=nil, &block)
        set_hook(:before, :save, method || block)
      end

      def before_create(method=nil, &block)
        set_hook(:before, :create, method || block)
      end

      def before_update(method=nil, &block)
        set_hook(:before, :update, method || block)
      end

      def before_destroy(method=nil, &block)
        set_hook(:before, :destroy, method || block)
      end

      def after_save(method=nil, &block)
        set_hook(:after, :save, method || block)
      end

      def after_create(method=nil, &block)
        set_hook(:after, :create, method || block)
      end

      def after_update(method=nil, &block)
        set_hook(:after, :update, method || block)
      end

      def after_destroy(method=nil, &block)
        set_hook(:after, :destroy, method || block)
      end

      protected

      def hooks
        @her_hooks ||= {}
      end

      def set_hook(time, name, action)
        (self.hooks["#{time}_#{name}".to_sym] ||= []) << action
      end

      def perform_hook(record, time, name)
        (self.hooks["#{time}_#{name}".to_sym] || []).each do |hook|
          if hook.is_a? Symbol
            record.send(hook)
          else
            hook.call(record)
          end
        end
      end
    end
  end
end
