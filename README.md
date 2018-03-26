# DbProject

DbProject - is small CMS which will deliver content to apps made by AKAI. 

- Content (currently informations about events organized by AKAI) is shared by JSON API. 
- Access to admin panel is provided via email in AKAI's domain. 
- Each AKAI member has roles which define what he/she can do. 

Current endpoints for API:

```
https://dbproject.dolata.me/api/events[?page=n&page_size=m]
https://dbproject.dolata.me/api/events/:id
```

## Installation

* Install [Erlang](http://www.erlang.org/downloads) and then [Elixir](https://elixir-lang.org/install.html).
* Install Phoenix `mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez`
* Install [MySQL](https://dev.mysql.com/doc/refman/5.7/en/installing.html).
* Clone repository.
* Create file `dev.secret.exs` in `config/` directory.
* Fill that file with this template:

```elixir
use Mix.Config

# Configure your database
config :db_project, DbProject.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "password",
  database: "db_project_dev",
  hostname: "localhost",
  pool_size: 10
```

* Create database with name given in config file.
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Now you can start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
