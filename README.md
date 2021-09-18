Simple server made together with little brother as home project to work as backend for Android app.
-----------------------

      Ruby Sinatra
      Postgresql + Active Record


**Setup:**
- `bundle install`

**Localhost:**

`bundle exec rerun 'rackup'`
or simply
`bundle exec rackup`

*DB+schema reset:*

`bundle exec rake db:drop db:create db:migrate`

`bundle exec rake db:seed` - populates with seed data

**Heroku:**

`brew install heroku/brew/heroku`

`heroku login`

*DB+schema reset:*

`heroku pg:reset --confirm prankster-app`
`heroku run rake db:migrate`

*Logs:*

`heroku logs --tail`
