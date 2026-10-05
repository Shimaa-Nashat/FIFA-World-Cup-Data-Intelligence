/* =========================================================
   FIFA World Cup Data Analytics
   Final Analytical SQL Queries
   SQL Server
   =========================================================

   FINAL ANALYTICAL SCOPE
   ---------------------------------------------------------
   Analytical scope: FIFA Men's World Cup only.
   Match/tournament-based queries use Tournaments.Gender = 'Men'.
   Q22-Q25 and Q29 are limited to available detailed 2026 men's
   match-performance data.
   ========================================================= */
/* Q1 — Highest-Capacity Stadiums in the Men's World Cup
   Question: Which stadiums used in the Men's World Cup have the highest recorded capacities?
   Visualization: Horizontal Bar Chart — Top 10 stadiums by recorded capacity
*/
SELECT   TOP 10 s.StadiumID,
                s.StadiumName,
                s.CityName,
                s.CountryName,
                s.StadiumCapacity
FROM     dbo.Stadiums AS s
         INNER JOIN
         dbo.Matches AS m
         ON s.StadiumID = m.StadiumID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
         AND s.StadiumCapacity IS NOT NULL
GROUP BY s.StadiumID, s.StadiumName, s.CityName, s.CountryName, s.StadiumCapacity
ORDER BY s.StadiumCapacity DESC;


GO
/*========================================================================================================= */
/* Q2 — Highest-Scoring Men's World Cup Matches
   Question: Which Men's World Cup matches had the highest total number of goals?
   Visualization: Horizontal Bar Chart — Top 10 highest-scoring matches
*/
SELECT   TOP 10 m.MatchID,
                YEAR(t.StartDate) AS TournamentYear,
                t.Gender,
                ht.TeamName AS HomeTeam,
                at.TeamName AS AwayTeam,
                m.HomeScore,
                m.AwayScore,
                m.HomeScore + m.AwayScore AS TotalGoals
FROM     dbo.Matches AS m
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Teams AS ht
         ON m.HomeTeamID = ht.TeamID
         INNER JOIN
         dbo.Teams AS at
         ON m.AwayTeamID = at.TeamID
WHERE    t.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
ORDER BY TotalGoals DESC, m.MatchID;


GO
/*========================================================================================================= */
/* Q3 — Highest-Attendance Men's World Cup Matches
   Question: Which recorded Men's World Cup matches attracted the largest crowds?
   Visualization: Horizontal Bar Chart — Top 10 matches by recorded attendance
*/
SELECT   TOP 10 ma.MatchID,
                YEAR(t.StartDate) AS TournamentYear,
                t.Gender,
                ht.TeamName AS HomeTeam,
                at.TeamName AS AwayTeam,
                ma.Attendance,
                ma.Source
FROM     dbo.Match_Attendance AS ma
         INNER JOIN
         dbo.Matches AS m
         ON ma.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Teams AS ht
         ON m.HomeTeamID = ht.TeamID
         INNER JOIN
         dbo.Teams AS at
         ON m.AwayTeamID = at.TeamID
WHERE    t.Gender = 'Men'
         AND ma.Attendance IS NOT NULL
ORDER BY ma.Attendance DESC, ma.MatchID;


GO
/*========================================================================================================= */
/* Q4 — Largest Goal Differences in the Men's World Cup
   Question: Which Men's World Cup matches had the largest scoring gap between the teams?
   Visualization: Horizontal Bar Chart — Largest goal differences
*/
SELECT   TOP 10 m.MatchID,
                YEAR(t.StartDate) AS TournamentYear,
                t.Gender,
                ht.TeamName AS HomeTeam,
                at.TeamName AS AwayTeam,
                m.HomeScore,
                m.AwayScore,
                ABS(m.HomeScore - m.AwayScore) AS GoalDifference
FROM     dbo.Matches AS m
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Teams AS ht
         ON m.HomeTeamID = ht.TeamID
         INNER JOIN
         dbo.Teams AS at
         ON m.AwayTeamID = at.TeamID
WHERE    t.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
ORDER BY GoalDifference DESC, m.MatchID;


GO
/*========================================================================================================= */
/* Q5 — High-Scoring Close Men's World Cup Matches
   Question: Which Men's World Cup matches combined a high total number of goals with a close final score?
   Visualization: Bar Chart — High-scoring close matches
*/
SELECT   TOP 10 m.MatchID,
                YEAR(t.StartDate) AS TournamentYear,
                t.Gender,
                ht.TeamName AS HomeTeam,
                at.TeamName AS AwayTeam,
                m.HomeScore,
                m.AwayScore,
                m.HomeScore + m.AwayScore AS TotalGoals,
                ABS(m.HomeScore - m.AwayScore) AS GoalDifference
