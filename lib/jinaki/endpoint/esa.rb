module Jinaki
  module Endpoint
    class Esa
      include Error::Esa
      include Helper::Esa

      def post_events(request)
        raise UnsignatedError unless signated?(request)

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

        esa_client.create_sharing(post.body['number'])
      end
    end
  end
end
