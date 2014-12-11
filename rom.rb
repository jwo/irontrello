require 'rom-sql'

module IronTrello
  class DB

    def self.setup
      File.delete("./irontrello.db")


      setup = ROM.setup(sqlite: "sqlite://irontrello.db")
      setup.sqlite.connection.create_table :auth do
        primary_key :id
        String :member_token
      end

      setup.sqlite.connection.create_table :api do
        primary_key :id
        String :key
      end

      setup.sqlite.connection.create_table :boards do
        primary_key :id
        String :name
        String :trello_id
      end
    end

    def self.conn
      setup = ROM.setup(sqlite: "sqlite://irontrello.db")


      setup.relation(:boards) do
        def by_trello_id(id)
          where(trello_id: id)
        end
      end

      setup.relation(:auth) do
      end

      setup.relation(:api) do
      end

      setup.mappers do
        define(:boards) do
          model(name: 'Board')
        end

        define(:auth) do
          model(name: 'Auth')
        end

        define(:api) do
          model(name: 'Api')
        end
      end

      setup.finalize

    end
  end
end