FROM     dbo.Matches AS m
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Teams AS ht
         ON m.HomeTeamID = ht.TeamID
         INNER JOIN
         dbo.Teams AS at
         ON m.AwayTeamID = at.TeamID
WHERE    t.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
         AND m.HomeScore + m.AwayScore >= 4
         AND ABS(m.HomeScore - m.AwayScore) <= 2
ORDER BY TotalGoals DESC, GoalDifference ASC, m.MatchID;


GO
/*========================================================================================================= */
/* Q6 — Top Scoring Men's World Cup Players
   Question: Which players scored the most recorded goals in Men's World Cup tournaments?
   Visualization: Horizontal Bar Chart — Top 10 scorers
*/
SELECT   TOP 10 p.PlayerID,
                LTRIM(RTRIM(p.DisplayName)) AS PlayerName,
                COUNT(g.GoalID) AS TotalGoals
FROM     dbo.Goals AS g
         INNER JOIN
         dbo.Players AS p
         ON g.PlayerID = p.PlayerID
         INNER JOIN
         dbo.Matches AS m
         ON g.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
         AND ISNULL(g.OwnGoal, 0) = 0
GROUP BY p.PlayerID, p.DisplayName
ORDER BY TotalGoals DESC, PlayerName;


GO
/*========================================================================================================= */
/* Q7 — Matches per Men's World Cup Tournament
   Question: How many matches were played in each Men's World Cup tournament?
   Visualization: Column Chart — Matches by tournament
*/
SELECT   t.TournamentID,
         YEAR(t.StartDate) AS TournamentYear,
         t.Gender,
         COUNT(m.MatchID) AS TotalMatches
FROM     dbo.Tournaments AS t
         LEFT OUTER JOIN
         dbo.Matches AS m
         ON t.TournamentID = m.TournamentID
WHERE    t.Gender = 'Men'
GROUP BY t.TournamentID, YEAR(t.StartDate), t.Gender
ORDER BY TournamentYear;


GO
/*========================================================================================================= */
/* Q8 — Stadiums Hosting the Most Men's World Cup Matches
   Question: Which stadiums hosted the largest number of Men's World Cup matches?
   Visualization: Horizontal Bar Chart — Top stadiums by matches hosted
*/
SELECT   TOP 15 s.StadiumID,
                s.StadiumName,
                s.CityName,
                s.CountryName,
                COUNT(m.MatchID) AS MatchesHosted
FROM     dbo.Stadiums AS s
         INNER JOIN
         dbo.Matches AS m
         ON s.StadiumID = m.StadiumID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
GROUP BY s.StadiumID, s.StadiumName, s.CityName, s.CountryName
ORDER BY MatchesHosted DESC, s.StadiumID;


GO
/*========================================================================================================= */
/* Q9 — Most Active Men's World Cup Players
   Question: Which players recorded the most Men's World Cup match appearances?
   Visualization: Horizontal Bar Chart — Top 10 players by appearances
   Note: only rows with Appeared = 1 count (2026 data also lists unused squad members).
*/
SELECT   TOP 10 p.PlayerID,
                LTRIM(RTRIM(p.DisplayName)) AS PlayerName,
                COUNT(pa.AppearanceID) AS MatchAppearances
FROM     dbo.Player_Appearances AS pa
         INNER JOIN
         dbo.Players AS p
         ON pa.PlayerID = p.PlayerID
         INNER JOIN
         dbo.Matches AS m
         ON pa.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
         AND pa.Appeared = 1
GROUP BY p.PlayerID, p.DisplayName
ORDER BY MatchAppearances DESC, PlayerName;


GO
/*========================================================================================================= */
/* Q10 — Teams with Most Men's World Cup Wins
   Question: Which teams recorded the most wins in Men's World Cup matches?
   Visualization: Horizontal Bar Chart — Teams by total wins
*/
SELECT   t.TeamID,
         t.TeamName,
         COUNT(*) AS TotalWins
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Teams AS t
         ON ta.TeamID = t.TeamID
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS tr
         ON m.TournamentID = tr.TournamentID
WHERE    tr.Gender = 'Men'
         AND ta.Result = 'win'
GROUP BY t.TeamID, t.TeamName
ORDER BY TotalWins DESC, t.TeamName;

GO
/*========================================================================================================= */
/* Q11 — Players with Most Men's World Cup Bookings
   Question: Which players received the most recorded bookings in the Men's World Cup?
   Visualization: Horizontal Bar Chart — Players with most bookings
*/
SELECT   TOP 10 p.PlayerID,
                LTRIM(RTRIM(p.DisplayName)) AS PlayerName,
                COUNT(b.BookingID) AS TotalBookings
FROM     dbo.Bookings AS b
         INNER JOIN
         dbo.Players AS p
         ON b.PlayerID = p.PlayerID
         INNER JOIN
         dbo.Matches AS m
         ON b.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
