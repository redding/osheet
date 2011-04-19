require 'sinatra/base'
require 'osheet'

Osheet.register

class SinatraApp < Sinatra::Base

  configure do
    set :root, File.expand_path(File.dirname(__FILE__))
  end

  get '/index.xls' do
    @times = 2
    osheet :index
  end
end