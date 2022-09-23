require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/user'
require_relative 'lib/user_repository'
require_relative 'lib/space'
require_relative 'lib/space_repository'
require_relative 'lib/booking'
require_relative 'lib/booking_repository'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb_test')


class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get '/' do
    repo = SpaceRepository.new
    @spaces = repo.all
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    return erb(:index)
  end

  get '/space/:id' do
    repo = SpaceRepository.new
    @space = repo.find_by_id_with_dates(params[:id])
    user_repo = UserRepository.new
    @host = user_repo.find_by_id(@space.user_id)
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    return erb(:space)
  end

  post '/book_space' do
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    booking = Booking.new
    booking.date_id = params[:date]
    booking.user_id = session[:user_id]
    booking.space_id = params[:space_id]
    booking.confirmed = false
    repo = BookingRepository.new
    repo.create(booking)
    return erb(:request_sent)
  end

  get '/login' do
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    if params[:error] == 'credentials_wrong'
      @error = true
    end
    return erb(:login)
  end

  post '/login' do
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    repo = UserRepository.new
    result = repo.sign_in(params[:email], params[:password])
    if result == "successful"
      user = repo.find_by_email(params[:email])
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/login?error=credentials_wrong'
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      @session = session[:user_id]
    end
    session.clear
    redirect '/'
  end
end
