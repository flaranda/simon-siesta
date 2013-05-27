SimonSiesta::Application.routes.draw do
  root to: "game#new"
  get '/play' => 'game#play'
  post '/pusher/auth' => 'pusher#auth'
end
