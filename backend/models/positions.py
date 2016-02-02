from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from backend import db


class Positions(db.Model):
    """
    positions table
    ---------------

    """
    __tablename__ = 'positions'

    id = Column(Integer, primary_key=True)
    org_id = Column(Integer, ForeignKey('orgs.id'))
    title = Column(String(50))
    description = Column(Text)


class PositionsHeld(db.Model):
    """
    positions_held table
    """

    __tablename__ = 'positions_held'

    position_id = Column(Integer, ForeignKey('positions.id'), nullable=False,
                         primary_key=True)
    org_id = Column(Integer, ForeignKey('orgs.id'), nullable=False,
                    primary_key=True)
    member_id = Column(Integer, ForeignKey('members.id'), nullable=False,
                       primary_key=True)
    start_datetime = Column(DateTime, nullable=False, primary_key=True)
    end_datetime = Column(DateTime, nullable=False, primary_key=True)

    # org_id int not null,
    # member_id int not null,
    # start_datetime datetime NOT NULL,
    # end_datetime datetime NOT NULL,
    #     CONSTRAINT "positions_held_position_id_fkey"
    #         FOREIGN KEY (position_id) references positions(id) on
    #                 update restrict,
    #     CONSTRAINT "positions_held_org_id_fkey"
    #         FOREIGN KEY (org_id) references orgs(id) on update restrict,
    #     CONSTRAINT "positions_held_member_id_fkey"
    #         FOREIGN KEY (member_id) references members(id) on update restrict
