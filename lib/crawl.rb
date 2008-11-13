
require File.dirname(__FILE__) + '/crawler'

c = Crawler.new
c.load_app ARGV[0]
c.post ''
c.process ARGV[1]

c.routes.each_pair do |route,requests|
  if route == :not_found
    requests.each do |r|
      puts "NOT FOUND: #{r[:url]} via #{r[:method]}"
    end
  elsif route == :static
    # Don't care
  else
    if requests.empty?
      puts "UNUSED ROUTE: #{route.to_s}"
    else
      requests.each do |r|
        unless [200, 302].include? r[:status]
          puts "ERROR: #{r[:method].to_s.upcase} #{r[:url]} returned #{r[:status]}"
        end
      end
    end
  end
end