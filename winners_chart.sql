# Winners Chart

This query lists the top 3 ranks for each contest.  
If multiple contestants have the same score in a contest, they share the same rank.  
If multiple contestants share a rank, their names are listed in alphabetical order separated by commas.

---

## Problem Statement
We have a table `scoretable`:

| Name              | Type         | Description          |
|-------------------|--------------|----------------------|
| event_id          | int          | id of the event      |
| participant_name  | varchar(25)  | name of the participant |
| score             | float        | the score            |

We need to:
1. Consider only the **highest score** for each participant in each event.
2. Rank participants by score (ties share the same rank).
3. Return only the **top 3 ranks** for each event.
4. Display participant names for each rank alphabetically, separated by commas.
5. Order the output by `event_id`.

---

## SQL Query
```sql
WITH best_scores AS (
    SELECT
        event_id,
        participant_name,
        MAX(score) AS score
    FROM scoretable
    GROUP BY event_id, participant_name
),
ranked AS (
    SELECT
        event_id,
        participant_name,
        score,
        DENSE_RANK() OVER (PARTITION BY event_id ORDER BY score DESC) AS rnk
    FROM best_scores
)
SELECT
    event_id,
    GROUP_CONCAT(CASE WHEN rnk = 1 THEN participant_name END ORDER BY participant_name SEPARATOR ',') AS rank1_names,
    GROUP_CONCAT(CASE WHEN rnk = 2 THEN participant_name END ORDER BY participant_name SEPARATOR ',') AS rank2_names,
    GROUP_CONCAT(CASE WHEN rnk = 3 THEN participant_name END ORDER BY participant_name SEPARATOR ',') AS rank3_names
FROM ranked
WHERE rnk <= 3
GROUP BY event_id
ORDER BY event_id;
