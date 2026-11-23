DROP TABLE IF EXISTS positions;

CREATE TABLE positions(
    position_type INT PRIMARY KEY NOT NULL, 
    short_position CHAR(3) NOT NULL,
    long_position VARCHAR NOT NULL
);

INSERT INTO positions
VALUES (1, 'GKP', 'Goalkeeper'), (2, 'DEF', 'Defender'), (3, 'MID', 'Midfielder'), (4, 'ATK', 'Attacker');