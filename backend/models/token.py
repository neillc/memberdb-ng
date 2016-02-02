from sqlalchemy import Column, String, Integer
from backend import db


class Token(db.Model):
    """
        CREATE TABLE token
        (
            token VARCHAR(50) DEFAULT '' NOT NULL,
            member_id INT DEFAULT 0 NOT NULL,
            task VARCHAR(50) DEFAULT '' NOT NULL,
            expires INT,
            PRIMARY KEY (token, member_id, task)
        );
        """

    __tablename__ = "token"
    token = Column(String(50), nullable=False, primary_key=True)
    member_id = Column(Integer, nullable=False, primary_key=True)
    task = Column(String(50), nullable=False, primary_key=True)
    expires = Column(Integer)
