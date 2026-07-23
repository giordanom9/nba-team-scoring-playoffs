# NBA Team Scoring vs. Playoff Qualification (2024–25)

Exploratory SQL analysis of team-level scoring averages, testing whether
playoff teams score more points per game than non-playoff teams.

## Question

Do teams that qualified for the playoffs average more points per game
than teams that did not?

## Data

Single table, `team_stats`: 31 rows — 30 NBA teams plus one "League
Average" summary row. All figures are per-game averages, not season
totals. Source: basketball-reference.com team stats export.

Playoff qualification is encoded in the team name: qualifying teams are
suffixed with an asterisk (`Boston Celtics*`).

Source data was loaded into SQLite from a basketball-reference CSV
export; column names were normalized to valid SQL identifiers
(`3P` → `p3`, `FG%` → `fg_pct`). The analysis below uses
non-destructive filtering — the source table was left unmodified.

## Method

1. **Load & verify** — confirmed row count (31).
2. **Profile** — checked for NULLs, duplicate team names, and
   implausible value ranges.
3. **Clean** — excluded the "League Average" row via `rk IS NOT NULL`
   rather than by string match, so the filter depends on data
   structure rather than exact spelling.
4. **Analyse** — compared mean points per game across the two groups.

## Findings

| Group | Teams | Avg. points per game |
|---|---|---|
| Playoff teams | 16 | 115.63 |
| Non-playoff teams | 14 | 111.76 |
| **Gap** | | **3.87 (3.46%)** |

Playoff teams do score more on average, but the relationship is weak.
Atlanta averaged 118.2 without qualifying — higher than 11 of the 16
teams that did. Orlando qualified at 105.4, the second-lowest figure
in the league.

## Limitations

This dataset contains points scored but not points allowed. Wins are
determined by point differential, so scoring alone cannot explain
playoff qualification. The finding is a correlation; no causal claim
is supported by this data. Testing it would require defensive metrics
(opponent points per game, defensive rating) joined to this table.

## Queries

See `queries.sql`.
