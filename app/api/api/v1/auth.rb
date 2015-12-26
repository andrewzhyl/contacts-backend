module API::V1
  class Auth  < Grape::API
    include API::V1::Defaults
    
    helpers do
      def user_params
        clean_params(params).require(:user).permit(:email, :password, :password_confirmation)
      end
    end

    namespace 'auth' do

      desc "注册"
      params do
        requires :user, type: Hash do
          requires :email
          requires :password
        end
      end
      post 'signup' do
        @user = User.new(user_params)
        if @user.save
          @token = TokenProvider.issue_token({ user_id: @user.id })
          status 200
          render @user, meta: @token , meta_key: "token"
        else
          error!({ errors: @user.errors }, 401)
        end
      end

      desc "登陆接口"
      params do
        requires :email
        requires :password
      end
      post "login" do
        @user = User.find_by(email: params[:email].downcase)
        if @user && @user.authenticate(params[:password])
          status 200
          @token = TokenProvider.issue_token({ user_id: @user.id })
          render @user, meta:  @token , meta_key: "token"
        else
          error!("无效的用户名或密码", 401)
        end
      end

      desc "token_status"
      post "token_status" do
        token = params[:token]
        if TokenProvider.valid? token
          status 200
        else
          status 401
        end
      end

    end

  end
end
