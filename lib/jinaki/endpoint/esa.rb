module Jinaki
  module Endpoint
    class Esa
      include Helper::Esa
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
        post = esa_client.post(params[:post][:number])

        return if wip?(post) || shared?(post)

        response = esa_client.create_sharing(post.body['number'])
        updated_at = Time.parse(post.body['updated_at']).localtime.strftime('%Y/%m/%d %H:%M')

        attachment = {
          title: post.body['full_name'],
          title_link: response.body['html'],
          author_name: ENV['ESA_CURRENT_TEAM'],
          author_link: "https://#{ENV['ESA_CURRENT_TEAM']}.esa.io",
          author_icon: ESA_ICON,
          footer: "Updated at #{updated_at} by #{post.body['updated_by']['name']}",
          footer_icon: post.body['updated_by']['icon'],
          color: ESA_COLOR
        }

        slack_webhook.post(nil, attachments: [attachment])
      end
    end
  end
end
