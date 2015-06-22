\set ON_ERROR_STOP 1

CREATE TABLE IF NOT EXISTS agg (
	"Race" text,
	"Military" text,
	"Server" text,
	"N" bigint
);

INSERT INTO agg
SELECT "Race", "Military", "Server", sum("N") "N" 
FROM raw 
GROUP BY "Race", "Military", "Server";
