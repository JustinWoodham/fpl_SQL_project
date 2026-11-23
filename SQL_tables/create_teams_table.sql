DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,
    short_name  CHAR(3)    NOT NULL UNIQUE,
    strength_overall_home   CHAR    NOT NULL ,
    strength_overall_away   CHAR    NOT NULL   
);
 
