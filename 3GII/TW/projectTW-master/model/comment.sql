create table if not exists Comment (
	commentId int,
	incidentId int,
	userId int,
	publishDate date,
	hour time,
	email varchar(128),
	text varchar(256),
		primary key (commentId),
		foreign key (incidentId) references Incident(id) on delete cascade,
		foreign key (userId) references User(id) on delete cascade
);

insert into Comment values (
	0,
	1,
	0,
	date("1996-07-16"),
	"12:30:00",
	"frandkv27@gmail.com",
	"Hello my name is Frank"
);

insert into Comment values (
	1,
	1,
	1,
	date("2019-3-22"),
	"16:00:00",
	"frandkv27@gmail.com",
	"Hello my name is Ignacio"
);
