import app/web.{Context}
import app/router
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist
import dot_env
import dot_env/env

pub fn main() -> Nil {
  wisp.configure_logger()

  dot_env.new() 
  |> dot_env.set_path(".env") 
  |> dot_env.set_debug(False) 
  |> dot_env.load 

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE") 

  let ctx = Context(static_directory: static_directory(), items: [])

  let handler = router.handle_request(_ , ctx)

  let assert Ok(_) = 
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn static_directory()  -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("app")
  priv_directory <> "/static" 
}