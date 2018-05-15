# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DbProject.Repo.insert!(%DbProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `insert!`
# and so on) as they will fail if something goes wrong.

Code.load_file("seeds_events.exs", __DIR__)
Code.load_file("seeds_members.exs", __DIR__)

DbProject.Repo.insert!(%DbProject.Accounts.Role{name: "Event admin", atom: "event_admin"})
DbProject.Repo.insert!(%DbProject.Accounts.User{name: "Michał Dolata", email: "michal.dolata@akai.org.pl", roles: [%DbProject.Accounts.Role{name: "User admin", atom: "user_admin"}]})
DbProject.Repo.insert!(%DbProject.Accounts.User{name: "Michał Dziardziel", email: "michal.dziardziel@akai.org.pl", roles: [%DbProject.Accounts.Role{name: "Former Member admin", atom: "former_member_admin"}]})
