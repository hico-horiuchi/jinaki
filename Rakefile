require File.expand_path('lib/jinaki', __dir__)

include Jinaki::Helper::Esa # rubocop:disable Style/MixinUsage
include Jinaki::Helper::Wakatime # rubocop:disable Style/MixinUsage

desc 'jinaki'
namespace :jinaki do
  desc 'gc'
  task :gc do
    ENV['PUBLICATION_PERIOD_DAYS'] ||= '7'

    publication_period = Date.today - ENV['PUBLICATION_PERIOD_DAYS'].to_i + 1
    posts = esa_client.posts(q: "category:日報 sharing:true created:<#{publication_period}").body['posts']

    next if posts.empty?

    posts.each do |post|
      esa_client.delete_sharing(post['number'])
      sleep 1
    end
  end

  desc 'wakatime'
  task :wakatime do
    yesterday = Date.today - 1

    full_name = "日報/#{yesterday.strftime('%Y/%m/%d')}"
    posts = esa_client.posts(q: "full_name:#{full_name}").body['posts']

    next if posts.empty?

    comments = esa_client.comments(posts[0]['number']).body['comments']
    wakatime_comments = comments.select { it['body_md'].include?('WakaTime Summaries') }

    next unless wakatime_comments.empty?

    start_date = yesterday
    end_date = yesterday + 1
    response = wakatime_client.get('/api/v1/users/current/summaries', { start: start_date, end: end_date })

    summaries = JSON.parse(response.body)['data'][0]
    projects = summaries['projects'].sort_by { it['total_seconds'] }.reverse
    languages = summaries['languages'].sort_by { it['total_seconds'] }.reject { it['name'] == 'Other' }.reverse

    body_md = ''

    unless projects.empty?
      body_md += "- Projects\n"
      body_md += projects.map { "  - #{it['name']}: #{it['text']}" }.join("\n")
      body_md += "\n"
    end

    unless languages.empty?
      body_md += "- Languages\n"
      body_md += languages.map { "  - #{it['name']}: #{it['text']}" }.join("\n")
      body_md += "\n"
    end

    next if body_md.empty?

    esa_client.create_comment(posts[0]['number'], { body_md: "WakaTime Summaries\n\n#{body_md}" })
  end
end
