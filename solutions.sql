-- 1
select model, speed, hd from PC  where pc.price < 500;
-- 2 
select distinct maker from product p1 where type = 'printer';
-- 3
Select model, ram, screen from laptop where price > 1000;
-- 4 
Select * from printer where color = 'y';
-- 5
Select model, speed, hd from pc where price < 600 and cd in ('12x', '24x');
-- 6
select distinct p.maker, l.speed from product p inner join laptop l on p.model = l.model where l.hd >= 10;

-- 7 

select p.model, l.price from product p  join laptop l on p.model = l.model where p.maker = 'B'
union
select p.model, pr.price from product p  join printer pr on p.model = pr.model where p.maker = 'B'
union
select p.model, pc.price from product p  join pc on p.model = pc.model where p.maker = 'B'

-- 8 
select distinct maker from product where type = 'PC' and maker not in (select maker from product where type = 'laptop');

-- 9
select distinct maker from product p join pc on p.model = pc.model where speed >= 450;

-- 10
select model, price from printer  where price in ( select max(price) from printer);

-- 11
select avg(speed) as avarage_pc_speed from pc;

-- 12
select avg(speed) as avg_speed from laptop where price > 1000;

-- 13
select avg(speed) as avg_speed from pc join product p on p.model = pc.model where maker = 'A';

-- 14

select c.class, name, country
from classes c
join ships s
on c.class = s.class
where numguns >= 10;

-- 15
select hd from pc group by hd having count(model) >= 2;

-- 16 -- self join

select distinct p1.model,
  p2.model,
  p1.speed,
  p1.ram
from pc p1, pc p2
where p1.speed = p2.speed AND p1.ram = p2.ram AND p1.model > p2.model;

-- 17

select distinct p.type, l.model, l.speed
from product p
join laptop l
  on p.model = l.model
where speed < ALL (select speed from pc);

-- 18

select maker, price 
from product pr join Printer p on pr.model = p.model and color = 'y'
where price = (select min(price) from printer where color='y');

-- 19
select maker, avg(screen) as avg_screen
from product p
join laptop l on p.model = l.model
group by maker;

-- 20
select maker, count(distinct model) as model_count from Product where [type] = 'pc' group by maker having count(distinct model) >= 3;

-- 21
select maker, max(price) as Max_price
from pc 
join product p on pc.model= p.model
where type = 'pc'
group by maker;

-- 22

Select speed, avg(price) as avg_price
from pc 
group by speed
having speed > 600;

-- 23 -- use intersect not union

Select distinct maker 
from product p
join pc on p.model = pc.model
where speed >= 750 
intersect
select distinct maker from product p join laptop l on p.model = l.model
where speed >= 750;

-- 24
with cte as (select distinct pc.model, price from  pc 
  union select distinct l.model, price from laptop l
  union select distinct pr.model, price from printer pr) 

select model from cte 
where price in (select max(price) from cte);

-- 25 --added to git 
select distinct maker from product p
join pc on p.model = pc.model
where ram in (select min(ram) from pc)
   and speed in (select max(speed) from pc where ram = (select min(ram) from pc)) 
        and maker in (select maker from product where type= 'printer');

-- 26
with cte as (
  select price from pc 
  join Product p on p.model = pc.model
  where maker = 'A'

  union all

  select price from Laptop l
  join Product p on p.model = l.model
  where maker = 'A'

)
select CEILING(AVG(price)) as AVG
from cte;


-- 27 
select maker, avg(hd) as avg_hd
from product p join pc
on p.model = pc.model
group by maker
having maker in (select maker from product where type= 'printer');


-- 28
SELECT COUNT(maker) as tot
FROM (SELECT maker, 
             COUNT(model) AS ct
      FROM product
      GROUP BY maker) a
WHERE ct = 1;


-- 29
select distinct i.point, i.date, inc, out
from Income_o i 
left join Outcome_o ot on i.point = ot.point and i.date = ot.date
union 
select distinct ot.point, ot.date, inc, out
from Outcome_o ot
left join Income_o i on ot.point = i.point and ot.date = i.date;


-- 30

-- 31
select class, country
from classes
where bore >= 16;

-- 32

