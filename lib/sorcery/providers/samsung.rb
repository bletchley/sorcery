module Sorcery
  module Providers
    class Samsung < Base

      include Protocols::Oauth2

      attr_accessor :auth_url, :token_url, :user_info_url

      def initialize
        super

        @site          = 'https://accounts.samsungsami.io'
        @auth_url      = '/authorize'
        @token_url     = '/token'
        @user_info_url = 'https://api.samsungsami.io/v1.1/users/self'
      end

      def get_user_hash(access_token)
        response = access_token.get(user_info_url)

        auth_hash(access_token).tap do |h|
          h[:user_info] = JSON.parse(response.body)['data']
          h[:uid] = h[:user_info]['id']
        end
      end

      def login_url(params, session)
        authorize_url(authorize_url: auth_url)
      end

      def process_callback(params, session)
        args = params.select {|k,v| k.to_sym == :code}

        get_access_token(args, token_url: token_url, token_method: :post)
      end

    end
  end
end
