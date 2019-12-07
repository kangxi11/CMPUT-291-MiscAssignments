.echo on

--Question 1
SELECT DISTINCT p.fname, p.lname, p.phone
FROM registrations r, vehicles v, persons p
WHERE r.vin = v.vin AND v.year = 1969 AND v.make = 'Chevrolet' AND v.model = 'Camaro'
      AND r.fname = p.fname AND r.lname = p.lname;


--Question 2
SELECT DISTINCT b2.fname, b2.lname
FROM births b1, births b2
WHERE b1.fname = 'Michael' AND b1.lname = 'Fox' AND b1.f_fname = b2.f_fname AND b1.f_lname = b2.f_lname

      UNION -- union the mother's children and father's children

SELECT DISTINCT b2.fname, b2.lname
FROM births b1, births b2
WHERE b1.fname = 'Michael' AND b1.lname = 'Fox' AND b1.m_fname = b2.m_fname AND b1.m_lname = b2.m_lname

      EXCEPT -- remove Michael Fox

SELECT b1.fname, b1.lname
FROM births b1, births b2
WHERE b1.fname = 'Michael' AND b1.lname = 'Fox';


--Question 3
SELECT b5.fname, b5.lname
FROM births b1, births b2, births b4, births b5
WHERE b1.fname = 'Michael' AND b1.lname = 'Fox'
      AND b1.m_fname = b2.fname AND b1.m_lname = b2.lname
      AND b4.f_fname = b2.f_fname AND b4.f_lname = b2.f_lname
      AND ( (b5.f_fname = b4.fname AND b5.f_lname = b4.lname) OR (b5.m_fname = b4.fname AND b5.m_lname = b4.lname) )

      UNION

SELECT b5.fname, b5.lname
FROM births b1, births b2, births b4, births b5
WHERE b1.fname = 'Michael' AND b1.lname = 'Fox'
      AND b1.f_fname = b2.fname AND b1.f_lname = b2.lname
      AND b4.f_fname = b2.f_fname AND b4.f_lname = b2.f_lname
      AND ( (b5.m_fname = b4.fname AND b5.m_lname = b4.lname) OR (b5.f_fname = b4.fname AND b5.f_lname = b4.lname) )

      EXCEPT

SELECT b1.fname, b1.lname
FROM births b1, births b2
WHERE (b1.fname = 'Michael' AND b1.lname = 'Fox');


--Question 4
SELECT p1.fname, p1.lname
FROM births b1, persons p1,
    (SELECT MIN(p.bdate) as oldest -- returns the bdate of oldest child
    FROM persons p, births b
    WHERE b.f_fname = 'Michael' AND b.f_lname = 'Fox' AND p.fname = b.fname AND p.lname = b.lname) as a
WHERE b1.f_fname = 'Michael' AND b1.f_lname = 'Fox' and p1.fname = b1.fname AND p1.lname = b1.lname AND p1.bdate = a.oldest;


--Question 5
SELECT d.fname, d.lname
FROM demeritNotices d
WHERE d.ddate > date('now', '-2 years') and d.ddate < date('now')
GROUP BY d.fname, d.lname
HAVING SUM(d.points) >= 15;

--Question 6
SELECT m.fname, m.lname
FROM
    (SELECT m1.regdate AS regdate, m1.p2_fname AS fname, m1.p2_lname AS lname
    FROM marriages m1
    WHERE m1.p1_fname = 'Michael' AND m1.p1_lname = 'Fox'

    UNION --union all partners if MF is partner 1 and if MF is partner 2

    SELECT m2.regdate AS regdate, m2.p1_fname AS fname, m2.p1_lname as lname
    FROM marriages m2
    WHERE m2.p2_fname = 'Michael' AND m2.p2_lname = 'Fox') AS m

ORDER BY m.regdate DESC
LIMIT 1; -- only return the most recent marriage

