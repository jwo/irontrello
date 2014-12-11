module IronTrello

  def self.api_key
    @db = IronTrello::DB.conn
    @db.read(:api).first.key
  end

  module Commands

    class Command
      def initialize
        @db = IronTrello::DB.conn

        unless @db.read(:auth) && @db.read(:api)
          IronTrello::DB.setup
          @db = IronTrello::DB.conn
        end

        auth = @db.read(:auth).first
        api = @db.read(:api).first
        if auth && api
          Trello.configure do |config|
            config.developer_public_key = api.key
            config.member_token = auth.member_token
          end
        else
          puts "Please save your api_key and your token (api-save) and (auth-save)"
        end
      end
    end

    class Api < Command
      def initialize
      end
      def run(token)
        @db = IronTrello::DB.conn
        # save auth
        @db.relations.api.insert(key: token)
      end
    end

    class Setup < Command
      def initialize
      end
      def run(member_token)
        IronTrello::DB.setup
        @db = IronTrello::DB.conn
        # save auth
        @db.relations.auth.insert(member_token: member_token)
      end
    end

    #class Auth < Command
    #  def run
    #    @db.read(:auth).to_a.first.token
    #  end
    #end



    class ListNewBoards < Command
      def run
        Trello::Board.all
          .reject{|b| b.closed }
          .reject{|b| @db.read(:boards).by_trello_id(b.id).any? }
          .each do |board|
            puts [board.name, board.id].join(" - ")
          end
      end
    end

    class ListAllBoards < Command
      def run
        @db.read(:boards).to_a.each do |board|
          puts [board.name, board.trello_id].join(" - ")
        end
      end
    end


    class SaveBoard < Command
      def run(id)
        board = Trello::Board.find(id)
        @db.relations.boards.insert(trello_id: board.id, name: board.name)
      end
    end

    class PostLink < Command
      def run(link)
        @db.read(:boards).to_a.each do |board|

          board = Trello::Board.find(board.trello_id)
          username = board.members.first.username
          todo_list = board.lists.find{|l| l.name == "To Do"}

          if todo_list
            card = Trello::Card.create list_id: todo_list.id,
              name: "New Posting #{link}",
              description: link,
              url: link
            card.due = 1.week.from_now.iso8601
            card.save
            card.add_comment("@#{username}")
          end
        end
      end
    end


  end
end
