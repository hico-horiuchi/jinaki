module Jinaki
  module Endpoint
    class Esa
      include Helper::Slack

      def post_events(request)
        params = JSON.parse(request.body.read, symbolize_names: true)

        case params[:kind]
        when 'post_update'
          post_update(params)
        end
      end

      private

      def post_update(params)
        post = Model::Post.new(params[:post][:number])

        return if post.period_exceeded? || post.shared? || post.wip?

        post.share
        slack_webhook.post(nil, attachments: [post.to_attachment])
      end
    end
  end
end
