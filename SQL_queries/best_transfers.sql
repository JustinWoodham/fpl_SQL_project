--- Combining multiple queries and CTEs, who should I look at transfering in?
--- Selects: players from three teams with the easiest next 5 fixture run, who has played atleast 80% of minutes this season
--- Ordered by team with easiest fixtures, followed by form then position
--- Includes players position, cost and points per million for reference

WITH value AS (SELECT pl.player_id,
                        pl.web_name AS player, 
                        po.long_position AS position, (ROUND(pl.total_points / pl.now_cost, 2)) AS points_per_million,
                        pl.team_id,
                        pl.form,
                        t.name,
                        pl.now_cost
    FROM players as pl
    JOIN positions as po
    ON pl.position_type = po.position_type
    JOIN teams as t
    ON pl.team_id = t.team_id
    WHERE pl.minutes > (0.8 * 90 * (SELECT COUNT(DISTINCT gameweek)
                                    FROM fixtures
                                    WHERE team_a_score IS NOT NULL ))),

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
    SELECT team_id, round(AVG(fixture_difficulty), 2) AS avg_difficulty_next_5
    FROM ordered_fixtures
    WHERE team_fixtures <= 5
    GROUP BY team_id
),
top_3_teams AS(
    SELECT team_id, avg_difficulty_next_5, ROW_NUMBER() OVER(ORDER BY avg_difficulty_next_5) AS teams_with_easiest_fixtures
    FROM easiest_fixtures)

SELECT v.name as club, v.position, v.player, v.now_cost as price, v.points_per_million, v.form, ef.avg_difficulty_next_5
FROM value as v
JOIN top_3_teams as ef
ON v.team_id = ef.team_id
WHERE ef.teams_with_easiest_fixtures <= 3
ORDER BY ef.avg_difficulty_next_5, form DESC, CASE v.position 
    WHEN 'Attacker' THEN 1
    WHEN 'Midfielder' THEN 2
    WHEN 'Defender' THEN 3
    WHEN 'Goalkeeper' THEN 4
    END
;