import datetime
from faker import Factory

from sqlalchemy import create_engine
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session

import backend

fake =  Factory.create('en_AU')

print(fake.name())

print(backend.settings.db_connection)

#id           | int(11)     | NO   | PRI | NULL    | auto_increment |
#date_entered | datetime    | YES  |     | NULL    |                |
#first_name   | varchar(50) | NO   |     | NULL    |                |
#middle_name  | varchar(50) | YES  |     | NULL    |                |
#last_name    | varchar(50) | YES  |     | NULL    |                |
#DOB          | date        | YES  |     | NULL    |                |
#sex          | char(1)     | YES  |     | NULL    |                |
#address1     | varchar(50) | YES  |     | NULL    |                |
#address2     | varchar(50) | YES  |     | NULL    |                |
#suburb       | varchar(50) | YES  |     | NULL    |                |
#postcode     | varchar(10) | YES  |     | NULL    |                |
#state        | varchar(50) | YES  |     | NULL    |                |
#country      | varchar(20) | YES  |     | NULL    |                |
#email        | varchar(50) | YES  | MUL | NULL    |                |
#phone_home   | varchar(25) | YES  |     | NULL    |                |
#phone_mobile

conn_str = 'mysql+mysqlconnector://neill:secret1234@127.0.0.1/memberdb'
engine = create_engine(backend.settings.db_connection)
Base = automap_base()
Base.prepare(engine, reflect=True)
session = Session(engine)
Members = Base.classes.members

for i in range(100):
    fake_person = {
        'date_entered':datetime.datetime.now(),
        'first_name':fake.first_name(),
        'middle_name':fake.first_name(),
        'last_name':fake.last_name(),
        'DOB':fake.date(),
        'sex':fake.random_element(('M', 'F')),
        'address1':fake.street_address(),
        'address2':fake.street_address(),
        'suburb':fake.city(),
        'postcode':fake.postcode(),
        'state':fake.state(),
        'country':fake.country()[:20],
        'email':fake.email(),
        'phone_home':fake.phone_number(),
        'phone_mobile':fake.phone_number(),
    }

    m = Members (**fake_person)
    session.add(m)

session.commit()
