require File.expand_path('lib/jinaki', __dir__)

include Jinaki::Helper::Esa

desc 'jinaki'
namespace :jinaki do
  desc 'gc'
  task :gc do
    loop do
      one_week_before = Date.today - 6
      posts = esa_client.posts(q: "category: 日報 sharing: true created:<#{one_week_before}").body['posts']

      break if posts.empty?

      posts.each do |post|
        esa_client.delete_sharing(post['number'])
      end
    end
  end
end
