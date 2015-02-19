require 'httparty'
require 'json'
require 'pry'


def get_token
  puts "Enter github authorization token(put 'na' if you don't have one): "
  token = gets.chomp
    if token = "na"
      #go to public mode?
    else
      return token
    end
      if token != "na"
        puts "Enter your USERNAME: "
        username = gets.chomp.downcase
  end

def get_organization
  puts "Enter the github organization you'd like to analyze: "
    org = gets.chomp
end

TOKEN = "#{token}"

USERNAME = "#{username}" 

ORG = "#{org}" || "TIY-DC-ROR-2015-Jan"

class Github
  include HTTParty

  def initialize
    @logins = []
    @login_repos = []
  end

  def repos
    url = "https://api.github.com/orgs/#{ORG}/members"
    HTTParty.get("#{url}", headers: {"Authorization" => "token #{TOKEN}", "User-Agent" => "#{USERNAME}"})
  end

  def members
    repos.each do |x|
    @logins << x["login"]
    end
    @logins
  end

  def member_repos
    @logins.each do |person|
      url = "https://api.github.com/users/#{person}/repos"
      user_repos = HTTParty.get("#{url}", headers: {"Authorization" => "token #{TOKEN}", "User-Agent" => "#{USERNAME}"})
      @login_repos += user_repos.map {|x| x["url"]}
      additions = 0
      deletions = 0
      changes = 0
      @login_repos.each do |x|
        begin
        url2 = "#{x}/stats/contributors"
        user_counts = HTTParty.get("#{url2}", headers: {"Authorization" => "token #{TOKEN}", "User-Agent" => "#{USERNAME}"})
        user_counts.each do |z|
          if z["author"]["login"] == person
            z["weeks"].each do |y|
            additions += y["a"]
            deletions += y["d"]
            changes += y["c"]
            end
          end
        end
      rescue
      end
      end
      # print "User".ljust(20) + "Additions".ljust(20) + "Deletions".ljust(20) + "Changes".ljust(20)
      print "User: #{person}".ljust(20) + "Additions: #{additions}".ljust(20) + "Deletions: #{deletions}".ljust(20) + "Changes: #{changes}".ljust(20)
      puts
    end
  end





#   def member_counts logins, login_repos
#     additions = 0
#     deletions = 0
#     changes = 0
#     login_repos.each do |x|
#       url = "#{x}/stats/contributors"
#       user_counts = HTTParty.get("#{url}", headers: {"Authorization" => "token #{TOKEN}", "User-Agent" => "matthew-gould"})
#       user_counts.each do |z|
#       if z["author"]["login"] == person
#         z["weeks"].each do |y|
#           additions += y["a"]
#           deletions += y["d"]
#           changes += y["c"]
#         end
#       end
#       # puts "#{contributor} had #{additions} additions, #{deletions} deletions, and #{changes} changes."
#     end
#   end
# end

  # def repo_numbers
  #   additions = 0
  #   deletions = 0
  #   changes = 0
  #   @login_repos.each do |x|
  #     url = "#{x}/stats/contributors"
  #     counting = HTTParty.get("#{url}", headers: {"Authorization" => "token #{TOKEN}", "User-Agent" => "matthew-gould"})
  #     count_this_shit = counting[0]["weeks"]
  #     count_this_shit.each do |y|
  #       additions += y["a"]
  #       deletions += y["d"]
  #       changes += y["c"]
  #     binding.pry
  #     end
  #   end
  # end



end

info = Github.new
info.members
info.member_repos
# binding.pry
