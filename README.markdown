## Live Demo
  [http://morning-dusk-19.heroku.com/] (http://morning-dusk-19.heroku.com/)

## Thanks to heroku

## How to install this application

<pre>
  git clone git@github.com:subbarao/electiondata.git 
</pre>

<pre>
  mv config/database.yml.example config/database.yml
</pre>
 update config/database.yml

 install geokit gem

<pre>
  sudo gem install geokit 
</pre>

<pre>
  rake db:create
  rake db:migrate
  rake db:data:load 
  ruby script/server
</pre>

Execute all the tests
<pre>
rake
</pre>
  


  
