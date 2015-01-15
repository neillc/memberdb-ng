-- event_types table
-- -----------------
-- there are many types of events
create table event_types (
        id integer auto_increment not null,
        type varchar(50),
        CONSTRAINT "event_types_pkey" PRIMARY KEY (id)
);


-- events table
-- ------------
-- events are stored in the system independantly of orgs
-- events have host orgs, listed in the event_host_orgs table
-- this is how we work out who is hosting an event/running it.
--
-- we also track organisers of events and a few other little
-- useful bits of information. Most info should be on the event
-- page though.
create table events (
        id integer auto_increment not null,
        event_type_id integer not null,
        name varchar(80) not null,
        description text,
        start_datetime datetime NOT NULL,
        end_datetime datetime NOT NULL,
        url varchar(255) default NULL,
        cost varchar(100),
        CONSTRAINT "events_pkey" PRIMARY KEY (id),
        CONSTRAINT "events_event_type_id_fkey" FOREIGN KEY (event_type_id) references event_types(id) on update restrict
);


create table event_host_orgs (
        event_id int not null,
        org_id int not null,
        rank int,
        CONSTRAINT "event_host_orgs_pkey" PRIMARY KEY (event_id,org_id),
        CONSTRAINT "event_host_orgs_event_id_fkey" FOREIGN KEY (event_id) references events(id) on update restrict,
        CONSTRAINT "event_host_orgs_org_id_fkey" FOREIGN KEY (org_id) references orgs(id) on update restrict
);

create table event_organisers (
        event_id int not null,
        member_id int not null,
        role varchar(50),
        CONSTRAINT "event_organisers_event_id_fkey" FOREIGN KEY (event_id) references events(id) on update restrict,
        CONSTRAINT "event_organisers_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict
);

create table event_signup_status (
        id integer auto_increment not null,
        event_id int default NULL,
        status varchar(50) not null default '',
        CONSTRAINT "event_signup_status_pkey" PRIMARY KEY (id)
);

create table event_signup (
        event_id int not null,
        member_id int not null,
        event_signup_status_id int not null,
        ticket int default NULL,
        CONSTRAINT "event_signup_event_id_fkey" FOREIGN KEY (event_id) references events(id) on update restrict,
        CONSTRAINT "event_signup_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict,
        CONSTRAINT "event_signup_event_signup_status_id_fkey" FOREIGN KEY (event_signup_status_id) references event_signup_status(id) on update restrict
);
