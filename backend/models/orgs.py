from sqlalchemy import Column, Integer, String, Date, DateTime, CHAR, Text, ForeignKey, PrimaryKeyConstraint
from backend import app

class Organisation_Types(app.Decl_Base):
    """
    org_types table
    ---------------
    
    Lists the type of organisations. This is largely
    up to the site to work out how they want to use this.
    """
    __tablename__ = 'org_types'

    id = Column(Integer, primary_key=True)
    name = Column(String(50))
    description = Text


class Organisation(app.Decl_Base):
    """ 
    orgs table
    ----------
    This table keeps track of all the organizations tracked by
    the system.
     
    Previously this was called 'clubs'
    
    There will usually be a 'primary' org which actually runs the
    whole database.
    
    Members are members of one (or more) organizations.
    
    The idea behind this is that it's possible to track what other
    organizations a member belongs to.
    This is useful for: 
      - in the case of members of an associate organization 
        automatically becoming members of another organization.
      - You offer discounts to members of other orgs to an event
        and want to track their event_signup_status in this DB.
    """
    __tablename__ = 'orgs'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False)
    founded = Column(DateTime)
    closed = Column(DateTime)
    address1 = Column(String(100))
    address2 = Column(String(100))
    suburb = Column(String(50))
    postcod = Column(String(10))
    state = Column(String(50))
    country = Column(String(50), default='Australia')
    website = Column(String(100))
    email = Column(String(100))
    phone = Column(String(50))
    fax = Column(String(50))
    mobile = Column(String(50))
    description = Column(Text)

class OrganisationOrganisationTypes(app.Decl_Base):
    """
    org_org_types
    -------------
    Maps types to orgs
    """
    __tablename__ = 'org_org_types'
    __table_args__ = ((PrimaryKeyConstraint('org_id', 'org_type_id'),))
    org_id = Column(Integer, ForeignKey('orgs.id'))
    org_type_id = Column(Integer, ForeignKey('org_types.id'))
   
class OrganisationRelationTypes(app.Decl_Base):
    """
    -- Organization Relation (Types)
    -- -----------------------------
    -- There are different types of relationships organizations can have with each other
    -- each org has its own set of relations (org_relation_types)
    -- This is useful for:
    --    - Keeping track of associate organizations
    --    - keeping track of parent/child organizations
    """
    __tablename__ = 'org_relation_types'
    
    id = Column(Integer, primary_key = True)
    org_id = Column(Integer, ForeignKey('orgs.id'), nullable=False)
    type = Column(String(50), nullable=False)
    description = Column(Text)
    
class OrganisationRelationships(app.Decl_Base):
    """
    -- and the actual relations are stored here
    -- the lookup on the relation_type should be done on the org_id
    """
    __tablename__ = 'org_relations'
    __table_args__ = ((PrimaryKeyConstraint('org_id','related_to_org_id','org_relation_type_id'),))

    org_id = Column(Integer, ForeignKey('orgs.id'), nullable=False)
    related_to_org_id = Column(Integer, ForeignKey('orgs.id'), nullable=False)
    org_relation_type_id = Column(Integer, ForeignKey('org_relation_types.id'), nullable=False) 
