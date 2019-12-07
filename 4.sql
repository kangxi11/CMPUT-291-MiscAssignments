.print Question 4 - rkang1

SELECT p1.fname, p1.lname
FROM births b1, persons p1,
    (SELECT MIN(p.bdate) as oldest -- returns the bdate of oldest child
    FROM persons p, births b
    WHERE b.f_fname = 'Michael' AND b.f_lname = 'Fox' AND p.fname = b.fname AND p.lname = b.lname) as a
WHERE b1.f_fname = 'Michael' AND b1.f_lname = 'Fox' and p1.fname = b1.fname AND p1.lname = b1.lname AND p1.bdate = a.oldest;
