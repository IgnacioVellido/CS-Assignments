create table if not exists Navigation(
	id int primary key,
	typeUser enum('visitor', 'collaborator', 'manager') not null,
	kind enum('top', 'aside') not null
);

insert into Navigation values (0, 'visitor', 'top'), (1, 'visitor', 'aside'),
	(2, 'collaborator', 'top'), (3, 'collaborator', 'aside'),
	(4, 'manager', 'top'), (5, 'manager', 'aside');
