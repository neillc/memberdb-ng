from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from backend import db


class EventTypes(db.Model):
    """"
    # -- event_types table
    # -- -----------------
    # -- there are many types of events
    # create table event_types (
    #         id integer auto_increment not null,
    #         type varchar(50),
    #         CONSTRAINT "event_types_pkey" PRIMARY KEY (id)
    # );
    #
    #
    """

    __tablename__ = 'event_types'

    id = Column(Integer, nullable=False, primary_key=True)
    type = Column(String(50), nullable=False)


class EventHostOrgs(db.Model):
    __tablename__ = 'event_host_orgs'

    event_id = Column(
        Integer, ForeignKey('events.id'), nullable=False, primary_key=True
    )
    org_id = Column(
        Integer, ForeignKey('orgs.id'), nullable=False, primary_key=True
    )
    rank = Column(Integer)


class EventOrganisers(db.Model):
    __tablename__ = 'event_organisers'

    event_id = Column(
        Integer, ForeignKey('events.id'), nullable=False, primary_key=True
    )
    member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )
    role = Column(String(50))


class EventSignupStatus(db.Model):
    __tablename__ = 'event_signup_status'

    id = Column(Integer, nullable=False, primary_key=True)
    event_id = Column(Integer, ForeignKey('events.id'), nullable=False)
    status = Column(String(50), nullable=False)


class EventSignup(db.Model):
    __tablename__ = 'event_signup'

    event_id = Column(
        Integer, ForeignKey('events.id'), nullable=False, primary_key=True
    )
    member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )
    event_signup_status_id = Column(
        Integer, ForeignKey('event_signup_status.id'), nullable=False,
        primary_key=True
    )
    ticket = Column(Integer)


class Events(db.Model):
    """
        # -- events table
        # -- ------------
        # -- events are stored in the system independently of orgs
        # -- events have host orgs, listed in the event_host_orgs table
        # -- this is how we work out who is hosting an event/running it.
        # --
        # -- we also track organisers of events and a few other little
        # -- useful bits of information. Most info should be on the event
        # -- page though.
    """
    __tablename__ = 'events'

    id = Column(Integer, nullable=False, primary_key=True)
    event_type_id = Column(
        Integer, ForeignKey('event_types.id'), nullable=False
    )
    name = Column(String(80), nullable=False)
    description = Column(Text)
    start_datetime = Column(DateTime, nullable=False)
    end_datetime = Column(DateTime, nullable=False)
    url = Column(String(255))
    cost = Column(String(100))
