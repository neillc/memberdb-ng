-- Member_cards
-- ------------

create table member_cards (
        org_id int not null,
        member_id int not null,
        card_id varchar(50),
        start_datetime datetime not null,
        end_datetime datetime,
        CONSTRAINT "member_cards_org_id_fkey" FOREIGN KEY (org_id) references orgs(id) on update restrict,
        CONSTRAINT "member_cards_member_id_fkey" FOREIGN KEY (member_id) references members(id) on update restrict
);

