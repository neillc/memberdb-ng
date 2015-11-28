from sqlalchemy import Column, Integer, String, DateTime, Text
from backend import db


class Log(db.Model):
    """
        # -- log
        # -- ---
        # -- Keeps track of activities in the system
        # -- It is safe to delete records from this table at any time.
        # -- it is used instead of a syslog facility to avoid the icky problems of
        # -- having multiple threads/processes accessing the log file at once.
        # -- This way we just leave it up to a database issue :)
        # --
        # -- Priorities are (from UNIX syslog):
        # -- LOG_EMERG system is unusable
        # -- LOG_ALERT action must be taken immediately
        # -- LOG_CRIT critical conditions
        # -- LOG_ERR error conditions
        # -- LOG_WARNING warning conditions
        # -- LOG_NOTICE normal, but significant, condition
        # -- LOG_INFO informational message
        # -- LOG_DEBUG debug-level message
        # --
        # -- Is MyISAM - want to have logs after ROLLBACK and speed.
        # -- in future, probably ARCHIVE with partitioning.
        """

    __tablename__ = "log"
    logtime = Column(DateTime, primary_key=True, nullable=False)
    priority = Column(Integer, primary_key=True, )
    username = Column(String(50), primary_key=True, )
    entry = Column(Text, nullable=False, primary_key=True)
