#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  return SQLite3::Database.new('barbershop.db')
end

configure do
  enable :sessions
  get_db().execute('CREATE TABLE IF NOT EXISTS
    "Users" (
    "ID" INTEGER PRIMARY KEY AUTOINCREMENT, 
    "Name" TEXT, 
    "Phone" TEXT, 
    "DateStamp" TEXT, 
    "Barber" TEXT, 
    "Color" TEXT)')
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger mutherfucker!'
  end
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

before '/visit' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/about' do
  @error = 'something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/login/form' do
  @error = ""
  erb :login_form
end

get '/logout' do
  session.delete(:identity)
  session.delete(:pwd)
  erb "<div class='alert alert-message'>Logged out</div>"
end

post '/login/attempt' do
  if params['userpassword'] == 'secret' then
  	session[:identity] = params['username']
	session[:pwd] = params['userpassword']
  	erb :visit
  else
    @error = "Invalid password!"
    erb :login_form
  end

end

post '/visit' do

  #validation
  hh = {:username => 'Введите имя!',  :phoneno => 'Не указан телефон!', :plantime => 'Не указано время посещения!', :barber => 'Выберите парикмахера!'}

  hh.each do |key, value|
    if params[key].empty?
      @error = value
      return erb :visit
    end
  end

	# input = File.open('.\public\visit.txt', 'a+')
	# input.write("#{params[:username]}; #{params[:plantime]}; #{params[:phoneno]}; #{params[:barber]}\n")
	# input.close
	get_db().execute('INSERT INTO 
                users 
                  (name,
                  phone,
                  datestamp,
                  barber,
                  color)
                values (?, ?, ?, ?, ?)', [params[:username], params[:phoneno], params[:plantime], params[:barber], params[:color]]);


  erb "Уважаемый #{params[:username]}, данные записаны! Ждем вас в #{params[:plantime]}"

end

post '/contacts' do
	input = File.open('.\public\contacts.txt', 'a+')
	input.write("#{params[:email]}; #{params[:msg]}\r")
	input.close
	erb "Данные отправлены, спасибо за обращение!"
end
