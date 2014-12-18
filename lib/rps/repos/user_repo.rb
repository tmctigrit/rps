module RPS
  class UsersRepo

    # find all 
    def self.all
      sql = %q[SELECT * FROM users]
      result = PSS.db.exec(sql)
      result.entries
    end

    # find user by username
    def self.find_by_username username
      sql = %q[SELECT * FROM users WHERE username = $1]
      result = RPS.db.exec(sql, [username])
      result.first
    end
     
    # find user by id
    def self.find id
      sql = %q[SELECT * FROM users WHERE id = $1]
      result = RPS.db.exec(sql, [id])
      result.first
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

