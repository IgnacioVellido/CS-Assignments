create table if not exists Reference(
	id int primary key,
	content varchar(64),
	link varchar(64),
		foreign key (id) references Navigation(id)
);

insert into Reference values (0, "Visitor Top", "www.google.es"), (1, "Visitor Aside", "www.google.es"), (2, "Collaborator Top", "www.google.es"), (3, "Collaborator Aside", "www.google.es"),
	(4, "Manager Top", "www.google.es"), (5, "Manager Aside", "www.google.es");
