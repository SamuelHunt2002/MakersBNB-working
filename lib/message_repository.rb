require_relative "./message"
require_relative "./user_repository"
class MessageRepository
    def all_recieved_by_user(recipient_id)
        sql = "SELECT
        messages.sender_id AS sender_id,
        messages.recipient_id AS recipient_id,
        messages.content AS content,
        users.user_id,
        users.user_name
      FROM messages
      JOIN users
      ON recipient_id = users.user_id
      WHERE recipient_id = $1"
        params = [recipient_id]

        result_set = DatabaseConnection.exec_params(sql,params)
        messages_array = []
        result_set.each do |message|
            new_message = Message.new()
            new_message.sender_id = message["sender_id"].to_i
            new_message.sender_name = message[""]
            new_message.recipient_id = message["recipient_id"].to_i
            new_message.content = message["content"]
            messages_array << new_message
        end 
        return messages_array
    end


    def send(sender_id, recipient_id, content)
        sql = "INSERT INTO messages (sender_id, recipient_id, content) VALUES ($1, $2, $3)"
        params = [sender_id, recipient_id, content]
        DatabaseConnection.exec_params(sql, params)
        return nil 
    end
end 