-- Which teams have the easiest upcoming fixtures? Average difficulty per team over the next 5 upcoming fixtures.
-- As fixtures for a team need to disregard if they're home and away, therefore UNION combines the two queries (for one fixture)
-- Each fixture has two rows, this allows then for a team to collate fixture difficulty as just team_id

-- Using UNION ALL
WITH fixture_list AS (
    SELECT gameweek, fixture_id, team_h AS team_id, team_a AS opponent_id, team_h_difficulty AS fixture_difficulty
    FROM fixtures
    WHERE team_a_score IS NULL

    UNION ALL

    SELECT gameweek, fixture_id, team_a AS team_id, team_h AS opponent_id, team_a_difficulty AS fixture_difficulty
    FROM fixtures
    WHERE team_a_score IS NULL),

ordered_fixtures AS (SELECT ROW_NUMBER() OVER(PARTITION BY team_id ORDER BY gameweek, fixture_id) AS team_fixtures, fixture_id, team_id, fixture_difficulty
    FROM fixture_list)

SELECT t.name, ROUND(AVG(fixture_difficulty), 2) AS avg_fixture_difficulty_next_5_games
FROM ordered_fixtures
JOIN teams as t
ON ordered_fixtures.team_id = t.team_id
WHERE team_fixtures <= 5
GROUP BY t.name
ORDER BY avg_fixture_difficulty_next_5_games;
