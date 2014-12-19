module RPS
  class RoundsRepo

    def self.find_by_userid db, rounds_data
      sql = %q[
        SELECT * FROM rounds
        WHERE
          player1_id = $1
        OR
          player2_id = $1
      ]
      result = db.exec(sql, [rounds_data[:user_id]])
      result.entries
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

    def self.save db, rounds_data
      sql = %q[INSERT INTO rounds (p1, p2) VALUES AT ($1, $2)]
      result = db.exec(sql, rounds_data[:opponent_id], rounds_data[:user_id])
      result.entries
      # save the player1 id and the player2 id, and in table have player1 id, player2 id, player1 move and player 2 move
    end

    def self.play_move
      # should take the user id who is playing the move and the move they want to play
      # get the wrong
    end
  end
end

# post '/rounds' do
#   # this is where you create a new match between the current user and the user they clicke don
#   # params will have key called :opponent_id
#   # youll have to use the matchesrepo to record that a match has started with those two users
#   # once thats done redirect to a match page
#   round = RPS::RoundsRepo.save(@current_user['id'], params[:opponent_id])
#   redirect to '/rounds/' + round['id']
# end


 # CREATE TABLE IF NOT EXISTS rounds(
 #        id SERIAL PRIMARY KEY,
 #        p1 INT references users(id),
 #        p2 INT references users(id),
 #        game_id INT references games(id),
 #        p1move VARCHAR,
 #        p2move VARCHAR,
 #        round_winner VARCHAR
 #      );