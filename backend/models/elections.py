from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey, UniqueConstraint
from backend import db


class Election(db.Model):
    """
        # CREATE TABLE election
        # (
        #     id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
        #     org_id INT NOT NULL,
        #     name VARCHAR(50) NOT NULL,
        #     start_advertising DATETIME,
        #     nominations_start DATETIME NOT NULL,
        #     nominations_close DATETIME NOT NULL,
        #     num_req_nominations INT DEFAULT 0 NOT NULL,
        #     advertise_candidates DATETIME NOT NULL,
        #     live_results TINYINT,
        #     start_voting DATETIME NOT NULL,
        #     close_voting DATETIME NOT NULL,
        #     show_results DATETIME NOT NULL,
        #     description LONGTEXT,
        #     FOREIGN KEY (org_id) REFERENCES orgs (id)
        # );
        # CREATE INDEX election_org_id_fkey ON election (org_id);
    """

    __tablename__ = 'election'

    id = Column(Integer, primary_key=True, nullable=False)
    org_id = Column(Integer, ForeignKey('orgs.id'), nullable=False)
    name = Column(String(50), nullable=False)
    start_advertising = Column(DateTime)
    nominations_start = Column(DateTime, nullable=False)
    nominations_close = Column(DateTime, nullable=False)
    num_req_nominations = Column(Integer, nullable=False, default=0)
    advertise_candidates = Column(DateTime, nullable=False)
    live_results = Column(Integer)
    start_voting = Column(DateTime, nullable=False)
    close_voting = Column(DateTime, nullable=False)
    show_results = Column(DateTime, nullable=False)
    description = Column(Text)


class ElectionCandidate(db.Model):
    """
        CREATE TABLE election_candidate
        (
            id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
            election_position_id INT NOT NULL,
            member_id INT NOT NULL,
            spiel LONGTEXT,
            FOREIGN KEY (election_position_id) REFERENCES election_position (id),
            FOREIGN KEY (member_id) REFERENCES members (id)
        );
        CREATE UNIQUE INDEX election_candidate_pkey ON election_candidate (election_position_id, member_id);
        CREATE INDEX election_candidate_member_id ON election_candidate (member_id);
    """

    __tablename__ = 'election_candidate'
    id = Column(Integer, nullable=False, primary_key=True)
    election_position_id = Column(
        Integer, ForeignKey('election_position.id'), nullable=False
    )
    member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False
    )
    spiel = Column(Text)

    UniqueConstraint(election_position_id, member_id)


class ElectionCandidateNomination(db.Model):
    """
        CREATE TABLE election_candidate_nomination
        (
            when_nominated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
            election_position_id INT NOT NULL,
            from_member_id INT NOT NULL,
            for_member_id INT NOT NULL,
            reason LONGTEXT,
            PRIMARY KEY (election_position_id, from_member_id, for_member_id),
            FOREIGN KEY (election_position_id) REFERENCES election_position (id),
            FOREIGN KEY (for_member_id) REFERENCES members (id),
            FOREIGN KEY (from_member_id) REFERENCES members (id)
        );
        CREATE INDEX nomination_for_member_id_fkey ON election_candidate_nomination (for_member_id);
        CREATE INDEX nomination_from_member_id_fkey ON election_candidate_nomination (from_member_id);
    """
    __tablename__ = 'election_candidate_nomination'
    when_nominated = Column(DateTime, nullable=False)
    election_position_id = Column(
        Integer, ForeignKey('election_position.id'), nullable=False,
        primary_key=True
    )
    from_member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )
    for_member_id = Column(
        Integer, ForeignKey('members.id'), nullable=False, primary_key=True
    )
    reason = Column(Text)


class ElectionPosition(db.Model):
    """
        CREATE TABLE election_position
        (
            id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
            election_id INT NOT NULL,
            name VARCHAR(50) NOT NULL,
            num INT DEFAULT 1 NOT NULL,
            description LONGTEXT,
            FOREIGN KEY (election_id) REFERENCES election (id)
        );
        CREATE INDEX election_position_election_id_fkey ON election_position (election_id);
    """
    __tablename__ = 'election_position'
    id = Column(Integer, nullable=False, primary_key=True)
    election_id = Column(Integer, ForeignKey('election.id'), nullable=False)
    name = Column(String(50), nullable=False)
    num = Column(Integer, default=1, nullable=False)
    description = Column(Text)


class ElectionVote(db.Model):
    """
        CREATE TABLE election_vote
        (
            member_id INT NOT NULL,
            candidate_id INT NOT NULL,
            preference INT NOT NULL,
            PRIMARY KEY (member_id, candidate_id),
            FOREIGN KEY (candidate_id) REFERENCES election_candidate (id),
            FOREIGN KEY (member_id) REFERENCES members (id)
        );
        CREATE UNIQUE INDEX election_vote_uniq ON election_vote (member_id, candidate_id, preference);
        CREATE INDEX election_vote_candidate_id_fkey ON election_vote (candidate_id);
    """
    __tablename__ = 'election_vote'
    member_id = Column(Integer, ForeignKey('members.id'), nullable=False, primary_key=True)
    candidate_id = Column(Integer, ForeignKey('election_candidate.id'), nullable=False, primary_key=True)
    preference = Column(Integer, nullable=False, primary_key=True)
