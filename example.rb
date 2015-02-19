require 'httparty'
require 'pry'

def prompt_for_token
  print "Enter your github token: "
  gets.chomp
end

# $ export GITHUB_TOKEN=...
TOKEN = ENV['GITHUB_TOKEN'] || prompt_for_token

CLASS_NAME = "TIY-DC-ROR-2015-Jan"

# Get repos for an org
#HTTParty.get("https://api.github.com/orgs/TIY-DC-ROR-2015-Jan/repos")

class Github # < HTTParty
  include HTTParty
  base_uri "https://api.github.com"
  #default_options headers: ...

  def initialize
    @headers = {
      "Authorization" => "token #{TOKEN}",
      "User-Agent"    => "classbot"
    }
  end

  def repos org
    Github.get("/orgs/#{org}/repos")
  end

  def update_org org, new_description
    Github.patch("/orgs/#{org}",
      body: { :description => new_description }.to_json,
      headers: @headers
    )
  end

  def post_gist file_name, contents
    body = {
      public: true,
      files: {
        file_name => {
          content: contents
        }
      }
    }

    Github.post("/gists",
      body: body.to_json,
      headers: @headers
    )
  end
end

api = Github.new
binding.pry