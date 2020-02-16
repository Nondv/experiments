# frozen_string_literal: true

require 'rack/utils'

#
# utility
#
comp = ->(f1, f2) { ->(x) { f1[f2[x]] } }
identity = ->(x) { x }
constant = ->(x) { ->(_) { x } }
second = ->((_a, b)) { b }

#
# Middleware
#
query_to_params = ->(q) { Rack::Utils.parse_nested_query(q) }
query_from_env = ->(env) { env['QUERY_STRING'] }
env_to_params = comp[query_to_params, query_from_env]
env_with_params = ->(env) { env.merge(params: env_to_params[env]) }
params_middleware = ->(handler) { comp[handler, env_with_params] }

content_type_middleware = ->(type) {
  ->(handler) {
    ->(env) {
      status, headers, body = handler[env]
      [status, headers.merge('Content-Type' => type), body]
    }
  }
}
html_content_type_middleware = content_type_middleware['text/html']

#
# Handlers
#
hello_handler = ->(env) { [200, {}, ["Hello #{env[:params]['name']}"]] }
env_inspect_handler = ->(env) { [200, {}, [env.inspect]] }
not_found_handler = ->(env) { [404, {}, ["404 Not found"]] }

#
# Routing
#
exact_path_matcher = ->(path) { ->(env) { env['PATH_INFO'] == path } }

routes = [
  [exact_path_matcher['/'], env_inspect_handler],
  [exact_path_matcher['/hello'], hello_handler],
  # else
  [constant.call(true), not_found_handler]
]
route_matcher = ->(env) { ->((cond, _handler)) { cond[env] } }
find_route = ->(env) { routes.find(&route_matcher[env]) }
find_handler = comp[second, find_route]
router = ->(env) { find_handler[env][env] }

#
# app
#
middleware_list = [
  params_middleware,
  html_content_type_middleware
]
app_middleware = middleware_list.reduce(identity, &comp)

APP = app_middleware[router]
