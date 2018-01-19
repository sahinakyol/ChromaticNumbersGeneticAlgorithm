require 'sinatra'
require 'sinatra/base'
require './process.rb'

set :bind, '0.0.0.0'
set :port, 9494
# set :static, true
# set :public_folder, "static"
set :views, "views"

module ControllerModule
  class Controller < Sinatra::Base

      get '/' do
        erb :index
      end

      post '/save_file/' do
            @fileName = params[:file][:filename]
            file = params[:file][:tempfile]
            File.open("./datasets/#{@fileName}", 'wb') do |f|
            f.write(file.read)
            f.close
              end
          processor = ProcessorModule::Process.new(@fileName)
          @adjacentVertices = processor.adjacentVertices()
          @chromosome = processor.chromosomeHashSender.values.first
          @chromosomePop = processor.chromosomeHashSender
          @fitness = processor.fitness()
          @roulette = processor.roulette()
          @crossover = processor.crossover()
        erb :show
      end

      not_found do
        status 404
        erb :page_404
      end
    end
  end