GROUP BY p.PlayerID, p.DisplayName
ORDER BY TotalBookings DESC, PlayerName;


GO
/*========================================================================================================= */
/* Q12 — Most Frequent Passing Connections in the Men's World Cup
   Question: Which player-to-player passing connections occurred most frequently in Men's World Cup matches?
   Visualization: Passing Network Graph
*/
SELECT   TOP 20 pne.FromPlayerID,
                LTRIM(RTRIM(fp.DisplayName)) + ' -> ' + LTRIM(RTRIM(tp.DisplayName)) AS PassingConnection,
                pne.ToPlayerID,
                SUM(pne.PassCount) AS TotalPasses
FROM     dbo.Passing_Network_Edges AS pne
         INNER JOIN
         dbo.Players AS fp
         ON pne.FromPlayerID = fp.PlayerID
         INNER JOIN
         dbo.Players AS tp
         ON pne.ToPlayerID = tp.PlayerID
         INNER JOIN
         dbo.Matches AS m
         ON pne.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
WHERE    t.Gender = 'Men'
GROUP BY pne.FromPlayerID, fp.DisplayName, pne.ToPlayerID, tp.DisplayName
ORDER BY TotalPasses DESC, pne.FromPlayerID, pne.ToPlayerID;


GO
/*========================================================================================================= */
/* Q13 — Average Recorded Attendance by Men's World Cup Team
   Question: What is the average recorded attendance for Men's World Cup matches involving each team?
   Visualization: Horizontal Bar Chart — Average recorded attendance by team
*/
SELECT   t.TeamID,
         t.TeamName,
         COUNT(DISTINCT m.MatchID) AS MatchesWithAttendance,
         AVG(CAST (ma.Attendance AS DECIMAL (12, 2))) AS AverageAttendance
FROM     dbo.Teams AS t
         INNER JOIN
         dbo.Team_Appearances AS ta
         ON t.TeamID = ta.TeamID
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS tr
         ON m.TournamentID = tr.TournamentID
         INNER JOIN
         dbo.Match_Attendance AS ma
         ON m.MatchID = ma.MatchID
WHERE    tr.Gender = 'Men'
         AND ma.Attendance IS NOT NULL
GROUP BY t.TeamID, t.TeamName
HAVING   COUNT(DISTINCT m.MatchID) >= 3
ORDER BY AverageAttendance DESC, t.TeamName;


GO
/*========================================================================================================= */
/* Q14 — Recorded Attendance vs Stadium Capacity in the Men's World Cup
   Question: How do recorded Men's World Cup attendance values compare with recorded stadium capacities?
   Visualization: Scatter Plot — Average attendance vs stadium capacity
*/
SELECT   s.StadiumID,
         s.StadiumName,
         s.StadiumCapacity,
         COUNT(ma.MatchID) AS MatchesWithAttendance,
         AVG(CAST (ma.Attendance AS DECIMAL (12, 2))) AS AverageRecordedAttendance,
         AVG(100.0 * ma.Attendance / NULLIF (s.StadiumCapacity, 0)) AS AverageRecordedAttendanceToCapacityPercent
FROM     dbo.Stadiums AS s
         INNER JOIN
         dbo.Matches AS m
         ON s.StadiumID = m.StadiumID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Match_Attendance AS ma
         ON m.MatchID = ma.MatchID
WHERE    t.Gender = 'Men'
         AND s.StadiumCapacity IS NOT NULL
         AND s.StadiumCapacity > 0
         AND ma.Attendance IS NOT NULL
GROUP BY s.StadiumID, s.StadiumName, s.StadiumCapacity
HAVING   COUNT(ma.MatchID) >= 2
ORDER BY AverageRecordedAttendanceToCapacityPercent DESC;


GO
/*========================================================================================================= */
/* Q15 — Men's World Cup Winners and Tournament Size
   Question: Who won each Men's World Cup tournament, and how large was it in terms of recorded matches?
   Visualization: Men's World Cup Tournament Timeline
*/
SELECT   t.TournamentID,
         YEAR(t.StartDate) AS TournamentYear,
         t.Gender,
         t.HostCountry,
         w.TeamName AS WinnerTeam,
         COUNT(m.MatchID) AS TotalMatches
FROM     dbo.Tournaments AS t
         LEFT OUTER JOIN
         dbo.Teams AS w
         ON t.WinnerTeamID = w.TeamID
         LEFT OUTER JOIN
         dbo.Matches AS m
         ON t.TournamentID = m.TournamentID
WHERE    t.Gender = 'Men'
GROUP BY t.TournamentID, YEAR(t.StartDate), t.Gender, t.HostCountry, w.TeamName
ORDER BY TournamentYear;


