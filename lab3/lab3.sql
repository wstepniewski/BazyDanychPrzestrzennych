-- zad1
-- komendy wykonywane z cmd
-- shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2018_KAR_GERMANY/T2018_KAR_BUILDINGS.shp t2018_kar_buildings | psql -U postgres -h localhost -p 5432 -d lab3
-- shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2019_KAR_GERMANY/T2019_KAR_BUILDINGS.shp t2019_kar_buildings | psql -U postgres -h localhost -p 5432 -d lab3
select b19.gid, b19.polygon_id, b19.name from t2019_kar_buildings as b19
left join t2018_kar_buildings as b18
on b18.geom = b19.geom
where b18.gid is null

--zad2
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2018_KAR_GERMANY/T2018_KAR_POI_TABLE.shp t2018_kar_poi_table | psql -U postgres -h localhost -p 5432 -d lab3
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2018_KAR_GERMANY/T2019_KAR_POI_TABLE.shp t2019_kar_poi_table | psql -U postgres -h localhost -p 5432 -d lab3

with new_buildings as (
	select b19.gid, b19.polygon_id, b19.name, b19.geom from t2019_kar_buildings as b19
	left join t2018_kar_buildings as b18
	on b18.geom = b19.geom
	where b18.gid is null
),

new_points as (
	select p19.gid, p19.type, p19.poi_name, p19.geom from t2019_kar_poi_table as p19
	left join t2018_kar_poi_table as p18
	on p19.geom = p18.geom
	where p18.gid is null
)

select count(*), np.type
	from new_points as np
	join new_buildings as nb
	on st_distance(np.geom, nb.geom) < 500
	group by np.type

--zad3
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2019_KAR_GERMANY/T2019_KAR_STREETS.shp t2019_kar_streets | psql -U postgres -h localhost -p 5432 -d lab3

create table streets_reprojected (
	gid int primary key,
	link_id double precision,
	st_name varchar(254),
	ref_in_id double precision,
	nref_in_id double precision,
	func_class varchar(1),
	speed_cat varchar(1),
	fr_speed_l double precision,
	to_stted_l double precision,
	dir_travel varchar(1),
	geom geometry
)

insert into streets_reprojected
	select gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, ST_Transform(ST_SetSRID(geom, 4326), 3068)
	from t2019_kar_streets

--zad4
create table input_points(
	id int primary key,
	geom geometry
)

insert into input_points values
	(1, 'point(8.36093 49.03174)'),
	(2, 'point(8.39876 49.00644)')

--zad5
update input_points
	set geom = ST_Transform(ST_SetSRID(geom, 4326), 3068)

--zad6
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2019_KAR_GERMANY/T2019_KAR_STREET_NODE.shp t2019_street_node | psql -U postgres -h localhost -p 5432 -d lab3

update t2019_street_node
	set geom = ST_Transform(ST_SetSRID(geom, 4326), 3068)

with l as (select st_makeline(input_points.geom) as line from input_points)

select *, st_distance(l.line, sn.geom) from t2019_street_node as sn
	join l on st_distance(l.line, sn.geom) < 200

--zad7
select count(distinct kpt.gid) from t2019_land_use_A as lu
	join t2019_kar_poi_table as kpt
	on st_distance(lu.geom, kpt.geom) < 300
	where kpt.type = 'Sporting Goods Store'

--zad8
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2019_KAR_GERMANY/T2019_KAR_RAILWAYS.shp t2019_railways | psql -U postgres -h localhost -p 5432 -d lab3
--shp2pgsql -D -I D:/Semestr_7/BazyDanychPrzestrzennych/lab3/Cw3_Karlsruhe_Germany_Shapefile/T2019_KAR_GERMANY/T2019_KAR_WATER_LINES.shp t2019_water_lines | psql -U postgres -h localhost -p 5432 -d lab3

select distinct st_intersection(r.geom, wl.geom) as geom
	into t2019_kar_bridges
	from t2019_railways as r, t2019_water_lines as wl
