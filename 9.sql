.print Question 9 - rkang1

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
