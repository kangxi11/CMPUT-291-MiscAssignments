.print Question 5 - rkang1

SELECT d.fname, d.lname
FROM demeritNotices d
WHERE d.ddate > date('now', '-2 years') and d.ddate < date('now')
GROUP BY d.fname, d.lname
HAVING SUM(d.points) >= 15;
