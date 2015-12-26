namespace :grape do
  desc "routes"
  task :routes => :environment do
    API::Base.routes.each do |api|
      method = api.route_method.ljust(10)
      path = api.route_path
      puts "     #{method} #{path}"
    end
  end
end