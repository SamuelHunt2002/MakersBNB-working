require_relative "./message"
require_relative "./user_repository"

class MessageRepository
  def all_recieved_by_user(recipient_id)
    sql = "SELECT
        messages.sender_id AS sender_id,
        messages.message_title AS message_title,
        messages.recipient_id AS recipient_id,
        messages.content AS content,
        users.user_id,
        users.user_name
      FROM messages
      JOIN users
      ON recipient_id = users.user_id
      WHERE recipient_id = $1"

    params = [recipient_id]

    result_set = DatabaseConnection.exec_params(sql, params)
    messages_array = []
    result_set.each do |message|
      new_message = Message.new()
      new_message.sender_id = message["sender_id"].to_i
      new_message.recipient_id = message["recipient_id"].to_i
      new_message.message_title = message["message_title"]
      new_message.content = message["content"]
      messages_array << new_message
    end
    return messages_array
  end

  def send(sender_id, recipient_id, title, content)
    sql = "INSERT INTO messages (sender_id, recipient_id, message_title, content) VALUES ($1, $2, $3, $4)"
    params = [sender_id, recipient_id, title, content]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def find(id)
    sql = "SELECT * FROM messages WHERE message_id = $1"
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)[0]
    return result_set
  end

  def reply_to_message(message_id, reply_content)
    # Find the original message in the database

    original_message = find(message_id)

    # Create a new reply message with the original message's to and from fields reversed,
    # and the reply content as the message content
    reply_message = Message.new

    reply_message.sender_id = original_message["recipient_id"]
    reply_message.recipient_id = original_message["sender_id"]
    reply_message.message_title = "Reply to #{original_message["message_title"]}"
    reply_message.content = reply_content

    # Save the reply message to the database
    send(reply_message.sender_id, reply_message.recipient_id, reply_message.message_title, reply_message.content)
  end
end