-- 33
SELECT ship
FROM outcomes
WHERE battle = 'North Atlantic'
  AND result = 'sunk';

--34

Select distinct name
from ships s
join classes c
on c.class = s.class
where launched is not null 
  AND launched >= 1922
  AND displacement >35000
  AND type = 'bb' ; -- battle ships only


-- 35
select model, type
from Product
where model not like '%[^0-9]%' or model not like '%[^a-z]%' or model not like '%[^A-Z]%';

-- 36
select distinct name
FROM (select name
      from ships
      where name=class
      union
      select ship AS name
      from outcomes
      where ship in (select class from classes)
      ) a;

-- 37
with num_ship as (
  select c.class, s.name
  from Classes c join Ships s 
  on c.class = s.class

  union
  select c.class , ot.ship as name
  from Classes  c join Outcomes ot 
  on c.class = ot.ship

)
select class 
from num_ship 
group by class 
having COUNT(class) = 1;


-- 38 
select distinct country 
from Classes
where [type] = 'bb'
and country in (
  select distinct country
  from Classes
  where type = 'bc'
);

-- 39

select distinct a.ship
from ( SELECT ship,
             result,
             date
      FROM outcomes
      JOIN battles
        ON outcomes.battle=battles.name
      WHERE result = 'damaged') a

join (SELECT ship, 
             result, 
             date
      FROM outcomes
      JOIN battles
        ON outcomes.battle=battles.name) b
ON a.ship=b.ship
AND b.date>a.date;

-- 40
select distinct p.maker, p.type
from Product p 
JOIN (select maker 
      from Product
      group by maker
      having count(distinct type) = 1
      and count(distinct model)>1) a 
on a.maker = p.maker;

-- 41
SELECT maker,
  CASE 
    WHEN sum(CASE 
                WHEN price IS NULL THEN 1 
                ELSE 0 
             END) > 0 THEN NULL
    ELSE max(price) 
  END AS price
FROM (SELECT maker, 
             price
      FROM product
      JOIN pc
        ON product.model = pc.model
      UNION ALL
      SELECT maker, 
             price
      FROM product
      JOIN laptop
        ON product.model = laptop.model 
      UNION ALL
      SELECT maker, 
             price
      FROM product
      JOIN printer
        ON product.model = printer.model
      ) a 
GROUP BY maker;

-- 42
SELECT ship, battle
FROM outcomes
WHERE result = 'sunk';

--43
SELECT name
FROM battles
WHERE DATEPART(year,CAST(date AS date)) 
    NOT IN (SELECT launched FROM ships WHERE launched IS NOT NULL);

-- 44
SELECT DISTINCT name
FROM (SELECT ship AS name
      FROM outcomes
      UNION
      SELECT name
      FROM ships) ship_names
WHERE name LIKE 'R%';

-- 45
SELECT DISTINCT name
FROM (SELECT ship AS name
      FROM outcomes
      UNION
      SELECT name
      FROM ships) ship_names
WHERE name LIKE '% % %';

-- 46
SELECT DISTINCT ship, 
       displacement, 
       numGuns
FROM classes c
LEFT JOIN ships s
  ON c.class = s.class
RIGHT JOIN outcomes o 
  ON c.class = o.ship
  OR s.name = o.ship
WHERE battle = 'Guadalcanal';

-- 48

SELECT DISTINCT Classes.class
FROM Classes, Ships, Outcomes
WHERE Classes.class = Ships.class
AND Ships.name = Outcomes.ship
AND Outcomes.result = 'sunk'
UNION
SELECT DISTINCT class
FROM Classes, Outcomes
WHERE Classes.class = Outcomes.ship
AND Outcomes.result = 'sunk'

-- 49
SELECT name as Ship_names
FROM (SELECT s.name AS name, 
             c.bore
      FROM ships s
      JOIN classes c
        ON s.class = c.class
      UNION
      SELECT o.ship AS name, 
             c.bore
      FROM outcomes o
      JOIN classes c
        ON c.class = o.ship
      ) a
WHERE a.bore = '16';

-- 50
SELECT battle 
FROM Outcomes, Ships
WHERE Outcomes.ship = Ships.name
AND Ships.class = 'Kongo';

