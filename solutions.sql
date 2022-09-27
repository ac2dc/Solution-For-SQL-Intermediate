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

-- 66

SELECT date, max(c) as total_trip FROM
(SELECT date,count(*) AS c FROM Trip,
(SELECT trip_no,date FROM Pass_in_trip WHERE date>='2003-04-01' AND date<='2003-04-07' GROUP BY trip_no, date) AS t1
WHERE Trip.trip_no=t1.trip_no AND town_from='Rostov'
GROUP BY date
UNION ALL
SELECT '2003-04-01',0
UNION ALL
SELECT '2003-04-02',0
UNION ALL
SELECT '2003-04-03',0
UNION ALL
SELECT '2003-04-04',0
UNION ALL
SELECT '2003-04-05',0
UNION ALL
SELECT '2003-04-06',0
UNION ALL
SELECT '2003-04-07',0) AS t2
GROUP BY date;

-- 67
With cte AS
(
select town_from, town_to, count(*) as rn  from trip 
group by town_from, town_to
)
select count(rn) as max_num_flight from cte
where rn = (select max(rn) from cte);

-- 68

WITH trips AS (
SELECT towns.town_1, towns.town_2, COUNT(*) AS cnt, DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) as dr FROM Trip t1
	CROSS APPLY (VALUES(CASE WHEN town_from < town_to THEN town_from ELSE town_to END,CASE WHEN town_from < town_to THEN town_to ELSE town_from END)) AS towns(town_1, town_2)
	GROUP BY towns.town_1, towns.town_2
)
SELECT COUNT(*)  as tot FROM trips
WHERE dr = 1;

-- 69   

-- 70

WITH ships_battles AS
(
SELECT class, country, battle FROM Classes c JOIN Outcomes o ON c.class = o.ship
UNION
SELECT name, country, battle FROM Outcomes o JOIN Ships s on o.ship = s.name 
JOIN Classes c ON s.class = c.class
), battles AS (
SELECT  battle FROM ships_battles s
GROUP BY country, battle
HAVING COUNT(*) >= 3
)
SELECT DISTINCT battle FROM battles ;

-- 71
select p.maker from product p where p.type = 'PC'
except
select p.maker from product p where p.type = 'PC'
and not exists
(
   select null from pc pc where pc.model = p.model
);

-- 72
WITH table1 AS(SELECT pA.ID_psg, COUNT(pA.ID_psg) as trip_Qty,  max(count(1)) over() as max 
FROM Pass_in_trip pa JOIN Trip t ON t.trip_no = pa.trip_no 
GROUP by pa.ID_psg
HAVING count(DISTINCT t.id_comp) = 1)

SELECT name, trip_qty
FROM table1 t JOIN passenger p
ON t.id_psg = p.id_psg
WHERE max = trip_Qty;

-- 73 
WITH t1 AS (SELECT c.country, o.battle
FROM classes c, outcomes o
WHERE c.class = o.ship
UNION
SELECT c.country, o.battle
FROM classes c, ships s, outcomes o
WHERE c.class = s.class AND s.name = o.ship
)
SELECT DISTINCT country, b.name
FROM classes c, battles b
WHERE
(SELECT COUNT(1)
FROM t1
WHERE t1.country = c.country
AND t1.battle = b.name) = 0;

-- 74


-- 75

with cte
as
(
select model,price from printer
union all
select model,price from pc
union all
select model,price from laptop)

select t.* from (

select maker,price,p.type from Product p inner join cte on p.model=cte.model) as t
pivot (max(price)
for type in ([Laptop],[PC],[Printer]) )as t
where coalesce(t.Laptop, t.pc, t.Printer) is not null;

-- 76
SELECT p.name, SUM(
	CASE WHEN t.time_out > t.time_in THEN 1440 - DATEDIFF(minute, t.time_in, t.time_out)
		ELSE DATEDIFF(minute, t.time_out, t.time_in) END
	) AS minutes 
FROM Passenger p 
JOIN Pass_in_trip pit ON p.ID_psg = pit.ID_psg
JOIN Trip t ON pit.trip_no = t.trip_no
GROUP BY p.ID_psg, p.name
HAVING COUNT(DISTINCT pit.place) = COUNT(pit.place);

-- 77
with rnk as(
Select count(distinct dt.trip_no) as cnt, dt.date, 
rank() over(order by count(distinct dt.trip_no) desc) as rn
from pass_in_trip dt join trip t on dt.trip_no = t.trip_no
where t.town_from = 'Rostov'
group by dt.date
)
select cnt, date from rnk where rn = 1;

-- 78
select name, cast(dateadd(month, datediff(month, '19000101', date), '19000101') as date) as firstday,
cast(dateadd(month, datediff(month, '19000131', date), '19000131') as date) from battles;

-- 79


-- 80
SELECT maker FROM PRODUCT
EXCEPT
SELECT  p.maker
FROM  product p
LEFT JOIN pc ON pc.model = p.model
WHERE p.type = 'PC' and pc.model is null;

-- 81
with summarized_dates as
(
Select year(date) yr, month(date) mn, sum(out) as summ, rank() over(order by sum(out) desc) as rn from outcome
group by year(date), month(date)
)
select o.* from outcome o inner join summarized_dates sd
on sd.yr = YEAR(o.date) and sd.mn = MONTH(o.date) and sd.rn = 1;

-- 82
with cte as
(select *, avg(price) over(order by code asc rows between current row and 5 following) as avgprc,
count(*) over(order by code asc rows between current row and 5 following) as cnt from pc pc1
)
select code, avgprc from cte
where cnt = 6;

