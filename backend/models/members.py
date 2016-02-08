from sqlalchemy import Column, Integer, String, Date, DateTime, CHAR, \
    PrimaryKeyConstraint, ForeignKey, Text
from sqlalchemy.orm import relationship
from backend import db


class Members(db.Model):
    __tablename__ = 'members'

    id = Column(Integer, primary_key=True)
    date_entered = Column(DateTime)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    last_name = Column(String(50))
    DOB = Column(Date)
    sex = Column(CHAR(1))
    address1 = Column(String(50))
    address2 = Column(String(50))
    suburb = Column(String(50))
    postcode = Column(String(10))
    state = Column(String(50))
    country = Column(String(20))
    email = Column(String(50))
    phone_home = Column(String(25))
    phone_mobile = Column(String(25))

    organisations = relationship('OrgMembers')
    passwd = relationship('Passwd', backref='member')

    def display_name(self):
        return "{first} {last}".format(
                first=self.first_name,
                last=self.last_name
        )

    def __repr__(self):
        return "{first_name} {last_name}".format(
            first_name=self.first_name, last_name=self.last_name
        )


class MembersOldDetails(db.Model):
    __tablename__ = 'members_old_details'
    __table_args__ = (PrimaryKeyConstraint('id', 'date_entered'),)
    """
    -- members_old_details
    -- -------------------
    --
    -- Idea behind this is that when updating members, we insert the
    -- old values into members_old_details before updating members.
    --
    -- If this gets large, we could convert the table type to MyISAM or
    -- even archive. We're not (yet) going to be doing any queries on it.
    -- It's more of a 'useful for archival purposes'
    """

    id = Column(Integer, ForeignKey('members.id'))
    date_entered = Column(DateTime)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    last_name = Column(String(50))
    DOB = Column(Date)
    sex = Column(CHAR(1))
    address1 = Column(String(50))
    address2 = Column(String(50))
    suburb = Column(String(50))
    postcode = Column(String(10))
    state = Column(String(50))
    country = Column(String(20))
    email = Column(String(50))
    phone_home = Column(String(25))
    phone_mobile = Column(String(25))


class MemberQualifications(db.Model):
    __tablename__ = 'member_qualifications'

    def __repr__(self):
        return "{name}({id}: {description}".format(
            id=self.id,
            name=self.name,
            description=self.description
        )

    member_id = Column(Integer, ForeignKey('members.id'), nullable=False,
                       primary_key=True)
    qualification_id = Column(Integer, ForeignKey('qualifications.id'),
                              nullable=False, primary_key=True)
    detail = Column(String(250), nullable=False)


class OrgMembers(db.Model):
    __tablename__ = 'org_members'
    member_id = db.Column(db.Integer, db.ForeignKey('members.id'),
                          nullable=False, primary_key=True)
    org_id = Column(db.Integer, db.ForeignKey('orgs.id'),
                    nullable=False, primary_key=True)
    member_type_id = db.Column(db.Integer, db.ForeignKey('member_types.id'),
                               nullable=False, primary_key=True)
    start_date = db.Column(db.DateTime, nullable=False, primary_key=True)
    expiry = db.Column(db.DateTime)

    def __repr__(self):
        return "Member:{member} Org:{org_id} Type:{type_id}".format(
            member=self.member_id,
            org_id=self.org_id,
            type_id=self.member_type_id
        )


class MemberTypes(db.Model):
    """
        CREATE TABLE member_types
        (
            id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
            org_id INT NOT NULL,
            type VARCHAR(50) NOT NULL,
            validates_membership TINYINT NOT NULL,
            revokes_membership TINYINT NOT NULL,
            description LONGTEXT,
            FOREIGN KEY (org_id) REFERENCES orgs (id)
        );
        CREATE INDEX member_types_org_id_fkey ON member_types (org_id);
        CREATE INDEX member_types_type_idx ON member_types (type);
    """

    __tablename__ = 'member_types'

    id = Column(Integer, nullable=False, primary_key=True)
    org_id = Column(Integer, db.ForeignKey('orgs.id'), nullable=False)
    type = Column(String(50), nullable=False)
    validates_membership = Column(Integer, nullable=False)
    revokes_membership = Column(Integer, nullable=False)
    description = Column(Text)

    members = relationship('OrgMembers', backref='member_type')

    def __repr__(self):
        tpl = "MemberType:{id} Org:{org_id} Type:{type} Desc:{description}"
        return tpl.format(
            id=self.id,
            org_id=self.org_id,
            type=self.type,
            description=self.description
        )



class Passwd(db.Model):
    """
        CREATE TABLE passwd
        (
            member_id INT PRIMARY KEY NOT NULL,
            salt VARCHAR(10),
            password CHAR(33) NOT NULL,
            FOREIGN KEY (member_id) REFERENCES members (id)
        );
    """

    __tablename__ = 'passwd'

    member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )
    salt = Column(String(10))
    password = Column(String(33), nullable=False)

    def __repr__(self):
        return "{salt}:{passwd}".format(salt=self.salt, passwd=self.password)


class Permissions(db.Model):
    """
    CREATE TABLE permissions
    (
        member_id INT,
        group_id INT,
        org_id INT,
        activity_id INT NOT NULL,
        can_do TINYINT,
        can_grant TINYINT,
        start_datetime DATETIME NOT NULL,
        end_datetime DATETIME,
        FOREIGN KEY (activity_id) REFERENCES activities (id),
        FOREIGN KEY (group_id) REFERENCES groups (id),
        FOREIGN KEY (member_id) REFERENCES members (id),
        FOREIGN KEY (org_id) REFERENCES orgs (id)
    );
    CREATE INDEX member_permissions_activity_id_fkey
        ON permissions (activity_id);
    CREATE INDEX member_permissions_group_id_fkey ON permissions (group_id);
    CREATE INDEX member_permissions_member_id_fkey ON permissions (member_id);
    CREATE INDEX member_permissions_org_id_fkey ON permissions (org_id);
    """

    __tablename__ = 'permissions'

    member_id = Column(Integer, ForeignKey('members.id'), primary_key=True)
    group_id = Column(Integer, ForeignKey('groups.id'), primary_key=True)
    org_id = Column(Integer, ForeignKey('orgs.id'), primary_key=True)
    activity_id = Column(
        Integer, ForeignKey('activities.id'), nullable=False, primary_key=True
    )
    can_do = Column(Integer)
    can_grant = Column(Integer)
    start_datetime = Column(DateTime, nullable=False, primary_key=True)
    end_datetime = Column(DateTime, primary_key=True)

    members = relationship('Members', backref='permissions')

