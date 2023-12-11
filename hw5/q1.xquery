let $doc := doc("data/DAPatterson.xml")/dblpperson
(: BRAINSTORM
1. Count papers each year -> papers can be article, inproceedings, book, proceedings
2. Average number of co-authors per paper by David A. Patterson
    -> DAPatterson -> All papers authored by DAPatterson
    -> For each paper, count the number of authors
:)
let $years := distinct-values($doc/r/*/year)
return <results question="q1">{ (: make result a valid XML :)
    for $year in $years
        let $papers := $doc/r/*[year = $year]
        let $cntPapers := count($papers)
        let $cntCoAuthors := sum(
            for $paper in $papers
                return count($paper/author[. != "David A. Patterson 0001"])
            )
    order by $year
    return <year
        value="{$year}"
        count-papers="{$cntPapers}"
        avg_coauthors="{
            if ($cntPapers = 0) then 0
            else $cntCoAuthors div $cntPapers
            }"
        />
}</results>










