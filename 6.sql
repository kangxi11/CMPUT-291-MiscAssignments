.print Question 6 - rkang1

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