GO
/*========================================================================================================= */
/* Q16 — Total Goals by Men's World Cup Tournament
   Question: How many goals were scored in each Men's World Cup tournament?
   Visualization: Column Chart — Total goals by tournament
*/
SELECT   t.TournamentID,
         YEAR(t.StartDate) AS TournamentYear,
         t.Gender,
         COUNT(m.MatchID) AS TotalMatches,
         SUM(m.HomeScore + m.AwayScore) AS TotalGoals
FROM     dbo.Tournaments AS t
         INNER JOIN
         dbo.Matches AS m
         ON t.TournamentID = m.TournamentID
WHERE    t.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
GROUP BY t.TournamentID, YEAR(t.StartDate), t.Gender
ORDER BY TournamentYear;


GO
/*========================================================================================================= */
/* Q17 — Average Goals per Match in the Men's World Cup
   Question: How has the average number of goals per match changed across Men's World Cup tournaments?
   Visualization: Line Chart — Average goals per match over time
*/
SELECT   t.TournamentID,
         YEAR(t.StartDate) AS TournamentYear,
         t.Gender,
         COUNT(m.MatchID) AS TotalMatches,
         AVG(CAST (m.HomeScore + m.AwayScore AS DECIMAL (10, 2))) AS AverageGoalsPerMatch
FROM     dbo.Tournaments AS t
         INNER JOIN
         dbo.Matches AS m
         ON t.TournamentID = m.TournamentID
WHERE    t.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
GROUP BY t.TournamentID, YEAR(t.StartDate), t.Gender
ORDER BY TournamentYear;


GO
/*========================================================================================================= */
/* Q18 — Average Recorded Attendance by Men's World Cup
   Question: How does average recorded attendance vary across Men's World Cup tournaments?
   Visualization: Line Chart — Average attendance over time
*/
SELECT   t.TournamentID,
         YEAR(t.StartDate) AS TournamentYear,
         t.Gender,
         COUNT(ma.MatchID) AS AttendanceRecords,
         AVG(CAST (ma.Attendance AS DECIMAL (12, 2))) AS AverageAttendance
FROM     dbo.Tournaments AS t
         INNER JOIN
         dbo.Matches AS m
         ON t.TournamentID = m.TournamentID
         INNER JOIN
         dbo.Match_Attendance AS ma
         ON m.MatchID = ma.MatchID
WHERE    t.Gender = 'Men'
         AND ma.Attendance IS NOT NULL
GROUP BY t.TournamentID, YEAR(t.StartDate), t.Gender
HAVING   COUNT(ma.MatchID) > 0
ORDER BY TournamentYear;


GO
/*========================================================================================================= */
/* Q19 — Total Goals by Men's World Cup Team
   Question: Which teams scored the most goals across their recorded Men's World Cup matches?
   Visualization: Horizontal Bar Chart — Team goals
*/
SELECT   t.TeamID,
         t.TeamName,
         COUNT(ta.MatchID) AS MatchesPlayed,
         SUM(CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END) AS TotalGoals,
         CAST (SUM(CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END) * 1.0 / NULLIF (COUNT(ta.MatchID), 0) AS DECIMAL (10, 2)) AS GoalsPerMatch
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Teams AS t
         ON ta.TeamID = t.TeamID
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS tr
         ON m.TournamentID = tr.TournamentID
WHERE    tr.Gender = 'Men'
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
GROUP BY t.TeamID, t.TeamName
ORDER BY TotalGoals DESC, t.TeamName;


GO
/*========================================================================================================= */
/* Q20 — Total Bookings by Men's World Cup Team
   Question: Which teams accumulated the most recorded bookings in the Men's World Cup?
   Visualization: Bar Chart — Bookings by team
*/
WITH     TeamMatches
AS       (SELECT   ta.TeamID,
                   COUNT(*) AS MatchesPlayed
          FROM     dbo.Team_Appearances AS ta
                   INNER JOIN
                   dbo.Matches AS m
                   ON ta.MatchID = m.MatchID
                   INNER JOIN
                   dbo.Tournaments AS tr
                   ON m.TournamentID = tr.TournamentID
          WHERE    tr.Gender = 'Men'
          GROUP BY ta.TeamID),
         TeamBookings
AS       (SELECT   b.TeamID,
                   COUNT(*) AS TotalBookings
          FROM     dbo.Bookings AS b
                   INNER JOIN
                   dbo.Matches AS m
                   ON b.MatchID = m.MatchID
                   INNER JOIN
                   dbo.Tournaments AS tr
                   ON m.TournamentID = tr.TournamentID
          WHERE    tr.Gender = 'Men'
          GROUP BY b.TeamID)
SELECT   t.TeamID,
         t.TeamName,
         tm.MatchesPlayed,
         COALESCE (tb.TotalBookings, 0) AS TotalBookings,
         CAST (COALESCE (tb.TotalBookings, 0) * 1.0 / NULLIF (tm.MatchesPlayed, 0) AS DECIMAL (10, 2)) AS BookingsPerMatch
