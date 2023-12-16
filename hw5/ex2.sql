-- XQuery inside Db2
XQuery
let $davidcoauthors := (
    for $coauthor in db2-fn:xmlcolumn("CSE532.DBLP.XMLCONTENT")/dblpperson[@name="David A. Patterson 0001"]/r/*/author[. != "David A. Patterson 0001"]
    return distinct-values($coauthor)
)
let $johncoauthors := (
    for $coauthor in db2-fn:xmlcolumn("CSE532.DBLP.XMLCONTENT")/dblpperson[@name="John L. Hennessy"]/r/*/author[. != "John L. Hennessy"]
    return distinct-values($coauthor)
)
return distinct-values(
    for $author in $davidcoauthors
    where $author = $johncoauthors
    return $author
)
;

-- XML/SQL approach
-- WITH DavidCoAuthors AS (
--     -- Select distinct all co-authors of John L. Hennessy
--     SELECT DISTINCT XMLCOL.author
--     FROM cse532.dblp,
--     XMLTABLE('/dblpperson/r/*/author[. != "David A. Patterson 0001"]'
--             PASSING cse532.dblp.xmlcontent
--             COLUMNS
--                 author VARCHAR(255) PATH 'text()'
--             ) AS XMLCOL
--     WHERE cse532.dblp.author = 'David A. Patterson'
-- ),
-- JohnCoAuthors AS (
--     -- Select distinct all co-authors of David A. Patterson
--     SELECT DISTINCT XMLCOL.author
--     FROM cse532.dblp,
--          XMLTABLE('/dblpperson/r/*/author[. != "John L. Hennessy"]'
--                   PASSING cse532.dblp.xmlcontent
--                   COLUMNS
--                   author VARCHAR(255) PATH 'text()'
--              ) AS XMLCOL
--     WHERE cse532.dblp.author = 'John L. Hennessy'
-- )
-- -- Select all mutual co-authors of John L. Hennessy and David A. Patterson
-- SELECT DISTINCT JohnCoAuthors.author
-- FROM JohnCoAuthors, DavidCoAuthors
-- WHERE JohnCoAuthors.author = DavidCoAuthors.author;

