require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"

root = File.expand_path("..", __FILE__)

configure do
  enable :sessions
  set :session_secret, "46032b19138ea43d9ad6e96bbd85bca9d29d8c0084e0c093300a85dae7b96195"
end 

get "/" do
  @files = Dir.glob(root + "/data/*").map do |path|  # dir.glob gives back an array
    File.basename(path)
  end

  erb :index
end

# cms.rb
get "/:filename" do
  file_path = root + "/data/" + params[:filename]

  if File.file?(file_path)
    headers["Content-Type"] = "text/plain"
    File.read(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end