module RPS 
  class GameRepo

    # get all games
    def self.all db
      sql = %q[SELECT * FROM games ]
      result = db.exec(sql)
      result.entries
    end


sql = %q[SELECT $1 FROM $2 WHERE $3 = $4]

    # find game by game id
    def self.find_by_id db, id
      sql = %q[SELECT * FROM games WHERE id = $1]
      result = db.exec(sql, [id])
      result.first
    end

    # given player1 and player2 id's, start a new game
    def start_game db, players
      sql = %q[INSERT INTO games (player1, player2) VALUES ($1, $2) RETURNING *]
      result = db.exec(sql, players[:player1], players[:player2])
      result.first
    end

    #  given username, find games with username where there is no winner
    def active_games_by_user db, username
      sql = %q[SELECT * FROM games WHERE player1 = $1 OR player2 = $1 AND game_winner IS NULL]
      result = db.exec(sql, [username])
      result.entries
    end

    # given username, find games where there is a winner
    def past_games_by_user db, username
      sql = %q[SELECT * FROM games WHERE player1 = $1 OR player2 = $1 AND game_winner IS NOT NULL]
      result = db.exec(sql, [username])
      result.entries
    end

    # given game_id, get player1 name from users table
    def get_player1_name_by_game_id(game_id)
      sql = %q[SELECT u.username FROM games as g, users as u WHERE g.id = u.id AND g.id = $1]
      result = db.exec(sql, [game_id])
      result.first
    end
    
    # given game_id, get player2 name from users table
    def get_player2_name_by_game_id(game_id)
      sql = %q[SELECT u.username FROM games as g, users as u WHERE g.id = u.id AND g.id = $1]
      result = db.exec(sql, [game_id])
      result.first
    end

    # given player1 id, get player1's username
    def get_player1
    # given player2 id, get player2's username


  end
end

#
# 2014-12-18 10:14AM Games Table Layout
#
# CREATE TABLE IF NOT EXISTS games(
#   id SERIAL PRIMARY KEY,
#   player1 INT references users(id),
#   player2 INT references users(id),
#   player1_move VARCHAR,
#   player2_move VARCHAR,
#   winner INT references users(id)
# );