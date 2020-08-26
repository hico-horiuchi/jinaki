require File.expand_path('lib/jinaki', __dir__)

include Jinaki::Helper::Esa # rubocop:disable Style/MixinUsage

desc 'jinaki'
namespace :jinaki do
  desc 'gc'
  task :gc do
    loop do
      ENV['PUBLICATION_PERIOD_DAYS'] ||= '7'

      publication_period = Date.today - ENV['PUBLICATION_PERIOD_DAYS'].to_i + 1
      posts = esa_client.posts(q: "category: 日報 sharing: true created:<#{publication_period}").body['posts']

      break if posts.empty?

      posts.each do |post|
        esa_client.delete_sharing(post['number'])
      end
    end
  end
end