--Question 7
SELECT v.color, COUNT(t.tno)*1.0 / COUNT(DISTINCT r.regno) as TPerR, AVG(t.fine) as AVGFine, MAX(t.fine) as MAXFine
FROM vehicles v LEFT OUTER JOIN registrations r using (vin) LEFT OUTER JOIN tickets t using (regno)
WHERE r.expiry > date('now', '+2 months')
GROUP BY v.color;

--Question 8
SELECT m.year, m.make, c.color
FROM
    (SELECT v3.year, v3.make
    FROM
        (SELECT v1.year as year, v1.make as make, COUNT(*) as make_count
        FROM vehicles v1
        GROUP BY v1.year, v1.make) as v3, -- produce number of makes in each year and make

        (SELECT v.year as year, MAX(v.make_count) as make_count
        FROM
            (SELECT v1.year as year, v1.make as make, COUNT(*) as make_count
            FROM vehicles v1
            GROUP BY v1.year, v1.make) as v -- produce number of makes in each year and make
        GROUP BY v.year) as v2 --produce the each year with the max # of makes
    WHERE v2.year = v3.year AND v2.make_count = v3.make_count) as m, -- give makes that match the max # of makes per year

    (SELECT v3.year, v3.color
    FROM
        (SELECT v1.year as year, v1.color as color, COUNT(*) as color_count
        FROM vehicles v1
        GROUP BY v1.year, v1.color) as v3,

        (SELECT v.year as year, MAX(v.color_count) as color_count
        FROM
            (SELECT v1.year as year, v1.color as color, COUNT(*) as color_count
            FROM vehicles v1
            GROUP BY v1.year, v1.color) as v --produce all years with the # of times a color showed up that year
        GROUP BY v.year) as v2 -- produce the maximum number of the same color
    WHERE v2.year = v3.year AND v2.color_count = v3.color_count) as c --produce all colors that match the maximum # of colors

WHERE m.year = c.year; -- match the years together

--Question 9
CREATE VIEW personDetails (fname, lname, bdate, bplace, carsowned, ticketsRcvd)
AS SELECT p.fname, p.lname, p.bdate, p.bplace, IFNULL(cc.car_count,0), IFNULL(tc.ticket_count,0)
FROM persons p
      LEFT OUTER JOIN
      (SELECT r.fname as fname, r.lname as lname, COUNT(*) as car_count
      FROM registrations r
      WHERE r.regdate > date('now', '-1 years')
      GROUP BY r.fname, r.lname) as cc USING (fname, lname) -- produces # of cars owned by each person registerd in past year

      LEFT OUTER JOIN
      (SELECT t2.fname as fname, t2.lname as lname, SUM(t2.ticket_count) as ticket_count -- the group by will combine all regno ticket counts
      FROM
        (SELECT r2.fname, r2.lname, t1.ticket_count as ticket_count -- will have a ticket_count for each car that person owns (because we grouped by regno as well)
        FROM registrations r2, persons p1,
            (SELECT t.regno as regno, COUNT(*) as ticket_count --registrations and the number of tickets it received
            FROM tickets t, registrations r1
            WHERE t.vdate > date('now', '-1 years') AND t.regno = r1.regno AND r1.regdate > date('now', '-1 years')
            GROUP BY t.regno) as t1 --number of tickets given to cars registered in past year, tickets also 1 year old
        WHERE t1.regno = r2.regno
        GROUP BY r2.fname, r2.lname, t1.regno) as t2 -- have to group with regno in case multiple cars
      GROUP BY t2.fname, t2.lname) as tc USING (fname, lname);

--Question 10
SELECT p.fname, p.lname, v.make, v.model
FROM personDetails p, registrations r, tickets t, vehicles v
WHERE p.ticketsRcvd >= 3 AND p.fname = r.fname AND p.lname = r.lname AND v.vin = r.vin AND t.regno = r.regno
      AND t.violation LIKE '%red light%'
GROUP BY p.fname, p.lname, v.make, v.model, r.regno;