-- 52
SELECT name 
FROM Ships, Classes
WHERE Ships.class = Classes.class 
AND (country = 'Japan' OR country IS NULL) 
AND (numGuns >= 9 OR numGuns IS NULL)     
AND (bore < 19 OR bore IS NULL) 
AND (displacement <= 65000 OR displacement IS NULL) 
AND (TYPE = 'bb' OR TYPE IS NULL);

-- 53

WITH avg_guns AS (SELECT name AS ship, 
                  numGuns
           FROM classes c
           JOIN ships s
            ON s.class = c.class
           WHERE c.type = 'bb'
           UNION
           SELECT ship AS ship, 
                  numGuns
           FROM outcomes o
           JOIN classes c
           ON o.ship = c.class
           WHERE c.type = 'bb')

SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(6,2)) AS AVG_GUNS
FROM avg_guns;

-- 54 

WITH a AS (SELECT name AS ship, 
                  numGuns
           FROM classes c
           JOIN ships s
            ON s.class = c.class
           WHERE c.type = 'bb'
           UNION
           SELECT ship AS ship, 
                  numGuns
           FROM outcomes o
           JOIN classes c
           ON o.ship = c.class
           WHERE c.type = 'bb')

SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(6,2)) as avg_guns_per_battleship
FROM a;

-- 55

SELECT c.class, 
CASE when s.launched IS NULL THEN (
	SELECT MIN(launched) 
	FROM Ships AS s 
	WHERE s.class = c.class
) 
ELSE s.launched END
FROM Classes AS c
LEFT JOIN Ships AS s
ON c.class = s.name;

-- 56
SELECT class, sum(sunks) AS sunks 
FROM (
	SELECT class, sum(CASE result when 'sunk' THEN 1 ELSE 0 END) AS sunks 
	FROM Classes c LEFT JOIN Outcomes o 
	ON c.class = o.ship
	WHERE class NOT IN (SELECT name FROM Ships) 
	GROUP BY class
	UNION ALL
	SELECT class, sum(CASE result when 'sunk' THEN 1 ELSE 0 END) AS sunks
	FROM Ships s LEFT JOIN Outcomes o 
	ON s.name = o.ship
	GROUP BY class
) AS cnt
GROUP BY class;

-- 59 

SELECT ss.point,(COALESCE (ss.inc, 0) - COALESCE (dd.out, 0)) as Cash_balance
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
	GROUP BY point
) AS ss
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
	GROUP BY point
 ) AS dd
 ON ss.point = dd.point;

 --60
 SELECT ss.point,(COALESCE (ss.inc, 0) - COALESCE (dd.out, 0))
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
        WHERE '20010415' > date
	GROUP BY point
) AS ss
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
        WHERE '20010415' > date
	GROUP BY point
 ) AS dd
 ON ss.point = dd.point;

-- 61

select sum(COALESCE (ss.inc, 0) - COALESCE (dd.out, 0)) as balance
from (select point , sum(inc) inc from Income_o  group by point  ) ss 
full join (select point ,sum(out) out from Outcome_o  group by point) dd on ss.point=dd.point;

-- 62

select sum(COALESCE (ss.inc, 0) - COALESCE (dd.out, 0)) as balance
from (select point , sum(inc) inc from Income_o WHERE '20010415' > date group by point  ) ss 
full join (select point ,sum(out) out from Outcome_o WHERE '20010415' > date group by point) dd on ss.point=dd.point;



-- 63 

select name from passenger
where id_psg in (
  select
    p.id_psg
    from pass_in_trip p
    group by p.id_psg, p.place
    having count(*) > 1
);

-- 64  
select
  coalesce(i.point,o.point) as point
  ,coalesce(i.date,o.date) as date
  ,CASE WHEN sum(inc) is not null
        THEN 'inc' ELSE 'out'
   END as operation
  ,CASE WHEN sum(inc) is not null
        THEN sum(inc)
        ELSE sum(out)
    END as money
  from income i
  full join outcome o on i.date=o.date and i.point=o.point
  group by coalesce(i.point,o.point), coalesce(i.date,o.date)
  having sum(inc) is null OR sum(out) is null
order by 1,2;

