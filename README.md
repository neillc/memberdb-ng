A reworking of memberdb - uses the original database but replaces the frontend
with flask based application.

Eventually there may be an be angularish front end, but for now it is 
implemented in flask

Installation
============

**Note: requires python3**  (3.4 is recommended)

**Note: These install instructions are out of date.

1. `git clone https://github.com/neillc/memberdb-ng`
2. `cd memberdb-ng`
3. creeate a virtualenv
4. using your virtualenv:
   pip install -r requirements.txt
5. create a mysqldatabase using the schema in member_db_schema.sql
6. populate the database  TODO: How?
7. configure environment variables:

`   SQLALCHEMY_DATABASE_URI - sqlalchemy connect string for the db
      e.g. mysql+mysqlconnector://<user>:<password>@<ip>/<dbname>
    PORT                - port the server listens on. Defaults to 8531
    HOST                - host we run on. Defaults to 127.0.0.1
    MAIL_SERVER         - server for sending mail
    MAIL_PORT           - port the mail server listens on
    MAIL_USE_SSL        - use SSL to talk toi mail server. Default True
    MAIL_USERNAME       - username for mail server
    MAIL_PASSWORD       - password for mail server
    MAIL_DEFAULT_SENDER - default from address for mail sent by app
8. using your virtualenv:
   python main.py
