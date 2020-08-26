module Jinaki
  module Model
    class Post
      include Helper::Esa

      attr_reader :sharing_url

      def initialize(number)
        @number = number
        @body = JSON.parse(esa_client.post(@number).body.to_json, object_class: OpenStruct)
      end

      def period_exceeded?
        ENV['PUBLICATION_PERIOD_DAYS'] ||= '7'
        publication_period = Date.today - ENV['PUBLICATION_PERIOD_DAYS'].to_i + 1

        created_at < publication_period.to_time
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
          footer: "Updated at #{updated_at.strftime('%Y/%m/%d %H:%M')} by #{@body.updated_by.name}",
          footer_icon: @body.updated_by.icon,
          color: ESA_COLOR
        }
      end

      def wip?
        @body.wip
      end

      private

      def created_at
        Time.parse(@body.created_at).localtime
      end

      def updated_at
        Time.parse(@body.updated_at).localtime
      end
    end
  end
end
