-- Differential picks, players with top 10% ICT whilst having less than 10% ownership
--- PERCENT RANK ranks and gives value to each row with percentile, allows to limit to 0.1 (10%)
--- numeric shorthand to convert double float to a numeric value which can be rounded

WITH percentile AS (
    SELECT pl.web_name as player, ict_index, ROUND(PERCENT_RANK() OVER(ORDER BY pl.ict_index DESC)::numeric ,2) AS ict_percentile_rank, pl.selected_by_percent AS percent_owned
    FROM players AS pl)
    
SELECT player, ict_index, ict_percentile_rank, percent_owned
FROM percentile
WHERE percent_owned < 10 AND ict_percentile_rank < 0.1;