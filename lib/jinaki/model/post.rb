module Jinaki
  module Model
    class Post
      include Helper::Esa

      attr_reader :sharing_url, :updated_at

      def initialize(number)
        @number = number
        @body = JSON.parse(esa_client.post(@number).body.to_json, object_class: OpenStruct)
      end

      def share
        response = esa_client.create_sharing(@number)
        @sharing_url = response.body['html']
      end

      def shared?
        !@body.sharing_urls.nil?
      end

      def to_attachment
        {
          title: @body.full_name,
          title_link: @sharing_url,
          author_name: ENV['ESA_CURRENT_TEAM'],
          author_link: "https://#{ENV['ESA_CURRENT_TEAM']}.esa.io",
          author_icon: ESA_ICON,
          footer: "Updated at #{updated_at} by #{@body.updated_by.name}",
          footer_icon: @body.updated_by.icon,
          color: ESA_COLOR
        }
      end

      def wip?
        @body.wip
      end

      private

      def updated_at
        Time.parse(@body.updated_at).localtime.strftime('%Y/%m/%d %H:%M')
      end
    end
  end
end
