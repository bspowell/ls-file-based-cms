ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../cms.rb"

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "about.txt"
    assert_includes last_response.body, "changes.txt"
    assert_includes last_response.body, "history.txt"
  end

  def test_viewing_text_doc
    get "/history.txt"
    assert_equal 200, last_response.status
    assert_equal "text/plain", last_response["Content-Type"]
    assert_equal File.read("data/history.txt"), last_response.body
    # assert_includes last_response.body, "Ruby 0.95 released"
  end

  def test_document_not_found
    get "/notafile.ext" # Attempt to access a nonexistent file
  
    assert_equal 302, last_response.status # Assert that the user was redirected
  
    get last_response["Location"] # Request the page that the user was redirected to
  
    assert_equal 200, last_response.status
    assert_includes last_response.body, "notafile.ext does not exist"
  
    get "/" # Reload the page
    refute_includes last_response.body, "notafile.ext does not exist" # Assert that our message has been removed
  end
end