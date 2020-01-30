     
require 'sinatra'
require 'httparty'
require 'bcrypt'
require 'pg'

if development?
  require 'sinatra/reloader' 
  require 'pry'
end

def run_sql(sql, args = []) # second argument is optional
  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'cosmetic_app', password: '1234'})

  # protecting sql injection
  # results = conn.exec(sql)
  results = conn.exec_params(sql, args)
  conn.close
  return results
end


def create_user(email, password, gender, age, skin_type, skin_trouble)
  password_digest = BCrypt::Password.create(password)

  sql = <<~SQL
    INSERT INTO users 
    (email, password_digest, gender, age, skin_type, skin_trouble)
    VALUES
    ($1, $2, $3, $4, $5, $6);
  SQL

  run_sql(sql, [email, password_digest, gender, age, skin_type, skin_trouble])
end


def create_products(brand, name, image_link, price, user_id)

  sql = <<~SQL
    INSERT INTO products
    (brand, name, image_link, price, user_id)
    VALUES
    ($1, $2, $3, $4, $5)
  SQL

  run_sql(sql, [brand, name, image_link, price, user_id])
end

def all_products

  sql = "select * from products;"

  run_sql(sql)
end

enable :sessions


def logged_in?
  if session[:user_id]
    return true
  else
    return false
  end
end


def current_user
  run_sql("select * from users where id = #{ session[:user_id] };")[0]
end


######################################################################################

get '/' do

  url = "http://makeup-api.herokuapp.com/api/v1/products.json"
  @results = HTTParty.get(url)
  
  erb :index
end

# get '/product' do

#   erb :product
# end

get '/product/:id' do
  
  url = "http://makeup-api.herokuapp.com/api/v1/products.json"
  @results = HTTParty.get(url)
  index = @results.index{|e| e['id'] == params[:id].to_i}
  @result = @results[index]
  erb :product
end


post '/product/:id' do

  url = "http://makeup-api.herokuapp.com/api/v1/products.json"
  @results = HTTParty.get(url)
  index = @results.index{|e| e['id'] == params[:id].to_i}
  p index
  @result = @results[index]

  create_products(@result['brand'], @result['name'], @result['image_link'], @result['price'])

  redirect '/cart'
end


get '/cart' do
  redirect '/login' unless logged_in?

  @products = all_products()
  p @products

  erb :cart
end


# login page
get '/login' do

  erb :login
end


post '/login' do

  sql = "select * from users where email = '#{ params[:email] }';"
  results = run_sql(sql)

  if results.count == 1 && BCrypt::Password.new(results[0]['password_digest']) == params[:password]

    session[:user_id] = results[0]['id']

    redirect '/'
  else
    erb :login
  end
end


# Log Out page
delete '/session' do
  session[:user_id] = nil

  redirect '/login'
end


# signup page
get '/signup' do
  
  erb :signup
end


post '/signup' do

  create_user(params[:email], params[:password], params[:gender], params[:age], params[:skin_type], params[:skin_trouble])

  redirect '/login'
end
