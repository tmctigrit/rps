module RPS
  class RoundsRepo
    def self.find_by_userid db, rounds_data
      sql = %q[SELECT * FROM rounds WHERE user_id = $1]
      result = db.exec(sql, [rounds_data[:user_id]])
      result.first
    end

    def self.find_by_gameid db, rounds_data
      sql = %q[SELECT * FROM rounds WHERE game_id = $1]
      result = db.exec(sql, [rounds_data[:game_id]])
      result.first
    end

    def self.find_by_player1_all db, rounds_data
      sql =%q[SELECT * FROM rounds WHERE player1 = $1]
      result = db.exec(sql, [rounds_data[:player1]])
      result.entries
    end

    def self.find_by_player2_all db, rounds_data
      sql =%q[SELECT * FROM rounds WHERE player2 = $1]
      result = db.exec(sql, [rounds_data[:player2]])
      result.entries
    end    
  end
end

#
# 2014-12-18 9:20AM Rounds Table Layout
#
# CREATE TABLE IF NOT EXISTS rounds(
#        id SERIAL PRIMARY KEY,
#        user_id INT references users(id),
#        game_id INT references (games(id)
#        player1 VARCHAR,
#        player2 VARCHAR,
#        p1move VARCHAR,
#        p2move VARCHAR,
#        round_winner VARCHAR