FROM     dbo.Teams AS t
         INNER JOIN
         TeamMatches AS tm
         ON t.TeamID = tm.TeamID
         LEFT OUTER JOIN
         TeamBookings AS tb
         ON t.TeamID = tb.TeamID
ORDER BY TotalBookings DESC, t.TeamName;


GO
/*========================================================================================================= */
/* Q21 — Total Substitution Records by Men's World Cup Team
   Question: Which teams had the highest number of recorded substitution events in the Men's World Cup?
   Visualization: Bar Chart — Substitution events by team
*/
WITH     TeamMatches
AS       (SELECT   ta.TeamID,
                   COUNT(*) AS MatchesPlayed
          FROM     dbo.Team_Appearances AS ta
                   INNER JOIN
                   dbo.Matches AS m
                   ON ta.MatchID = m.MatchID
                   INNER JOIN
                   dbo.Tournaments AS tr
                   ON m.TournamentID = tr.TournamentID
          WHERE    tr.Gender = 'Men'
          GROUP BY ta.TeamID),
         TeamSubstitutions
AS       (SELECT   s.TeamID,
                   COUNT(*) AS TotalSubstitutionRecords
          FROM     dbo.Substitutions AS s
                   INNER JOIN
                   dbo.Matches AS m
                   ON s.MatchID = m.MatchID
                   INNER JOIN
                   dbo.Tournaments AS tr
                   ON m.TournamentID = tr.TournamentID
          WHERE    tr.Gender = 'Men'
          GROUP BY s.TeamID)
SELECT   t.TeamID,
         t.TeamName,
         tm.MatchesPlayed,
         COALESCE (ts.TotalSubstitutionRecords, 0) AS TotalSubstitutionRecords,
         CAST (COALESCE (ts.TotalSubstitutionRecords, 0) * 1.0 / NULLIF (tm.MatchesPlayed, 0) AS DECIMAL (10, 2)) AS SubstitutionsPerMatch
FROM     dbo.Teams AS t
         INNER JOIN
         TeamMatches AS tm
         ON t.TeamID = tm.TeamID
         LEFT OUTER JOIN
         TeamSubstitutions AS ts
         ON t.TeamID = ts.TeamID
ORDER BY TotalSubstitutionRecords DESC, t.TeamName;


GO
/* Q22 — Possession by Match Result
   Question: How does team possession differ between wins, draws, and losses in available detailed 2026 men's matches?
   Visualization: Box Plot — Possession by result
*/
SELECT   YEAR(t.StartDate) AS TournamentYear,
         ta.Result,
         m.MatchID,
         ta.TeamID,
         tm.TeamName,
         s.ValueNumeric AS PossessionPercentage
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Team_Match_Stats AS s
         ON s.MatchID = ta.MatchID
            AND s.TeamID = ta.TeamID
            AND s.Metric = 'Possession'
         INNER JOIN
         dbo.Teams AS tm
         ON ta.TeamID = tm.TeamID
WHERE    t.Gender = 'Men'
         AND YEAR(t.StartDate) = 2026
         AND s.TeamID IS NOT NULL
         AND s.ValueNumeric IS NOT NULL
ORDER BY CASE ta.Result WHEN 'win' THEN 1 WHEN 'draw' THEN 2 WHEN 'lose' THEN 3 ELSE 4 END, m.MatchID, ta.TeamID;


GO
/*========================================================================================================= */
/* Q23 — xG and Actual Goals by Match Result
   Question: How do expected goals and actual goals differ between winning, drawing, and losing teams?
   Visualization: Grouped Bar Chart — Average xG vs Average goals
*/
SELECT   ta.Result,
         COUNT(*) AS TeamMatchRecords,
         AVG(s.ValueNumeric) AS AverageXG,
         AVG(CAST (CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END AS DECIMAL (10, 2))) AS AverageActualGoals
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Team_Match_Stats AS s
         ON s.MatchID = ta.MatchID
            AND s.TeamID = ta.TeamID
            AND s.Metric = 'xG (Expected Goals)'
WHERE    t.Gender = 'Men'
         AND YEAR(t.StartDate) = 2026
         AND s.TeamID IS NOT NULL
         AND s.ValueNumeric IS NOT NULL
         AND m.HomeScore IS NOT NULL
         AND m.AwayScore IS NOT NULL
GROUP BY ta.Result
ORDER BY CASE ta.Result WHEN 'win' THEN 1 WHEN 'draw' THEN 2 WHEN 'lose' THEN 3 ELSE 4 END;


