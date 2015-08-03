from sqlalchemy import Column, Integer, String, Date, DateTime, CHAR, PrimaryKeyConstraint, ForeignKey
from backend import app

Mapped_Members = app.base.classes.members

class Members(app.Decl_Base):
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


class MembersOldDetails(app.Decl_Base):
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

"""create table member_qualifications (
            member_id       integer,
            qualification_id integer,
            detail          varchar(250),
            CONSTRAINT "member_qual_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict,
            CONSTRAINT "member_qual_id_fkey" FOREIGN KEY (qualification_id) references qualifications(id) on update restrict
    );

create table member_qualifications (
        member_id       integer,
        qualification_id integer,
        detail          varchar(250),
        CONSTRAINT "member_qual_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict,
        CONSTRAINT "member_qual_id_fkey" FOREIGN KEY (qualification_id) references qualifications(id) on update restrict
);

create table member_qualifications (
        member_id       integer,
        qualification_id integer,
        detail          varchar(250),
        CONSTRAINT "member_qual_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict,
        CONSTRAINT "member_qual_id_fkey" FOREIGN KEY (qualification_id) references qualifications(id) on update restrict
);


-- org_members table
-- -----------------
-- keeps track of what members belong to what organization
-- what their membership type is, when they started being a member
-- and when their membership expires.
--
-- When someone changes membership status (e.g. from pending to full)
-- then they should get a new entry in the org_members table.
-- I am not sure if the expiry for the old membership should change...
-- 
create table org_members (
        member_id int not null,
        org_id int not null,
        member_type_id int not null,
        start_date datetime not null,
        expiry datetime,
        CONSTRAINT "org_members_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update RESTRICT,
        CONSTRAINT "org_members__id_fkey" FOREIGN KEY (org_id) references orgs(id) on update RESTRICT,
        CONSTRAINT "org_members_member_type_id_fkey" FOREIGN KEY (member_type_id) references member_types(id) on update RESTRICT        
);
"""

