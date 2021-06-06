create table if not exists Images(
	id int,
	incidentId int,
	path varchar(128),
	description varchar(128),
		primary key(id),
		foreign key (incidentId) references Incident(id)
);

insert into Images values (0, 0, "./view/img/incident-1.jpg", "Fotografia"),
	(1, 0, "./view/img/incident-2.jpg", "Fotografia"),
	(2, 0, "./view/img/incident-3.jpg", "Fotografia"),
	(3, 1, "./view/img/incident-1.jpg", "Fotografia"),
	(4, 1, "./view/img/incident-2.jpg", "Fotografia"),
	(5, 1, "./view/img/incident-3.jpg", "Fotografia");