GO
/*========================================================================================================= */
/* Q24 — Pass Completion by Match Result
   Question: How does pass-completion efficiency differ between wins, draws, and losses in available detailed 2026 men's matches?
   Visualization: Box Plot — Pass completion % by result
*/
SELECT   YEAR(t.StartDate) AS TournamentYear,
         ta.Result,
         m.MatchID,
         ta.TeamID,
         tm.TeamName,
         s.ValueNumeric AS PassCompletionPercentage
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Team_Match_Stats AS s
         ON s.MatchID = ta.MatchID
            AND s.TeamID = ta.TeamID
            AND s.Metric = 'Pass Completion %'
         INNER JOIN
         dbo.Teams AS tm
         ON ta.TeamID = tm.TeamID
WHERE    t.Gender = 'Men'
         AND YEAR(t.StartDate) = 2026
         AND s.TeamID IS NOT NULL
         AND s.ValueNumeric IS NOT NULL
ORDER BY CASE ta.Result WHEN 'win' THEN 1 WHEN 'draw' THEN 2 WHEN 'lose' THEN 3 ELSE 4 END, m.MatchID, ta.TeamID;


GO
/*========================================================================================================= */
/* Q25 — Forced Turnovers by Match Result
   Question: How do forced turnovers differ between winning, drawing, and losing teams?
   Visualization: Box Plot — Forced turnovers by result
*/
SELECT   YEAR(t.StartDate) AS TournamentYear,
         ta.Result,
         m.MatchID,
         ta.TeamID,
         tm.TeamName,
         s.ValueNumeric AS ForcedTurnovers
FROM     dbo.Team_Appearances AS ta
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS t
         ON m.TournamentID = t.TournamentID
         INNER JOIN
         dbo.Team_Match_Stats AS s
         ON s.MatchID = ta.MatchID
            AND s.TeamID = ta.TeamID
            AND s.Metric = 'Forced Turnovers'
         INNER JOIN
         dbo.Teams AS tm
         ON ta.TeamID = tm.TeamID
WHERE    t.Gender = 'Men'
         AND YEAR(t.StartDate) = 2026
         AND s.TeamID IS NOT NULL
         AND s.ValueNumeric IS NOT NULL
ORDER BY CASE ta.Result WHEN 'win' THEN 1 WHEN 'draw' THEN 2 WHEN 'lose' THEN 3 ELSE 4 END, m.MatchID, ta.TeamID;


GO
/*========================================================================================================= */
/* Q26 — Men's World Cup Team Win Rate
   Question: What is the win rate of each team across its recorded Men's World Cup matches?
   Scope: At least 10 recorded Men's World Cup appearances.
   Visualization: Horizontal Bar Chart — Men's World Cup team win rate
*/
SELECT   t.TeamID,
         t.TeamName,
         COUNT(*) AS TotalMatches,
         SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) AS Wins,
         SUM(CASE WHEN ta.Result = 'draw' THEN 1 ELSE 0 END) AS Draws,
         SUM(CASE WHEN ta.Result = 'lose' THEN 1 ELSE 0 END) AS Losses,
         CAST (100.0 * SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) / NULLIF (COUNT(*), 0) AS DECIMAL (10, 2)) AS WinRatePercentage
FROM     dbo.Teams AS t
         INNER JOIN
         dbo.Team_Appearances AS ta
         ON t.TeamID = ta.TeamID
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS tr
         ON m.TournamentID = tr.TournamentID
WHERE    tr.Gender = 'Men'
GROUP BY t.TeamID, t.TeamName
HAVING   COUNT(*) >= 10
ORDER BY WinRatePercentage DESC, t.TeamName;


GO
/*========================================================================================================= */
/* Q27 — Ranked Top Men's World Cup Scorers
   Question: How are players ranked according to their number of recorded non-own goals in the Men's World Cup?
   Visualization: Ranked Horizontal Bar Chart
*/
WITH     PlayerGoals
AS       (SELECT   p.PlayerID,
                   LTRIM(RTRIM(p.DisplayName)) AS PlayerName,
                   COUNT(g.GoalID) AS TotalGoals
          FROM     dbo.Goals AS g
                   INNER JOIN
                   dbo.Players AS p
                   ON g.PlayerID = p.PlayerID
                   INNER JOIN
                   dbo.Matches AS m
                   ON g.MatchID = m.MatchID
                   INNER JOIN
                   dbo.Tournaments AS t
                   ON m.TournamentID = t.TournamentID
          WHERE    t.Gender = 'Men'
                   AND ISNULL(g.OwnGoal, 0) = 0
          GROUP BY p.PlayerID, p.DisplayName)
SELECT   PlayerID,
         PlayerName,
         TotalGoals,
         RANK() OVER (ORDER BY TotalGoals DESC) AS GoalRank
FROM     PlayerGoals
ORDER BY GoalRank, PlayerName;


