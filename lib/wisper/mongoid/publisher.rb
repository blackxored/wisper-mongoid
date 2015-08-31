module Wisper
  module Mongoid
    module Publisher
      extend ActiveSupport::Concern
      included do
        include Wisper::Publisher

        after_validation :after_validation_broadcast
        after_create :after_create_broadcast
        after_save :after_save_broadcast
        after_update :after_update_broadcast
        after_destroy :after_destroy_broadcast
      end

      def without_broadcasting(&block)
        @broadcast = false
        block.call(self)
        @broadcast = true
      end

      private

      def broadcast_event(event_name, payload)
        if (!defined?(@broadcast) || @broadcast)
          broadcast(event_name, payload)
        end
      end

      def after_validation_broadcast
        action = new_record? ? 'create' : 'update'
        if !errors.empty?
          broadcast_event("#{action}_#{broadcast_model_name_key}_failed", self)
        end
      end

      def after_create_broadcast
        broadcast_event(:after_create, self)
        broadcast_event("create_#{broadcast_model_name_key}_successful", self)
      end

      def after_save_broadcast
        broadcast_event(:after_save, self)
        broadcast_event("save_#{broadcast_model_name_key}_successful", self)
      end

      def after_update_broadcast
        broadcast_event(:after_update, self)
        broadcast_event("update_#{broadcast_model_name_key}_successful", self)
      end

      def after_destroy_broadcast
        broadcast_event(:after_destroy, self)
        broadcast_event("destroy_#{broadcast_model_name_key}_successful", self)
      end

      def broadcast_model_name_key
        self.class.model_name.param_key
      end
    end
  end
end
