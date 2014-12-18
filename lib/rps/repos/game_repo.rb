module
  class GameRepo
    def self.all db
      sql = %q[SELECT * FROM games ]
      result = db.exec(sql)
      result.entries
    end

    def self.find_by_id db, id
      sql = %q[SELECT * FROM games WHERE id = $1]
      result = db.exec(sql, [id])
      result.first
    end

    def start_game db, players
      sql = %q[INSERT INTO games (player1, player2) VALUES ($1, $2) RETURNING *]
      result = db.exec(sql, [players[:player1], players[:player2])
      result.first
    end

    def active_games_by_user db, username
      sql = %q[SELECT * FROM games WHERE player1 = $1 OR player2 = $1 AND game_winner IS NULL]
      result = db.exec(sql, [username])
      result.entries
    end

    def past_games_by_user db, username
      sql = %q[SELECT * FROM games WHERE player1 = $1 OR player2 = $1 AND game_winner IS NOT NULL]
      result = db.exec(sql, [username])
      result.entries
    end

    def get_player1_name(game_id)
      sql = %q[SELECT player1 FROM games WHERE id = $1]
      result = db.exec(sql, [game_id])
      result.first
    end

    def get_player2_name(game_id)
      sql = %q[SELECT player2 FROM games WHERE id = $1]
      result = db.exec(sql, [game_id])
      result.first
    end

   end
end