GO
/*========================================================================================================= */
/* Q28 — Men's World Cup Tournament Goals vs Overall Men's Average
   Question: Which Men's World Cup tournaments scored above or below the overall Men's World Cup average goals per match?
   Visualization: Diverging Bar Chart — Difference from overall Men's average
*/
WITH     TournamentAverages
AS       (SELECT   t.TournamentID,
                   YEAR(t.StartDate) AS TournamentYear,
                   COUNT(m.MatchID) AS TotalMatches,
                   AVG(CAST (m.HomeScore + m.AwayScore AS DECIMAL (10, 2))) AS TournamentAverageGoals
          FROM     dbo.Tournaments AS t
                   INNER JOIN
                   dbo.Matches AS m
                   ON t.TournamentID = m.TournamentID
          WHERE    t.Gender = 'Men'
                   AND m.HomeScore IS NOT NULL
                   AND m.AwayScore IS NOT NULL
          GROUP BY t.TournamentID, YEAR(t.StartDate)),
         OverallMenAverage
AS       (SELECT AVG(CAST (m.HomeScore + m.AwayScore AS DECIMAL (10, 2))) AS OverallMenAverageGoals
          FROM   dbo.Tournaments AS t
                 INNER JOIN
                 dbo.Matches AS m
                 ON t.TournamentID = m.TournamentID
          WHERE  t.Gender = 'Men'
                 AND m.HomeScore IS NOT NULL
                 AND m.AwayScore IS NOT NULL)
SELECT   ta.TournamentID,
         ta.TournamentYear,
         ta.TotalMatches,
         ta.TournamentAverageGoals,
         oma.OverallMenAverageGoals,
         ta.TournamentAverageGoals - oma.OverallMenAverageGoals AS DifferenceFromOverallMenAverage
FROM     TournamentAverages AS ta CROSS JOIN OverallMenAverage AS oma
ORDER BY ta.TournamentYear;


GO
/*========================================================================================================= */
/* Q29 — Average xG vs Average Actual Goals by Men's World Cup Team — Detailed 2026 Data
   Question: How closely did expected goals align with actual goals for teams in available detailed 2026 men's matches?
   Visualization: Scatter Plot — Average xG per match vs average goals per match
*/
WITH     DetailedTeamMatchXG
AS       (SELECT DISTINCT s.MatchID,
                          s.TeamID,
                          s.ValueNumeric AS MatchXG,
                          CASE WHEN m.HomeTeamID = s.TeamID THEN m.HomeScore ELSE m.AwayScore END AS MatchActualGoals
          FROM   dbo.Team_Match_Stats AS s
                 INNER JOIN
                 dbo.Matches AS m
                 ON s.MatchID = m.MatchID
                 INNER JOIN
                 dbo.Tournaments AS t
                 ON m.TournamentID = t.TournamentID
          WHERE  s.Metric = 'xG (Expected Goals)'
                 AND s.TeamID IS NOT NULL
                 AND s.ValueNumeric IS NOT NULL
                 AND t.Gender = 'Men'
                 AND YEAR(t.StartDate) = 2026
                 AND m.HomeScore IS NOT NULL
                 AND m.AwayScore IS NOT NULL)
SELECT   tm.TeamID,
         tm.TeamName,
         COUNT(*) AS MatchesWithXG,
         AVG(dtm.MatchXG) AS AverageXGPerMatch,
         AVG(CAST (dtm.MatchActualGoals AS DECIMAL (10, 2))) AS AverageActualGoalsPerMatch,
         AVG(dtm.MatchXG - CAST (dtm.MatchActualGoals AS DECIMAL (10, 2))) AS AverageXGMinusActualGoals
FROM     DetailedTeamMatchXG AS dtm
         INNER JOIN
         dbo.Teams AS tm
         ON dtm.TeamID = tm.TeamID
GROUP BY tm.TeamID, tm.TeamName
ORDER BY AverageXGMinusActualGoals DESC, tm.TeamName;


GO
/*========================================================================================================= */
/* Q30 — Highest-Scoring Team per Men's World Cup Tournament
   Question: Which team or teams scored the most goals in each Men's World Cup tournament?
   Visualization: Men's World Cup Tournament Heatmap / Timeline
*/
WITH     TeamTournamentGoals
AS       (SELECT   t.TournamentID,
                   YEAR(t.StartDate) AS TournamentYear,
                   ta.TeamID,
                   SUM(CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END) AS TotalGoals
          FROM     dbo.Tournaments AS t
                   INNER JOIN
                   dbo.Matches AS m
                   ON t.TournamentID = m.TournamentID
                   INNER JOIN
                   dbo.Team_Appearances AS ta
                   ON m.MatchID = ta.MatchID
          WHERE    t.Gender = 'Men'
                   AND m.HomeScore IS NOT NULL
                   AND m.AwayScore IS NOT NULL
          GROUP BY t.TournamentID, YEAR(t.StartDate), ta.TeamID),
         RankedTeams
