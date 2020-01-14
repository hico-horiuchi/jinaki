module Jinaki
  module Helper
    module Slack
      def slack_webhook
        @slack_webhook ||= ::Slack::Incoming::Webhooks.new(ENV['SLACK_WEBHOOK_URL'])
      end
    end
  end
end
