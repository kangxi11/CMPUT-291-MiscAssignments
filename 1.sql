.print Question 1 - rkang1

SELECT DISTINCT p.fname, p.lname, p.phone
FROM registrations r, vehicles v, persons p
WHERE r.vin = v.vin AND v.year = 1969 AND v.make = 'Chevrolet' AND v.model = 'Camaro'
      AND r.fname = p.fname AND r.lname = p.lname;
