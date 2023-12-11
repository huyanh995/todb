DROP TABLE cse532.dblp;
CREATE TABLE cse532.dblp (
    author VARCHAR(100),
    xmlcontent XML
);

IMPORT FROM "./data/DAPatterson.del" OF DEL INSERT INTO cse532.dblp;
IMPORT FROM "./data/JohnLHennessy.del" OF DEL INSERT INTO cse532.dblp;



