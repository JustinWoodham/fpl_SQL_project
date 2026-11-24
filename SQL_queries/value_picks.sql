-- Selecting Top 3 Players for points earned per million cost for each position
--- Retrieves 3 of the top attackers, midfielders, defenders and goalkeepers
--- Filters players who have not played 
--- Ranked by points / cost


WITH value AS (SELECT ROW_NUMBER() OVER(PARTITION BY po.long_position ORDER BY (ROUND(pl.total_points / pl.now_cost, 2)) DESC, pl.bonus) AS rank, pl.web_name AS player, po.long_position AS position, (ROUND(pl.total_points / pl.now_cost, 2)) AS points_per_million
    FROM players as pl
    JOIN positions as po
    ON pl.position_type = po.position_type
    WHERE pl.minutes > (0.7 * 90 * (SELECT COUNT(DISTINCT gameweek)
                                    FROM fixtures
                                    WHERE team_a_score IS NOT NULL )))
SELECT position, rank, player, points_per_million
FROM value
WHERE rank <=3
ORDER BY CASE position 
    WHEN 'Attacker' THEN 1
    WHEN 'Midfielder' THEN 2
    WHEN 'Defender' THEN 3
    WHEN 'Goalkeeper' THEN 4
    END, rank;
