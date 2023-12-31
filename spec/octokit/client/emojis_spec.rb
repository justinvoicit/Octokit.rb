# frozen_string_literal: true

describe Octokit::Client::Emojis do
  describe '.emojis', :vcr do
    it 'returns all github emojis' do
      client = oauth_client
      emojis = client.emojis
      expect(emojis[:metal]).to match(/metal/)
    end
  end # .emojis
end
