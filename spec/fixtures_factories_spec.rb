# Example RSpec file for fixtures vs factories (pure Ruby)
#
# Instructions:
# 1. This lesson is about fixtures/factories, but here is a Ruby example.
# 2. Try simulating your own setup code for tests!

RSpec.describe 'Fixtures vs Factories' do
  before do
    @user = { name: 'Alice', age: 30 }
  end

  it 'uses a setup hash as a fixture' do
    expect(@user[:name]).to eq('Alice')
  end

  def user_factory(name)
    { name: name, age: 20 }
  end

  it 'uses a factory method' do
    user = user_factory('Bob')
    expect(user[:name]).to eq('Bob')
  end
end
