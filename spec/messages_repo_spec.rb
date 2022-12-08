require "message_repository"

def reset_bookings_table
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe MessageRepository do
  before(:each) do
    reset_bookings_table
  end

  it "Retrieves messages" do
    message_repo = MessageRepository.new()
    expect(message_repo.all_recieved_by_user(2).count).to eq 3
    first_message = message_repo.all_recieved_by_user(2)[0]
    expect(first_message.sender_id).to eq 1
    expect(first_message.content).to eq "Hello first message!"
  end

  it "Sends messages" do
    message_repo = MessageRepository.new()
    message_repo.send('2', '1', "Test reply")
    expect(message_repo.all_recieved_by_user(1)[0].content).to eq "Test reply"
  end
end 