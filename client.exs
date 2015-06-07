defmodule Client do

  def connect(username, server) do
    spawn(Client, :start, [username, server])
  end

  def start(username, server) do
    send server, {self, :connect, username}
    loop(username, server)
  end

  def loop(username, server) do
    receive do
      {:info, msg} ->
        IO.puts(~s{[#{username}'s client] - #{msg}})
        loop(username, server)
      {:new_msg, from, msg} ->
        IO.puts(~s{[#{username}'s client] - #{from}: #{msg}})
        loop(username, server)
      {:send, msg} ->
        send server, {self, :broadcast, msg}
        loop(username, server)
      :disconnect ->
        exit(0)
    end
  end
end
