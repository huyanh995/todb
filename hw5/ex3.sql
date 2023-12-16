-- Return paper with most coauthors for each author
WITH CountCoAuthors AS (
    SELECT
        cse532.dblp.author,
        XMLQUERY('
            for $p in $doc/dblpperson/r/*
            let $coauthors := $p/author[. != "David A. Patterson 0001" and . != "John L. Hennessy"]
            let $title := string($p/title)
            order by count($coauthors) descending
            return <paper title="{$title}" count="{count($coauthors)}"/>
        ' PASSING dblp.xmlcontent AS "doc") AS title
    FROM
        cse532.dblp
)
SELECT
    author,
    XMLQUERY('string($title[1]/@title)' PASSING title AS "title") AS title,
    XMLQUERY('string($title[1]/@count)' PASSING title AS "title") AS count
FROM CountCoAuthors;
