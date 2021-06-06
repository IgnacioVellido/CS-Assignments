create table if not exists Keyword(
	incidentId int,
	keyword varchar(64),
		primary key (incidentId, keyword),
		foreign key (incidentId) references Incident(id)
);

insert into Keyword values (0, "Problems"),
	(0, "Some"), (0, "Times"), (1, "Solutions"),
	(1, "Every"), (1, "Time"),
	(2, "Pass"), (2, "TW"), (2, "Boss");
