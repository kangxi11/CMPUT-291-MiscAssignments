.print Question 7 - rkang1

SELECT v.color, COUNT(t.tno)*1.0 / COUNT(DISTINCT r.regno) as TPerR, AVG(t.fine) as AVGFine, MAX(t.fine) as MAXFine
FROM vehicles v LEFT OUTER JOIN registrations r using (vin) LEFT OUTER JOIN tickets t using (regno)
WHERE r.expiry > date('now', '+2 months')
GROUP BY v.color;
