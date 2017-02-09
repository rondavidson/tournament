--Database and table creation

--Create the data base and connect to it & tables
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\connect tournament
DROP TABLE IF EXISTS player CASCADE;
DROP TABLE IF EXISTS match CASCADE;
DROP VIEW IF EXISTS standings CASCADE;

-- Player table
CREATE TABLE player(
  player_id serial PRIMARY KEY,
  player_name text
);

-- Macth table
CREATE TABLE match (
  match_id serial PRIMARY KEY,
  match_winner INTEGER,
  match_loser INTEGER,
  FOREIGN KEY(match_winner) REFERENCES player(player_id),
  FOREIGN KEY(match_loser) REFERENCES player(player_id)
);

-- See latest standings
CREATE VIEW standings AS
SELECT player.player_id as player_id, player.player_name,
(SELECT count(*) FROM match WHERE match.match_winner = player.player_id) as won,
(SELECT count(*) FROM match WHERE player.player_id in (match_winner, match_loser)) as played
FROM player
GROUP BY player.player_id
ORDER BY won DESC;
