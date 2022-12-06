require_relative './user'
class UserRepository
    def all
        sql_query = 'SELECT user_id, user_name, email_address from users'
        all_users = DatabaseConnection.exec_params(sql_query, [])
        users =[]
        all_users.each do |eachuser|
            user = User.new
            # user.fullname = eachuser['fullname'] maybe implemented later
            user.user_name = eachuser['user_name']
            user.email_address = eachuser['email_address']
            users << user
        end
        return users
    end
    def create(user)
        sql_query = 'INSERT INTO users (user_name, email_address) VALUES ($1, $2)'
        param = [user.user_name, user.email_address]
        DatabaseConnection.exec_params(sql_query,param)
        return "User created"
    end
end




