DROP TABLE IF EXISTS fixtures;

CREATE TABLE fixtures (
    fixture_id INT PRIMARY KEY,
    code INT UNIQUE NOT NULL,
    gameweek INT NOT NULL,
    kickoff_time TIMESTAMPTZ,
    team_h INT NOT NULL REFERENCES teams (team_id),
    team_a INT NOT NULL REFERENCES teams (team_id),
    team_h_score INT,
    team_a_score INT,
    team_h_difficulty INT NOT NULL,
    team_a_difficulty INT NOT NULL,
    finished BOOLEAN
    );