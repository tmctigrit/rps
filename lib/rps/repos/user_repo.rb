module RPS
  class UsersRepo

    # find user by username
    def self.find_by_name db, user_data
      sql = %q[SELECT * FROM users WHERE username = $1]
      result = db.exec(sql, [user_data[:username]])
      result.first
      #
      # add code - decrypt password after retreival from db
      #
    end

    # save a new user & password into users db
    def self.save db, user_data
      #
      # add code - encrypt password before insert
      #
      sql = %q[INSERT INTO users (username, passwrod) VALUES($1, $2)]
      result = db.exec(sql, [user_data[:username], user_data[:password]])
      result.first
    end
  
  end
end


