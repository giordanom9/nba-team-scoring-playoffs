-- NBA Team Scoring vs. Playoff Qualification
-- Source table: team_stats (31 rows: 30 teams + 1 "League Average" row)
-- Engine: SQLite


-- =========================================================
-- 1. LOAD & VERIFY
-- =========================================================

-- Confirm the table loaded with the expected number of rows.

SELECT COUNT(*)
FROM team_stats;

-- Returns: 31
-- =========================================================
-- 2. PROFILING
-- =========================================================

-- 2a. Count rows with a missing rank.
-- The "League Average" row has no rank, so this identifies it structurally.

SELECT COUNT(*)
FROM team_stats
WHERE rk IS NULL;
-- Returns: 1

-- 2b. Check for duplicate team names.
-- HAVING filters groups after aggregation; WHERE cannot be used here.

SELECT team, COUNT(*)
FROM team_stats
GROUP BY team
HAVING COUNT(*) > 1;
-- Returns: 0 rows -> no duplicates

-- 2c. Sanity check on the value range of points per game.
-- Note: run across all 31 rows, including the League Average row.

SELECT MIN(pts), MAX(pts)
FROM team_stats;

-- Returns: 105.1 / 121.9 -> plausible for current NBA scoring levels

-- =========================================================
-- 3. CLEANING (non-destructive)
-- =========================================================

-- 3a. Exclude the "League Average" row.
-- Filtering on rk rather than on the team name avoids depending
-- on exact spelling.

SELECT *
FROM team_stats
WHERE rk IS NOT NULL;
-- Returns: 30 rows

-- 3b. Playoff teams. Qualification is encoded as a trailing asterisk
-- in the team name. In SQL, '*' is a literal character, not a wildcard.

SELECT team, pts
FROM team_stats
WHERE team LIKE '%*';
-- Returns: 16 rows

-- 3c. Non-playoff teams. The rk filter is required here: without it,
-- the League Average row would be included, since it has no asterisk.

SELECT team, pts
FROM team_stats
WHERE team NOT LIKE '%*'
  AND rk IS NOT NULL;

-- Returns: 14 rows -> 16 + 14 = 30, so no row is missing or double-counted


-- =========================================================
-- 4. ANALYSIS
-- =========================================================

-- 4a. Average points per game, playoff teams.

SELECT ROUND(AVG(pts), 2)
FROM team_stats
WHERE team LIKE '%*';

-- Returns: 115.63

-- 4b. Average points per game, non-playoff teams.

SELECT ROUND(AVG(pts), 2)
FROM team_stats
WHERE team NOT LIKE '%*'
  AND rk IS NOT NULL;
-- Returns: 111.76

-- Gap: 3.87 points per game (~3.46%).
-- See README.md for interpretation and limitations.
