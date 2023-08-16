module Jinaki
  module Helper
    module Slack
      private

      def slack_webhook
        @slack_webhook ||= ::Slack::Incoming::Webhooks.new(ENV.fetch('SLACK_WEBHOOK_URL', nil))
      end
    end
  end
end
