SimonSiesta::Application.routes.draw do
  root to: "game#new"
  post '/pusher/auth' => 'pusher#auth'
end
