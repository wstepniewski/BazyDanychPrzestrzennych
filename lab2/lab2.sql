-- Zad2

create database lab2

-- Zad3

create extension postgis

-- Zad4

create table buildings(id int primary key, geometry geometry, name varchar(30))
create table roads(id int primary key, geometry geometry, name varchar(30))
create table poi(id int primary key, geometry geometry, name varchar(30))

-- Zad5

insert into buildings values (1, 'polygon((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
				(2, 'polygon((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
				(3, 'polygon((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
				(4, 'polygon((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
				(5, 'polygon((1 2, 2 2, 2 1, 1 1, 1 2))', 'BuildingF')

insert into roads values (1, 'linestring(0 4.5, 12 4.5)','RoadX'),
				(2, 'linestring(7.5 10.5, 7.5 0)', 'RoadY')

insert into poi values (1, 'point(1 3.5)', 'G'),
						(2, 'point(5.5 1.5)', 'H'),
						(3, 'point(9.5 6)', 'I'),
						(4, 'point(6.5 6)', 'J'),
						(5, 'point(6 9.5)', 'K')


-- Zad6
-- a
select sum(st_length(geometry)) from roads

-- b
select geometry, st_area(geometry), st_perimeter(geometry)
	from buildings where name='BuildingA'

-- c
select name, st_area(geometry) from buildings order by name

-- d
select name, st_perimeter(geometry) from buildings order by st_area(geometry) desc limit 2

-- e
select st_distance(buildings.geometry, poi.geometry)
	from buildings, poi
	where buildings.name='BuildingC'
	and poi.name='K'

-- f
with bb as (select * from buildings where name='BuildingB'),
	bc as (select * from buildings where name='BuildingC')

select st_area(bc.geometry)-st_area(st_intersection(bc.geometry, st_buffer(bb.geometry, 0.5))) from bb, bc

--g
select buildings.name from buildings, roads where roads.name='RoadX'
	and st_y(st_centroid(buildings.geometry)) > st_y(st_centroid(roads.geometry))

-- Zad8
select st_area(geometry)-st_area(st_intersection(geometry, st_geomfromtext('polygon((4 7, 6 7, 6 8, 4 8, 4 7))')))
	from buildings where name='BuildingC'

