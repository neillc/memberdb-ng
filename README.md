A reworking of memberdb - uses the original database but replaces the frontend
with a combination of a restful API and a single page web app written in
AngularJS

This readme (and a significant amount of scaffolding) was originally copied 
from r1chardj0n3s' angboard application - https://github.com/r1chardj0n3s/angboard

At this point most of this README is irrelevant. The only part of this app that is
currently working is an automatically generated REST api.

See for example http://127.0.0.1:8531/api/members/

Eventually there will be angularish and/or flask front end bits

Installation
============

**Note: requires python3**  (3.4 is recommended)

To set up, first install node / npm per your operating system, and then:

1. `git clone https://github.com/neillc/memberdb-ng`
2. `cd memberdb-ng`
3. creeate a virtualenv
4. using your virtualenv:
   pip install -r requirements.txt
5. create a mysqldatabase using the schema in member_db_schema.sql
6. populate the database  TODO: How?
7. adjust settings.py to connect to your database
8. using your virtualenv:
   python main.py
