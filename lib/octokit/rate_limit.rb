# frozen_string_literal: true

module Octokit
  # Class for API Rate Limit info
  #
  # @!attribute [w] limit
  #   @return [Integer] Max tries per rate limit period
  # @!attribute [w] remaining
  #   @return [Integer] Remaining tries per rate limit period
  # @!attribute [w] resets_at
  #   @return [Time] Indicates when rate limit resets
  # @!attribute [w] resets_in
  #   @return [Integer] Number of seconds when rate limit resets
  #
  # @see https://developer.github.com/v3/#rate-limiting
  class RateLimit < Struct.new(:limit, :remaining, :resets_at, :resets_in)
    # Get rate limit info from HTTP response
    #
    # @param response [#headers] HTTP response
    # @return [RateLimit]
    def self.from_response(response)
      info = new
      headers = response.headers if response.respond_to?(:headers) && !response.headers.nil?
      headers ||= response.response_headers if response.respond_to?(:response_headers) && !response.response_headers.nil?
      if headers
        info.limit = (headers['X-RateLimit-Limit'] || 1).to_i
        info.remaining = (headers['X-RateLimit-Remaining'] || 1).to_i
        info.resets_at = Time.at((headers['X-RateLimit-Reset'] || Time.now).to_i)
        info.resets_in = [(info.resets_at - Time.now).to_i, 0].max
      end

      info
    end
  end
end
