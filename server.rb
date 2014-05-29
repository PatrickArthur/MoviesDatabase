require 'sinatra'
require 'csv'
require 'pry'
require 'redis'
require 'json'
require 'pg'



def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

    yield(connection)


  ensure
    connection.close
  end
end


get '/actors' do
  query = db_connection do |conn|
    conn.exec('SELECT actors.id,actors.name FROM actors
      ORDER BY actors.name;')
  end
  @query2=query.to_a
  erb :'actors/index'
end


get '/actors/:id' do
  query = db_connection do |conn|
    conn.exec('SELECT actors.id,actors.name,movies.title, cast_members.character FROM movies
    JOIN cast_members ON movies.id = cast_members.movie_id
    JOIN actors ON actors.id = cast_members.actor_id
    ORDER BY actors.name;')
  end
  @query3=query.to_a
  @query3.each do |x|
    if x['id'] == params['id']
      @actor = x
    end
  end
   erb :'actors/show'
 end


  get '/movies' do
  query = db_connection do |conn|
    conn.exec('SELECT movies.title,movies.year,movies.rating,
     genres.name as genra,studios.name as studioname FROM movies
      JOIN genres ON movies.genre_id = genres.id
      JOIN studios ON movies.studio_id = studios.id
      ORDER BY movies.title;')
  end
  @query5=query.to_a
  @query5.each do |x|
    if x['title'] == params['title']
      @movie = x
    end
  end
   erb :'movies/index'
 end



 get '/movies/:title' do
  query = db_connection do |conn|
    conn.exec('SELECT actors.id,genres.name as genra,movies.title,studios.name as studioname,
      actors.name as actorname, cast_members.character FROM movies
      JOIN genres ON movies.genre_id = genres.id
      JOIN studios ON movies.studio_id = studios.id
      JOIN cast_members ON movies.id = cast_members.movie_id
      JOIN actors ON actors.id = cast_members.actor_id;')
  end
  @query4=query.to_a
  @query4.each do |x|
    if x['title'] == params['title']
      @movie = x
    end
  end
   erb :'movies/show'
 end













