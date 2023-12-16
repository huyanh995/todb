WITH DavidCoAuthors AS (
    -- Select distinct all co-authors of John L. Hennessy
    SELECT DISTINCT XMLCOL.author
    FROM cse532.dblp,
    XMLTABLE('/dblpperson/r/*/author[. != "David A. Patterson 0001"]'
            PASSING cse532.dblp.xmlcontent
            COLUMNS
                author VARCHAR(255) PATH 'text()'
            ) AS XMLCOL
    WHERE cse532.dblp.author = 'David A. Patterson'
),
JohnCoAuthors AS (
    -- Select distinct all co-authors of David A. Patterson
    SELECT DISTINCT XMLCOL.author
    FROM cse532.dblp,
         XMLTABLE('/dblpperson/r/*/author[. != "John L. Hennessy"]'
                  PASSING cse532.dblp.xmlcontent
                  COLUMNS
                  author VARCHAR(255) PATH 'text()'
             ) AS XMLCOL
    WHERE cse532.dblp.author = 'John L. Hennessy'
)
-- Select all mutual co-authors of John L. Hennessy and David A. Patterson
SELECT DISTINCT JohnCoAuthors.author
FROM JohnCoAuthors, DavidCoAuthors
WHERE JohnCoAuthors.author = DavidCoAuthors.author;
