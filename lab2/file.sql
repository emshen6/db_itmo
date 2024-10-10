create type climate as enum ('Умеренный', 'Арктический');
create type relief as enum ('плоский', 'с_барельефами');

create table region (
    id serial primary key,
    name varchar(32) not null,
    climate climate,
    relief relief
);
create table town (
	id serial primary key,
	name varchar(32) not null,
     villagers integer
);

create table period (
	id serial primary key,
	name varchar(64),
	time varchar(64)
);


create table region_event (
    event_id serial primary key,
    period_id serial,
    region_id serial,
    name varchar(32) not null
);
create table town_event (
    event_id serial primary key,
    period_id serial,
    town_id serial,
    name varchar(32) not null
);
create table location (
    region_id serial,
    town_id serial,
    primary key (region_id, town_id)
);

create table affect_climate (
    region_id serial,
    event_id serial,
    old_climate_state climate,
    new_climate_state climate,
    primary key(region_id, event_id)
);

create table affect_relief (
    region_id serial,
    event_id serial,
    old_relief_state relief,
    new_relief_state relief,
    primary key(region_id, event_id)
);

create table affect_villagers (
    town_id serial,
    event_id serial,
    old_number_of_villagers integer,
    new_number_of_villagers integer,
    primary key(town_id, event_id)
);


insert into region (name, climate, relief) values ('Антарктика', 'Умеренный', 'плоский');
insert into region (name, climate, relief) values ('Арктика', 'Умеренный', 'плоский');
insert into region (name, climate, relief) values ('не полюса', 'Умеренный', 'плоский');

insert into period (name, time) values ('ледниковый период на полюсах', 'более пятисот тысяч лет назад до нашего времени');
insert into period (name, time) values ('ледниковый период', 'пятьсот тысяч лет назад до нашей эры');
insert into period (name, time) values ('задолго до ледникового периода', 'более пятисот тысяч лет назад до нашей эры');
insert into period (name, time) values ('-', 'менее миллиона лет назад');

insert into town (name, villagers) values ('Безымянный', 100);

insert into location (region_id, town_id) values (
(select id from region where name = 'Антарктика'),
(select id from town where name = 'Безымянный'));

insert into region_event (period_id, region_id, name) values 
((select id from period where time='более пятисот тысяч лет назад до нашего времени'),
(select id from region where name='Антарктика'),
'воцарение холодов в Антарктике');

insert into affect_climate (region_id, event_id, old_climate_state, new_climate_state) values 
((select id from region where name='Антарктика'),
(select event_id from region_event where name='воцарение холодов в Антарктике'),
(select climate from region where name='Антарктика'),
'Арктический');

update region set climate = 'Арктический' where name = 'Антарктика';

insert into region_event (period_id, region_id, name) values 
((select id from period where time='более пятисот тысяч лет назад до нашего времени'),
(select id from region where name='Арктика'),
'бич Божий хлестнул по полюсам');

insert into affect_climate (region_id, event_id, old_climate_state, new_climate_state) values 
((select id from region where name='Арктика'),
(select event_id from region_event where name='бич Божий хлестнул по полюсам'),
(select climate from region where name='Арктика'),
'Арктический');

update region set climate ='Арктический' where name = 'Арктика';

insert into region_event (period_id, region_id, name) values 
((select id from period where time='пятьсот тысяч лет назад до нашей эры'),
(select id from region where name='не полюса'),
'начало ледникового периода');

insert into affect_climate (region_id, event_id, old_climate_state, new_climate_state) values 
((select id from region where name='не полюса'),
(select event_id from region_event where name='начало ледникового периода'),
(select climate from region where name='не полюса'),
'Арктический');

update region set climate = 'Арктический' where name = 'не полюса';

insert into region_event (period_id, region_id, name) values 
((select id from period where time='менее миллиона лет назад'),
(select id from region where name='Антарктика'),
'высечены последние барельефы');

insert into affect_relief (region_id, event_id, old_relief_state, new_relief_state) values 
((select id from region where name='Антарктика'),
(select event_id from region_event where name='высечены последние барельефы'),
(select relief from region where name='Антарктика'),
'с_барельефами');

update region set relief ='с_барельефами' where name ='Антарктика';

insert into town_event (period_id, town_id, name) values 
((select id from period where time='более пятисот тысяч лет назад до нашей эры'),
(select id from town where name='Безымянный'),
'город покинут');

insert into affect_villagers (town_id, event_id, old_number_of_villagers, new_number_of_villagers) values 
((select id from town where name='Безымянный'),
(select event_id from town_event where name='город покинут'),
(select villagers from town where name='Безымянный'),
0);

update town set villagers = 0 where name = 'Безымянный';