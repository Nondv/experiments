require 'rack/reloader'
require_relative 'app'

use Rack::Reloader

run ->(env) { APP.call(env) }
