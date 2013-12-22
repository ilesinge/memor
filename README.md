Memor
=====

Memor is a bookmark manager.

Features
--------

* Multi-user
* Responsive design (usable on mobile)
* Grouping of bookmarks based on tags
* Import/Export browser-format bookmarks file
* Quick posting with bookmarklet
* Filter with multiple criteria (tags, user, search)
* I18n (available locales : English, French)

Planned features
----------------

* Tag management (rename, merge, delete)
* Commenting system
* REST API

Screenshots
-----------

###Main Memor view:

![Main Memor view](http://www.ndre.gr/memor/memor1.png "Main Memor view")

###Bookmark detail:

![Bookmark detail](http://www.ndre.gr/memor/memor2.png "Bookmark detail")

###On a small screen:

![On a small screen](http://www.ndre.gr/memor/memor3.png "On a small screen")

Technology
----------

* Ruby 2.0
* Rails 4
* Database: tested with MySQL and SQLite (should work with PostgreSQL)
* Twitter Bootstrap
* Bootswatch Metro theme for Bootstrap
* And some Ruby gems : https://github.com/ilesinge/memor/blob/master/Gemfile

Installation
------------

1. Ensure you have Ruby 2.0 installed (with https://rvm.io/, just saying)
2. Set up the database if using MySQL or PostgreSQL
3. Copy `config/database.yml.mysql` (and adapt database auth parameters) or `config/database.yml.sqlite` to `config/database.yml`
4. Comment the line `gem 'mysql2'` or `gem 'sqlite3'` in the file `Gemfile` based on which database you're using 
5. Install gem dependencies:
```sh
gem install bundler
cd memor
bundle install
```
6. Generate database structure:
```sh
rake db:migrate
```
OR if you're doing a production install:
```sh
RAILS_ENV=production rake db:migrate
```
7. Create an admin account:
```sh
# Prepend with 'RAILS_ENV=production' if needed
rake db:seed
```
8. Precompile assets if you're doing a production install:
```sh
RAILS_ENV=production rake assets:precompile
```
9. Start the server:
```sh
# Prepend with 'RAILS_ENV=production' if needed
rails s
```
10. Launch http://localhost:3000/ in your browser
11. Connect with user `administrator`, password `memorFTW!`
12. Access http://localhost:3030/users/administrator/edit to change admin password (and username if you want)

Et voilà !

For production servers, I suggest to use [Unicorn](http://unicorn.bogomips.org/) with Nginx or [Phusion Passenger](https://www.phusionpassenger.com/) with Apache.

Bugs, ideas, questions?
----------------------

Use Github [issue tracker](https://github.com/ilesinge/memor/issues) !
