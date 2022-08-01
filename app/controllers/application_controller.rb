require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/reviews' do
    reviews = Review.all.order(:title).limit(20)
    reviews.to_json
  end

  get '/reviews/:id' do
    reviews = Review.find(params[:id])
    reviews.to_json
  end

  post '/reviews' do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )

    review.to_json
  end

  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.update(
      score: params[:score],
      comment: params[:comment]
    )

    review.to_json
  end


  # Delete request
  delete '/reviews/:id' do
    # find the review using the ID
    # delete the review
    # send a response with the deleted review as JSON
    
    review = Review.find(params[:id])
    review.destroy
  end

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end
end
