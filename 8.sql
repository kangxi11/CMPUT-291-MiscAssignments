.print Question 8 - rkang1

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
