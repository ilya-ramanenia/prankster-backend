Simple server made together with little brother as home project to work as backend for Android app.
-----------------------

      Ruby Sinatra
      Postgresql + Active Record


**Setup:**
- `bundle install`

**Localhost:**

`bundle exec rackup`

`rake db:drop db:create db:migrate` - wipes out the whole app database, recreates it and then goes through every migration to update the schema (db/schema.rb or db/structure.sql)

`rake db:reset` OR `rake db:drop db:schema:load db:seed` - wipes out the whole app database but it does not update the schema, and then populates with seed data

**Heroku:**

`brew install heroku/brew/heroku`

`heroku login`

`heroku pg:reset`
`heroku run rake db:migrate`