AS       (SELECT TournamentID,
                 TournamentYear,
                 TeamID,
                 TotalGoals,
                 RANK() OVER (PARTITION BY TournamentID ORDER BY TotalGoals DESC) AS TeamRank
          FROM   TeamTournamentGoals)
SELECT   rt.TournamentID,
         rt.TournamentYear,
         tm.TeamName,
         rt.TotalGoals,
         rt.TeamRank
FROM     RankedTeams AS rt
         INNER JOIN
         dbo.Teams AS tm
         ON rt.TeamID = tm.TeamID
WHERE    rt.TeamRank = 1
ORDER BY rt.TournamentYear, tm.TeamName;


GO
/*========================================================================================================= */
/* Q31 — FIFA Ranking Before the 2026 Men's World Cup vs Tournament Performance
   Question: What was each team's official FIFA ranking right before the 2026 World Cup
             (2026-06-11 release), and how did the team perform in the tournament?
   Visualization: Scatter Plot — Pre-tournament rank vs tournament win rate
*/
WITH     TeamTournamentPerformance
AS       (SELECT   ta.TeamID,
                   COUNT(*) AS TotalMatches,
                   SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) AS Wins,
                   CAST (100.0 * SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) / NULLIF (COUNT(*), 0) AS DECIMAL (10, 2)) AS WinRate
          FROM     dbo.Tournaments AS t
                   INNER JOIN
                   dbo.Matches AS m
                   ON t.TournamentID = m.TournamentID
                   INNER JOIN
                   dbo.Team_Appearances AS ta
                   ON m.MatchID = ta.MatchID
          WHERE    t.Gender = 'Men'
                   AND t.TournamentYear = 2026
          GROUP BY ta.TeamID)
SELECT   tm.TeamName,
         fr.RankingDate,
         fr.RankPosition AS FIFA_PreTournamentRank,
         fr.Points AS FIFA_Points,
         tp.TotalMatches,
         tp.Wins,
         tp.WinRate
FROM     TeamTournamentPerformance AS tp
         INNER JOIN
         dbo.FIFA_Rankings AS fr
         ON fr.WorldCupTeamID = tp.TeamID
            AND fr.RankingDate = '2026-06-11'
         INNER JOIN
         dbo.Teams AS tm
         ON tm.TeamID = tp.TeamID
ORDER BY fr.RankPosition, tm.TeamName;

GO
/*========================================================================================================= */
/* Q32 — Analytical Men's World Cup Team Performance View
   Question: Can we create one reusable analytical view that summarizes a team's overall Men's World Cup performance?
   Visualization: Men's World Cup Team Performance Dashboard
*/
CREATE OR ALTER VIEW dbo.vw_Team_WorldCup_Performance
AS
SELECT   t.TeamID,
         t.TeamName,
         COUNT(ta.MatchID) AS TotalMatches,
         SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) AS Wins,
         SUM(CASE WHEN ta.Result = 'draw' THEN 1 ELSE 0 END) AS Draws,
         SUM(CASE WHEN ta.Result = 'lose' THEN 1 ELSE 0 END) AS Losses,
         COALESCE (SUM(CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END), 0) AS TotalGoals,
         CAST (100.0 * SUM(CASE WHEN ta.Result = 'win' THEN 1 ELSE 0 END) / NULLIF (COUNT(ta.MatchID), 0) AS DECIMAL (10, 2)) AS WinRatePercentage,
         CAST (COALESCE (SUM(CASE WHEN m.HomeTeamID = ta.TeamID THEN m.HomeScore ELSE m.AwayScore END), 0) * 1.0 / NULLIF (COUNT(ta.MatchID), 0) AS DECIMAL (10, 2)) AS AverageGoalsPerMatch
FROM     dbo.Teams AS t
         INNER JOIN
         dbo.Team_Appearances AS ta
         ON t.TeamID = ta.TeamID
         INNER JOIN
         dbo.Matches AS m
         ON ta.MatchID = m.MatchID
         INNER JOIN
         dbo.Tournaments AS tr
         ON m.TournamentID = tr.TournamentID
WHERE    tr.Gender = 'Men'
GROUP BY t.TeamID, t.TeamName;


GO
/*========================================================================================================= */
/* Example Usage — Men's World Cup Team Performance View */
SELECT   TeamID,
         TeamName,
         TotalMatches,
         Wins,
         Draws,
         Losses,
         TotalGoals,
         WinRatePercentage,
         AverageGoalsPerMatch
FROM     dbo.vw_Team_WorldCup_Performance
WHERE    TotalMatches > 0
ORDER BY WinRatePercentage DESC, TotalGoals DESC, TeamName;