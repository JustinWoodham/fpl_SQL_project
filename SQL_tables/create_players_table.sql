DROP TABLE IF EXISTS players;

CREATE TABLE players (
    player_id INT PRIMARY KEY NOT NULL,
    code INT UNIQUE NOT NULL,
    web_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    position_type INT NOT NULL REFERENCES positions(position_type),
    team_id INT NOT NULL REFERENCES teams(team_id),
    selected_by_percent DECIMAL NOT NULL,
    now_cost DECIMAL NOT NULL,
    total_points INT NOT NULL,
    bonus INT NOT NULL,
    ict_index DECIMAL NOT NULL,
    form DECIMAL NOT NULL,
    form_rank DECIMAL NOT NULL,
    minutes INT NOT NULL,
    goals_scored INT NOT NULL,
    assists INT NOT NULL,
    saves INT NOT NULL,
    tackles INT NOT NULL);