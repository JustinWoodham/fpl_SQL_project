-- What defences should I consider coming up? 
-- This query takes into account goals conceded and the difficulty of the next 5 fixtures
-- Filters Defenders and Goalkeepers, where their teams are in the top 20% for goals conceded and fixture difficulty
-- FUTURE WORK: Min-max scaling, (x - MIN(x)) / (MAX(x) - MIN(x)), keeps the gaps proportional for PERCENTILE

WITH goals AS (
    SELECT t.team_id, t.name, SUM(CASE WHEN t.team_id = f.team_a THEN f.team_h_score ELSE f.team_a_score END) AS conceded
    FROM teams AS t
    JOIN fixtures as f
    ON t.team_id = f.team_h OR t.team_id = f.team_a
    GROUP BY t.team_id),

percentile_goals AS(
    SELECT team_id, name, conceded, ROUND(PERCENT_RANK() OVER(ORDER BY conceded)::numeric,2) AS percentile_goals
    FROM goals),

fixture_list AS (
    SELECT gameweek, fixture_id, team_h AS team_id, team_a AS opponent_id, team_h_difficulty AS fixture_difficulty
    FROM fixtures
    WHERE team_a_score IS NULL
    UNION ALL
    SELECT gameweek, fixture_id, team_a AS team_id, team_h AS opponent_id, team_a_difficulty AS fixture_difficulty
    FROM fixtures
    WHERE team_a_score IS NULL),

ordered_fixtures AS (
    SELECT ROW_NUMBER() OVER(PARTITION BY team_id ORDER BY gameweek, fixture_id) AS team_fixtures, fixture_id, team_id, fixture_difficulty
    FROM fixture_list),

easiest_fixtures AS(
    SELECT team_id, ROUND(AVG(fixture_difficulty),2) AS avg_difficulty_next_5, ROUND(PERCENT_RANK() OVER(ORDER BY (AVG(fixture_difficulty)))::numeric ,2) AS percentile_fixtures
    FROM ordered_fixtures
    WHERE team_fixtures <= 5
    GROUP BY team_id)

SELECT web_name, long_position as position, name, conceded as goals_conceded, percentile_goals, avg_difficulty_next_5, percentile_fixtures
FROM percentile_goals
JOIN easiest_fixtures
USING(team_id)
JOIN players
USING(team_id)
JOIN positions
ON players.position_type = positions.position_type
WHERE long_position IN ('Defender', 'Goalkeeper') AND percentile_goals < 0.20 AND percentile_fixtures < 0.2
ORDER BY avg_difficulty_next_5;