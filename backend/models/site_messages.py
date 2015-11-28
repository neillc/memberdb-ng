from sqlalchemy import Column, String, Text
from backend import db


class SystemMessages(db.Model):
    """
        CREATE TABLE site_messages
        (
            name VARCHAR(50),
            mail_to LONGTEXT,
            mail_cc LONGTEXT,
            mail_subject LONGTEXT,
            message LONGTEXT
        );
        CREATE INDEX site_messages_name_idx ON site_messages (name);
        """

    __tablename__ = "site_messages"
    name = Column(String(50), nullable=False, primary_key=True)
    mail_to = Column(Text)
    mail_cc = Column(Text)
    mail_subject = Column(Text)
    message = Column(Text)
