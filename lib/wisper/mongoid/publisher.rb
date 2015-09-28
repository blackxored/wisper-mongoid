module Wisper
  module Mongoid
    module Publisher
      extend ActiveSupport::Concern
      included do
        include Wisper::Publisher

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

      def broadcast_event(event_name)
        if (!defined?(@broadcast) || @broadcast)
          broadcast(event_name, payload)
        end
      end

      def payload
        {
          id: id.to_s
        }
      end

      def after_create_broadcast
        broadcast_event(:after_create)
        broadcast_event("#{broadcast_model_name_key}_created")
      end

      def after_save_broadcast
        broadcast_event(:after_save)
        broadcast_event("#{broadcast_model_name_key}_saved")
      end

      def after_update_broadcast
        broadcast_event(:after_update)
        broadcast_event("#{broadcast_model_name_key}_updated")
      end

      def after_destroy_broadcast
        broadcast_event(:after_destroy)
        broadcast_event("#{broadcast_model_name_key}_destroyed")
      end

      def broadcast_model_name_key
        self.class.model_name.param_key
      end
    end
  end
end
