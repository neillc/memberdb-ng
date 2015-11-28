from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from backend import db


class GroupMembers(db.Model):
    """
        CREATE TABLE group_members
        (
            group_id INT NOT NULL,
            member_id INT NOT NULL,
            start_datetime DATETIME NOT NULL,
            end_datetime DATETIME,
            PRIMARY KEY (group_id, member_id),
            FOREIGN KEY (group_id) REFERENCES groups (id),
            FOREIGN KEY (member_id) REFERENCES members (id)
        );
        CREATE INDEX group_members_member_fkey ON group_members (member_id);
    """

    __tablename__ = 'group_members'

    group_id = Column(
        Integer, ForeignKey('groups.id'), nullable=False, primary_key=True
    )
    member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )

    start_datetime = Column(DateTime, nullable=False)
    end_datetime = Column(DateTime)


class Groups(db.Model):
    """
        CREATE TABLE groups
        (
            id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
            org_id INT,
            group_name VARCHAR(100) NOT NULL,
            description LONGTEXT,
            FOREIGN KEY (org_id) REFERENCES orgs (id)
        );
        CREATE UNIQUE INDEX group_name ON groups (group_name);
        CREATE INDEX group_idx ON groups (group_name);
        CREATE INDEX groups_org_id_fkey ON groups (org_id);
    """

    __tablename__ = 'groups'

    id = Column(Integer, nullable=False, primary_key=True)
    org_id = Column(Integer, ForeignKey('orgs.id'))
    group_name = Column(String(100), nullable=False, unique=True)
    description = Column(Text)
