create table if not exists Vote(
	userId int,
	incidentId int,
	positively int,
		primary key(userId, incidentId),
		foreign key (userId) references User(id) on delete cascade,
		foreign key (incidentId) references Incident(id) on delete cascade
);

insert into Vote values (0,0,1), (1,0,1);
