require 'pg'

require_relative 'rps/repos/game_repo.rb'
require_relative 'rps/repos/user_repo.rb'
require_relative 'rps/repos/rounds_repo.rb'


module RPS
  def self.create_db_connection(dbname)
    PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.clear_db(db)
    db.exec <<-SQL
      DELETE FROM games;
      DELETE FROM rounds;
      DELETE FROM users;
    SQL
  end

  def self.create_tables(db)
    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        username VARCHAR,
        password VARCHAR
      );
      CREATE TABLE IF NOT EXISTS games(
        id SERIAL PRIMARY KEY,
        player1 INT references users(id),
        player2 INT references users(id),
        game_winner VARCHAR
      ); 
      
      CREATE TABLE IF NOT EXISTS rounds(
        id SERIAL PRIMARY KEY,
        p1 INT references users(id),
        p2 INT references users(id),
        game_id INT references games(id),
        p1move VARCHAR,
        p2move VARCHAR,
        round_winner VARCHAR
      );
    SQL
  end

  def self.seed_users(db)
    db.exec <<-SQL
      INSERT INTO users (username, password) values ('testuser', 'pass123')
    SQL
  end

  def self.drop_tables(db)
    db.exec <<-SQL
      DROP TABLE games;
      DROP TABLE rounds;
      DROP TABLE users;
    SQL
  end
end