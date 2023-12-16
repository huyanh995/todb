-- Return paper with most coauthors for each author
WITH CountCoAuthors AS (
    SELECT
        cse532.dblp.author,
        XMLQUERY('
            for $p in $doc/dblpperson/r/*
            let $coauthors := $p/author
            let $title := string($p/title)
            order by count($coauthors) -1 descending
            return <paper title="{$title}"/>
        ' PASSING dblp.xmlcontent AS "doc") AS title
    FROM
        cse532.dblp
)
SELECT
    author,
    XMLQUERY('string($title[1]/@title)' PASSING title AS "title") AS title
FROM CountCoAuthors;
