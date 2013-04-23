require 'rubygems'
require 'sinatra/base'
require 'reportcard'
require 'csv'

class ReportCardApp < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html        
  end
  
  #Configure application level options
  configure do |app|
    set :static, true    
    set :views, File.dirname(__FILE__) + "/../views"
    set :public, File.dirname(__FILE__) + "/../public"      
  end

  get "/" do
    erb :index
  end
  
  get "/card" do
    @classes = ReportCard::Util.classes_for_dataset( params[:uri] )
    @types = {}
    CSV.open( File.dirname(__FILE__) + "/../config/type-mapping.csv", "r" ).each do |row|
      @types[ row[0] ] = row[1]
    end
    
    @card = {
      "CreativeWork" => 0,
      "Term" => 0, 
      "Person" => 0,
      "Place" => 0,
      "Organization" => 0,
      "Product" => 0,
      "Thing" => 0,
      "Event" => 0,
      "Tag" => 0,      
      "Statistic" => 0,      
    }
    @classes.each do |klazz, count|
      type = @types[klazz]
      if type != nil
        @card[type] = @card[type] + count.to_i
      else
        puts klazz
      end
    end    
    
    @card = @card.sort { |a,b| a <=> b }
    
    @uri = params[:uri]
    erb :dataset
            
  end
  
end