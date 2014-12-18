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
    def self.find user_id
      sql = %q[SELECT * FROM users WHERE id = $1]
      result = RPS.db.exec(sql, [id])
      result.first
    end

    # log a user in with username and password
    # returns true or false
    def self.user_login db, user_data
      sql = %q[SELECT password FROM users WHERE username = $1]  # create sql
      result = (sql, [user_data[:username]])                    # execute sql
      result.first                                              # sql result

      # if result.first has data
      if (result.first) then
        # test encrypted login password against database encrypted password
        if (BCrypt::Password.create([user_data[:password]]) == result[:password])
          return true   # Success... encrypted passwords matches
        else
          return false  # Fail...   encrypted passwords do not match
        end
      else
        # Fail... user not found
        false
      end if

    end

    # save a new user & password into users db
    def self.save db, user_data
      # encrypt password for new user
      myPasswordEncrypted = BCrypt::Password.create([user_data[:password]])
      # gmh 20141218-1041- not sure following syntax is correct...
      new_user_data = {:user_id => user_data[:username], :password => myPasswordEncrypted}

      sql = %q[INSERT INTO users (username, password) VALUES($1, $2)]
      result = db.exec(sql, [new_user_data[:username], new_user_data[:password]])
      result.first
    end
  end
end

#
# 2014-12-18 10:14AM Users Table Layout
#
# CREATE TABLE IF NOT EXISTS users(
#   id SERIAL PRIMARY KEY,
#   username VARCHAR,
#   password VARCHAR
# );

