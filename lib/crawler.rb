
require 'rubygems'
require 'action_controller'
require 'action_controller/integration'
require 'hpricot'

class Crawler
  include ActionController::Integration::Runner
  
  attr_reader :routes, :results, :path
  attr_internal :open
  
  def load_app(path)
    require path + '/config/boot'
    require path + '/config/environment'
    require path + '/config/routes'

    @path = path
    @routes = { :static => [], :not_found => [] }
    ActionController::Routing::Routes.routes.each do |r|
      @routes[r] = []
    end
  end
  
  def process(url)
    @results = []
    @open = [{:method => :get, :url => url}]
    
    until @open.empty?
      step
    end
  end

  protected
  def step
    request = @open.pop
    result, outgoing = process_request request
    
    @results.push result
    outgoing.each do |x|
      @open.push(x) unless already_processed? x        
    end        
  end
  
  def already_processed?(request)
    not (@open + @results).map { |x|
              if x[:url] == request[:url] and
                 x[:method] == request[:method]
                return true
              end
            }.compact.empty?
  end

  def static_path(url)
    if url == "/"
      "#{@path}/public/index.html"
    else
      "#{@path}/public/#{url}"
    end
  end
  
  def is_static_file?(url)
    File.exist? static_path(url)
  end
  
  def process_request(request)    
    method(request[:method]).call request[:url]

    request[:route] = find_route request[:url], request[:method]
    
    if request[:route] == :static
      request[:status] = 200
    else
      request[:status] = status
    end
    
    if request[:route] == :static
      f = File.new static_path(request[:url])
      body = f.read
      f.close
      
      outgoing_links = extract_outgoing_links(body)
    elsif [200, 302].include? request[:status]
      outgoing_links = extract_outgoing_links(response.body)
    else
      outgoing_links = []
    end
    
    routes[request[:route]].push request
    return request, outgoing_links
  end
  
  def find_route(url, method)
    if is_static_file? url
      return :static
    else
      results = @routes.keys.map do |r|
        next if [:static, :not_found].include? r
        output = r.recognize(url, { :method => method })

        r unless output.nil?
      end

      results.compact!
    
      if results.empty?
        return :not_found
      else
        return results[0]
      end
    end
  end
  
  def extract_outgoing_links(body) 
    anchors = Hpricot(body).search("//a").map do |a|
      {:url => a[:href], :method => :get}
    end

    images = Hpricot(body).search("//img").map do |a|
      {:url => a[:src], :method => :get}
    end

    buttons = Hpricot(body).search("//form").map do |f|
      {:url => f[:action], :method => f[:method].to_sym}
    end
    
    anchors + images + buttons
  end    
end