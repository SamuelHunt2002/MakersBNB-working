require_relative './user'
class UserRepository
    def all
        sql_query = 'SELECT user_id, user_name from users'
        all_users = DatabaseConnection.exec_params(sql_query, [])
        users =[]
        all_users.each do |eachuser|
            user = User.new
            # user.fullname = userObject['fullname']
            user.user_name = eachuser['user_name']
            # user.email_address = userObject['email_address'] (to be implemented later)
            users << user
        end
        return users
    end
end




