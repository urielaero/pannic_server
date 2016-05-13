defmodule Util.Mailer do
  @config domain: Application.get_env(:pannic, :mailgun_domain),
          key: Application.get_env(:pannic, :mailgun_key),
          httpc_opts: [connect_timeout: 4000, timeout: 5000]

  use Mailgun.Client, @config

  @from "alert@pannic_button.com"

  def send_notify(email, action, msg) do
    html ="<p> #{msg}  </p>"
    send_email to: email,
               from: @from,
               subject: action,
               html: html
  end

  def in_memory?, do: false

end

defmodule Util.Mailer.InMemory do
  def start_link do
    Agent.start_link(fn -> 
      %{}
    end, name: __MODULE__)
  end

  def send_notify(email, action, msg) do
    Agent.update(__MODULE__, &(Dict.put(&1, email, msg)))
  end

  def get_inbox(email) do
    Agent.get_and_update(__MODULE__, fn inboxs -> 
      Dict.pop(inboxs, email)
    end)
  end

  def in_memory?, do: true
end
