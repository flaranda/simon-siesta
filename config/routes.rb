SimonSiesta::Application.routes.draw do
  root to: "game#new"
  get '/play' => 'game#play', as: 'play'
  get '/levels/:level_number' => 'levels#show', as: 'level'
  post '/pusher/auth' => 'pusher#auth'
end
