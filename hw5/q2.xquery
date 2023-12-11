let $doc := doc("data/JohnLHennessy.xml")/dblpperson
(: BRAINSTORM
Title of most co-authored paper
1. Get number of co-authors for all papers -> get the max counts
2. Get all papers with number of co-authors = max count
3. Limit to 1 paper
:)
let $maxCntCoAuthors := max($doc//article/count(author[. != "John L. Hennessy"]))
let $maxCntCoAuthorsPapers := $doc/r/*[count(author[. != "John L. Hennessy"]) = $maxCntCoAuthors]

return <results question="q2">{
    <paper count-coauthors="{$maxCntCoAuthors}">{$maxCntCoAuthorsPapers[position() le 1]/title/text()}
    </paper>
}</results>