-- 83
WITH criterias AS
(
	SELECT s.name,
	CASE WHEN numGuns = 8 THEN 1 ELSE 0 END AS crit1,
	CASE WHEN bore = 15 THEN 1 ELSE 0 END AS crit2,
	CASE WHEN displacement = 32000 THEN 1 ELSE 0 END AS crit3,
	CASE WHEN type = 'bb' THEN 1 ELSE 0 END AS crit4,
	CASE WHEN launched = 1915 THEN 1 ELSE 0 END AS crit5,
	CASE WHEN s.class = 'Kongo' THEN 1 ELSE 0 END AS crit6,
	CASE WHEN country = 'USA' THEN 1 ELSE 0 END AS crit7
	FROM Classes c JOIN Ships s ON c.class = s.class
)
SELECT name FROM criterias
WHERE crit1 + crit2 + crit3 + crit4 + crit5 + crit6 + crit7 >= 4;

-- 84
WITH timestamps AS 
(
Select c.name, 
CASE WHEN [date] BETWEEN CAST('20030401' as date) AND CAST('20030410' as date) THEN 1 
WHEN [date] BETWEEN CAST('20030411' as date) AND CAST('20030420' as date) THEN 2
ELSE 3 END as num FROM
Trip t inner join Pass_in_trip pit on t.trip_no = pit.trip_no
INNER JOIN Company c on c.ID_comp = t.ID_comp
WHERE [date] <= '20030430' AND [date] >= '20030401'
)
SELECT * FROM timestamps
PIVOT (
count(num) FOR num IN ([1], [2], [3])
) as pvt;

-- 85

SELECT		maker
FROM		product
GROUP BY	maker
HAVING		sum(CASE WHEN type = 'Printer' THEN 1 END) = count(*)
		OR (sum(CASE WHEN type = 'PC' THEN 1 END) > = 3
			AND sum(CASE WHEN type = 'PC' THEN 1 END) = count(*));

-- 87 
select p.name, sum(case when t.town_to = 'Moscow' then 1 else 0 end ) from passenger p JOIN pass_in_trip pit ON p.id_psg = pit.id_psg JOIN trip t on pit.trip_no = t.trip_no

GROUP BY p.id_psg, p.name	
having MIN(pit.date + t.time_out) <> MIN(case when t.town_from = 'Moscow' then pit.date + t.time_out else '30000101 00:00:00' end)
AND sum(case when t.town_to = 'Moscow' then 1 else 0 end) > 1;

-- 88


-- 89

with all_cnts AS 
(
    select maker, count(*) as cnt, min(count(*)) over() as rn_asc, max(count(*)) over() as rn_desc from product
    group by maker
)
select maker, cnt from all_cnts
where rn_asc = cnt or rn_desc = cnt;

-- 90
select * from product
order by model asc
offset 3 rows fetch next (select count(*) - 6 from product) rows only;

-- 91
WITH all_results AS
(
	SELECT SUM(1.0 * ISNULL(b.B_VOL, 0.00)) AS sumb, COUNT(DISTINCT q.Q_ID) AS cnt FROM utQ q LEFT JOIN utb b ON q.Q_ID = b.B_Q_ID
)
SELECT CAST(sumb/cnt AS decimal(5,2)) FROM all_results ar;

-- 92
WITH results AS
(
	SELECT b.B_Q_ID, SUM(b.B_VOL) OVER(PARTITION BY b.B_Q_ID) AS sum_q, b.B_V_ID, SUM(b.B_VOL) OVER (PARTITION BY b.B_V_ID) AS sum_v FROM utB b
)
SELECT q.q_name FROM results r JOIN utQ q ON r.B_Q_ID = q.Q_ID
GROUP BY r.B_Q_ID, q.Q_NAME
HAVING MIN(r.sum_q) = 765 AND MIN(r.sum_v) = 255;

-- 93
Select c.name, sum(x.summ)
FROM company c INNER JOIN trip t on t.id_comp = c.id_comp
INNER JOIN (select distinct trip_no, date from pass_in_trip) pit ON t.trip_no = pit.trip_no
CROSS APPLY (
   VALUES(
      CASE WHEN t.time_out < t.time_in THEN DATEDIFF(MINUTE, t.time_out, t.time_in)
   ELSE 1440 - abs(DATEDIFF(MINUTE, t.time_out, t.time_in))
   END 
   )
) as x(summ)
group by c.name;

-- 94




-- 100

WITH cte_inc AS
(
	SELECT code, point, [date], inc, row_number() OVER(PARTITION BY [date] ORDER BY code) AS rn_ci FROM INCOME
), cte_out AS
(
	SELECT code, point, [date], out, row_number() OVER(PARTITION BY [date] ORDER BY code) AS rn_co FROM OUTCOME
)
SELECT ISNULL(ci.date, co.date) AS [date], COALESCE(ci.rn_ci, co.rn_co) ,  ci.point as point_i, ci.inc,   co.point as point_o, co.out
FROM cte_inc ci FULL OUTER JOIN cte_out co ON ci.[date] = co.[date] AND ci.rn_ci = co.rn_co;

-- 101

-- 125 
;WITH cte AS ( SELECT p.ID_psg, p.name, place, LEAD(pit.place, 1, '') 
OVER(PARTITION BY pit.id_psg ORDER BY pit.[date], t.time_out) AS nxt_place 
FROM Pass_in_trip pit 
JOIN Trip t ON pit.trip_no = t.trip_no JOIN Passenger p ON p.ID_psg = pit.ID_psg )
SELECT c.name FROM cte c WHERE c.place = c.nxt_place GROUP BY c.id_psg, c.name;

