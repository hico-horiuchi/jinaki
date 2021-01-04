threads_count = Integer(ENV['MAX_THREADS'] || 5)
workers_count = Integer(ENV['WEB_CONCURRENCY'] || 2)

threads threads_count, threads_count

if workers_count > 1
  preload_app!
  workers workers_count
end

environment ENV['RACK_ENV'] || 'development'
port ENV['PORT'] || 5000
rackup DefaultRackup
