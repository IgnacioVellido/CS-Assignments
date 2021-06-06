create table if not exists User(
	id int primary key,
	name varchar(64) not null,
	surname varchar(64) not null,
	password varchar(64) not null,
	email varchar(128) not null,
	mailingAddress varchar(256),
	phoneNumber varchar(16) not null,
	kind enum('visitor', 'collaborator', 'manager') not null,
	photo varchar(64)
);

insert into User values (
	0,
	"Francisco Jose",
	"Cotan Lopez",
	"qwert",
	"frandkv27@gmail.com",
	"Carretera de Malaga, 67",
	"123456789",
	"manager",
	"./view/img/generic-profilepic.png"), (
	1,
	"Ignacio",
	"Vellido Esposito",
	"qwert",
	"frandkv27@gmail.com",
	"Far away from the University",
	"987654321",
	"manager",
	"./view/img/profile1.jpg"
);
