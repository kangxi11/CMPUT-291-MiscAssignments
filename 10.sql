.print Question 10 - rkang1

SELECT p.fname, p.lname, v.make, v.model
FROM personDetails p, registrations r, tickets t, vehicles v
WHERE p.ticketsRcvd >= 3 AND p.fname = r.fname AND p.lname = r.lname AND v.vin = r.vin AND t.regno = r.regno
      AND t.violation LIKE '%red light%'
GROUP BY p.fname, p.lname, v.make, v.model, r.regno;
