CREATE TABLE cse532.dblp (
    author VARCHAR(100),
    xmlcontent XML
);

LOAD FROM ./data/DAPatterson.del OF DEL XML FROM ./data/DAPatterson.xml INSERT INTO cse532.dblp;
LOAD FROM ./data/JohnLHennessy.del OF DEL XML FROM ./data/JohnLHennessy.xml INSERT INTO cse532.dblp;
