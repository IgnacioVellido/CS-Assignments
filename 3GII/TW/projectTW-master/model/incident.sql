create table if not exists Incident(
	id int,
	title varchar(128) not null,
	description varchar(512) not null,
	place varchar(128) not null,
	dateIncident date not null,
	hourIncident time not null,
	userId int not null,
	state enum('pending', 'checked', 'processed', 'irresolvable', 'solved'),
		primary key(id),
		foreign key (userId) references User(id) on delete cascade
);

insert into Incident (id, title, description, place, dateIncident, hourIncident, userId, state) values (
	0,
	"Problems with the project",
	"We will encounter problems with out project sometimes",
	"Cloud",
	curdate(),
	now(),
	0,
	"irresolvable"), (
	1,
	"Solutions with the project",
	"Though we will enconter problems with our project, we will solve everyone",
	"Cloud",
	curdate(),
	now(),
	0,
	"solved"), (
	2,
	"Passing TW like a boss",
	"We will take out a ten in the fu subject",
	"Could",
	curdate(),
	now(),
	1,
	"pending"
);
