\set ON_ERROR_STOP 1

CREATE TABLE agg AS
SELECT "Race", "Military", "server", sum("N") "N" 
FROM raw 
GROUP BY "Race", "Military", "server"
