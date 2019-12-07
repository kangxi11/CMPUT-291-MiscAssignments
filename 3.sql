.print Question 3 - rkang1

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
