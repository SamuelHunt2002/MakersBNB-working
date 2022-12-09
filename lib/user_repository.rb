require_relative "./user"

class UserRepository
  def all
    sql_query = "SELECT user_id, user_name, email_address, pass_word from users"
    all_users = DatabaseConnection.exec_params(sql_query, [])
    users = []
    all_users.each do |eachuser|
      user = User.new
      # user.fullname = eachuser['fullname'] maybe implemented later
      user.user_name = eachuser["user_name"]
      user.email_address = eachuser["email_address"]
      user.pass_word = eachuser["pass_word"]
      users << user
    end

    return users
  end

  def find_by_username(username)
    sql = "SELECT * FROM users WHERE user_name = $1"
    begin
      result_set = DatabaseConnection.exec_params(sql, [username])

      returned_user = User.new()
      returned_user.user_id = result_set[0]["user_id"]
      returned_user.user_name = result_set[0]["user_name"]
      returned_user.pass_word = result_set[0]["pass_word"]

      return returned_user
    rescue IndexError
      return nil
    end
  end

  def find_by_email(email_address)
    sql = "SELECT * FROM users WHERE email_address = $1"
    begin
      result_set = DatabaseConnection.exec_params(sql, [email_address])

      returned_user = User.new()
      returned_user.user_id = result_set[0]["id"]
      returned_user.user_name = result_set[0]["user_name"]
      returned_user.pass_word = result_set[0]["pass_word"]
      returned_user.email_address = result_set[0]["email_address"]

      return returned_user
    rescue IndexError
      return nil
    end
  end

  def create(user)
    sql_query = "INSERT INTO users (user_name, email_address, pass_word) VALUES ($1, $2, $3)"
    param = [user.user_name, user.email_address, user.pass_word]
    DatabaseConnection.exec_params(sql_query, param)
    return "User created"
  end


  def user_name_by_user_id(user_id)
    sql = "SELECT user_name FROM users WHERE user_id = $1"
    result_set = DatabaseConnection.exec_params(sql, [user_id])[0]["user_name"]

    return result_set
  end 
end
