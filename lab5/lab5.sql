--Zad1
CREATE TABLE obiekty( id INT NOT NULL PRIMARY KEY, name VARCHAR(30) NOT NULL, geom GEOMETRY NOT NULL)

--a
INSERT INTO obiekty VALUES(1, 'obiekt1', ST_Collect(ARRAY[ST_GeomFromText('linestring(0 1, 1 1)'),
														  ST_GeomFromText('circularstring(1 1, 2 0, 3 1)'),
														  ST_GeomFromText('circularstring(3 1, 4 2, 5 1)'),
														  ST_GeomFromText('linestring(5 1, 6 1)')]))

--b
INSERT INTO obiekty VALUES(2, 'obiekt2', ST_Collect(ARRAY[ST_GeomFromText('linestring(10 6, 14 6)'),
														  ST_GeomFromText('circularstring(14 6, 16 4, 14 2)'),
														  ST_GeomFromText('circularstring(14 2, 12 0, 10 2)'),
														  ST_GeomFromText('linestring(10 2, 10 6)'),
														  ST_GeomFromText('circularstring(13 2, 12 1, 11 2)'),
														  ST_GeomFromText('circularstring(11 2, 12 3, 13 2)')]))

--c
INSERT INTO obiekty VALUES(3, 'obiekt3', ST_GeomFromText('polygon((7 15, 10 17, 12 13, 7 15))'))

--d
INSERT INTO obiekty VALUES(4, 'obiekt4', ST_Collect(ARRAY[ST_GeomFromText('linestring(20 20, 25 25)'),
														  ST_GeomFromText('linestring(25 25, 27 24)'),
														  ST_GeomFromText('linestring(27 24, 25 22)'),
														  ST_GeomFromText('linestring(25 22, 26 21)'),
														  ST_GeomFromText('linestring(26 21, 22 19)'),
														  ST_GeomFromText('linestring(22 19, 20.5 19.5)')]))

--e
INSERT INTO obiekty VALUES(5, 'obiekt5', ST_Collect(ARRAY[ST_GeomFromText('point(38 32 234)'),
														  ST_GeomFromText('point(30 30 59)')]))

--f
INSERT INTO obiekty VALUES(6, 'obiekt6', ST_Collect(ARRAY[ST_GeomFromText('point(4 2)'),
														  ST_GeomFromText('linestring(1 1, 3 2)')]))

--Zad2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(o3.geom, o4.geom), 5))
	FROM (SELECT * FROM obiekty WHERE name = 'obiekt3') AS o3,
		 (SELECT * FROM obiekty WHERE name = 'obiekt4') AS o4

--Zad3
UPDATE obiekty
SET geom = ST_GeomFromText('polygon((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))')
WHERE name = 'obiekt4'

--Zad4
INSERT INTO obiekty VALUES(7, 'obiekty7', (SELECT ST_Collect(o3.geom, o4.geom)
										  	FROM (SELECT * FROM obiekty WHERE name = 'obiekt3') AS o3,
		 										 (SELECT * FROM obiekty WHERE name = 'obiekt4') AS o4))

--Zad5
SELECT SUM(ST_Area(ST_Buffer(geom, 5)))
FROM obiekty
WHERE NOT ST_HasArc(geom)
