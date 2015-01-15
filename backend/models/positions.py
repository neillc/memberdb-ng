create table positions (
        id integer auto_increment not null,
        org_id int default NULL,
        title varchar(50),
        description text,
        CONSTRAINT "positions_pkey" PRIMARY KEY (id),
        CONSTRAINT "positions_org_id_fkey" FOREIGN KEY (org_id) references orgs(id) on update restrict
);

create table positions_held (
        position_id int not null,
        org_id int not null,
        member_id int not null,
        start_datetime datetime NOT NULL,
        end_datetime datetime NOT NULL,
        CONSTRAINT "positions_held_position_id_fkey" FOREIGN KEY (position_id) references positions(id) on update restrict,
        CONSTRAINT "positions_held_org_id_fkey" FOREIGN KEY (org_id) references orgs(id) on update restrict,
        CONSTRAINT "positions_held_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict
);
