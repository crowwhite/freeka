Freeka
======
* This is a e-donation portal where users make request about their requirements. Potential donors can browse through the requests and contact them on the comment thread if they are interested to donate.

* The requests can be made about anything materialistic or service seeked.


System Requirements
===================
* Operating system: All who has ruby installed
* Ruby Version: >= 1.9
* Rails: >= 4.1.7
* Database: Relational(mysql, pgsql etc) --though mysql is used in this project


How to Setup
============
* [Clone][clone_url] this repository
* Navigate to the APP_ROOT
* run 'bundle install'
* setup database.yml taking help from database.example.yml
* run 'rake db:create'
* run 'rake db:migrate' or 'rake db:schema:load'
* Setup secrets and mailer passwords as your env variables.
* I haven't provided any seeds yet. So you need to feed all the data. Oops! Sorry!
* To get admin access, run the rake task for admin 'rake admin:create'

[clone_url]: https://github.com/vinsol/freeka.git


Usage
=====

* There are two main sections
  * User Section
  * Admin Section
* User section can be accessed by the base url 'localhost:3000'
* For admin section you can login on 'localhost:3000/admin'
* Admin can create categories, and see summary of users and requests created.
* User can only create Requests and update his/her profile.


Some Helpful Tips
=================

* Currently this project is deployed on heroku. [Click here to open][freeka_url]

[freeka_url]: https://freeka.herokuapp.com
