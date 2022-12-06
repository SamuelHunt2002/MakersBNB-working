require 'user_repository'
def reset_users_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  describe UserRepository do
    before(:each) do
      reset_users_table
    end
    context "tests the all method" do
        it "returns all users" do
            user = UserRepository.new
            repo = user.all
            expect(repo[0].user_name).to eq "user1"
            expect(repo[1].user_name).to eq "user2"
            expect(repo[2].user_name).to eq "user3"
            expect(repo[3].user_name).to eq "user4"
            expect(repo[4].user_name).to eq "user5"
        end
    end
  end
