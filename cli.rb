require 'bundler'
Bundler.require

require 'dotenv'
Dotenv.load

require_relative "rom"
require_relative "commands"


class IronTrello::CLI < Thor

  desc "api-start", "Register an API with Trello"
  def api_start
    puts "Copy the KEY that shows on this page, and then run api-save with it"
    Launchy.open("https://trello.com/1/appKey/generate")
  end

  desc "api-save APIKEY", "Save your App API_KEY"
  def api_save(api_key)
    IronTrello::Commands::Api.new.run(api_key)
  end

  desc "auth-start", "Authorize your account with Trello"
  def auth_start
    puts "Authorize on this page and then run auth-save with it"
    Launchy.open("https://trello.com/1/authorize?key=#{IronTrello.api_key}&name=the-iron-trello&expiration=1day&response_type=token&scope=read,write")
  end

  desc "auth-save TOKEN", "save auth token from Trello"
  def auth_save(token)
    IronTrello::Commands::Setup.new.run(token)
  end

  desc "boards", "List boards"
  def boards
    IronTrello::Commands::ListAllBoards.new.run
  end

  desc "boards-new", "List boards not saved"
  def boards_new
    IronTrello::Commands::ListNewBoards.new.run
  end

  desc "boards-save BOARD_ID", "Save board for linkage"
  def boards_save(board_id)
    IronTrello::Commands::SaveBoard.new.run(board_id)
  end

  desc "link-new LINK", "Post link to all boards"
  def link_new(link)
    IronTrello::Commands::PostLink.new.run(link)
  end

end


IronTrello::CLI.start(ARGV)
