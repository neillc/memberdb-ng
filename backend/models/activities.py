from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship
from backend import db


class Activities(db.Model):
    """"
    # CREATE TABLE activities
    # (
    #     id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    #     activity VARCHAR(100) NOT NULL,
    #     description LONGTEXT
    # );
    # CREATE UNIQUE INDEX activity ON activities (activity);
    # CREATE INDEX activity_idx ON activities (activity);
    """

    __tablename__ = 'activities'

    id = Column(Integer, nullable=False, primary_key=True)
    activity = Column(String(100), nullable=False, unique=True)
    description = Column(Text)

    activities = relationship('Permissions', backref='activity')

