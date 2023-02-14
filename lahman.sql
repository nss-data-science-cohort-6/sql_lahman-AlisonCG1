--1. Find all players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
--SELECT pe.playerid, pe.namelast, pe.namefirst, sc.schoolname, SUM(salary) AS salary
--FROM schools AS sc
--INNER JOIN collegeplaying AS cg
--ON sc.schoolid = cg.schoolid
--INNER JOIN people AS pe
--ON pe.playerid = cg.playerid
--LEFT JOIN salaries AS sl
--ON pe.playerid = sl.playerid
--WHERE schoolname LIKE '%Vanderbilt University%'
--GROUP BY pe.playerid, pe.namelast, pe.namefirst, pe.namegiven, sc.schoolname
--ORDER BY salary DESC;

--SELECT pe.playerid, pe.namegiven, SUM(salary) AS salary
--FROM schools AS sc
--INNER JOIN collegeplaying AS cg
--ON sc.schoolid = cg.schoolid
--INNER JOIN people AS pe
--ON pe.playerid = cg.playerid
--LEFT JOIN salaries AS sl
--ON pe.playerid = sl.playerid
--WHERE schoolname LIKE '%Vanderbilt University%'
--GROUP BY pe.playerid, pe.namegiven
--ORDER BY salary DESC;

--SELECT namefirst, 
--	   namelast, 
--	   SUM(salary)::numeric::money AS total_salary, 
--	   COUNT(DISTINCT yearid) AS years_played
--FROM people
--	 INNER JOIN salaries
--	 USING(playerid)
--WHERE playerid IN (
--SELECT 
--	playerid
--	FROM collegeplaying 
--		LEFT JOIN schools
--		USING(schoolid)
--	WHERE schoolid = 'vandy'
--)
--GROUP BY playerid, namefirst, namelast
--ORDER BY total_salary DESC;

--2.Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
--SELECT pe.playerid, fg.pos AS position,
--	CASE WHEN fg.pos = 'OF' THEN 'Outfield'
--	WHEN fg.pos = 'SS' OR fg.pos = '1B' OR fg.pos = '2B' OR fg.pos = '3B' THEN 'Infield' 
--	WHEN fg.pos = 'P' OR fg.pos = 'C' THEN 'Battery' END AS positioning,
--	SUM(po)
--FROM fielding AS fg
--INNER JOIN people AS pe
--ON pe.playerid = fg.playerid
--WHERE fg.yearid = 2016
--GROUP BY pe.playerid, fg.pos;


--3.Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends? (Hint: For this question, you might find it helpful to look at the generate_series function 

-- WITH decades AS (
-- 	SELECT * FROM generate_series(1870, 2021, 10)AS gen)
-- SELECT gen AS Decade, ROUND(AVG((so / g)), 2) AS avg_strikeouts_per_game
-- FROM pitching p
-- INNER JOIN decades
-- ON p.yearid BETWEEN gen AND gen+9
-- GROUP BY Decade;

--WITH decade_cte AS (
--	SELECT generate_series(1920, 2020, 10) AS beginning_of_decade
--)
--SELECT 
--	ROUND(SUM(hr) * 1.0 / (SUM(g) / 2), 2) AS hr_per_game,
--	ROUND(SUM(so) * 1.0 / (SUM(g) / 2), 2) AS so_per_game,
--	beginning_of_decade::text || 's' AS decade
--FROM teams
--INNER JOIN decade_cte
--ON yearid BETWEEN beginning_of_decade AND beginning_of_decade + 9
--WHERE yearid >= 1920
--GROUP BY decade
--ORDER BY decade;

--4.Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases. Report the players' names, number of stolen bases, number of attempts, and stolen base percentage.
-- SELECT success.nameFirst, success.nameLast, CAST(CAST(Success.stolen_bases AS DECIMAL(5, 2)) / success.total_attempts * 100 AS DECIMAL(5, 2)) AS success_stealing 
-- FROM(SELECT nameFirst, nameLast, SUM(sb) AS stolen_bases, SUM(sb + cs) AS total_attempts
-- 	FROM people
-- 	INNER JOIN batting AS B
-- 	USING(playerid)
-- 	WHERE sb >= 20 
-- 		AND yearid = 2016
-- 	GROUP BY nameFirst, nameLast) AS success
-- ORDER BY success_stealing DESC;

--5. From 1970 to 2016, what is the largest number of wins for a team that did not win the world series? 
--What is the smallest number of wins for a team that did win the world series? 
--Doing this will probably result in an unusually small number of wins for a world series champion; 

--SELECT *
--FROM (SELECT franchid AS franchise, yearid AS year,
--	CASE WHEN WSWin = 'Y' THEN 1 ELSE 0 END AS total_ws_wins,
--	W AS total_regular_wins
--FROM teams
--WHERE yearid BETWEEN 1970 AND 2016
--ORDER BY franchid) AS franch
--WHERE total_ws_wins = 0
--ORDER BY total_regular_wins DESC
--LIMIT 1;

--SELECT *
--FROM (SELECT yearid AS year,
--	  franchid AS franchise,
--	CASE WHEN WSWin = 'Y' THEN 1 ELSE 0 END AS total_ws_wins,
--	W AS total_regular_wins
--FROM teams AS t
--WHERE yearid BETWEEN 1970 AND 2016
--ORDER BY yearid) AS franchise
--WHERE total_ws_wins <> 0
--ORDER BY total_ws_wins
--LIMIT 1;


--Then redo your query, excluding the problem year. 
--How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?
--WITH wins_by_year AS (SELECT yearid, franchid, w AS wins, wswin as world_series_win,
--							RANK() OVER(PARTITION BY yearid ORDER BY w DESC) AS Rank_by_Total_Wins
--						FROM teams
--						WHERE yearid BETWEEN 1970 AND 2016
--						AND yearid <> 1981
--						ORDER BY yearid)
--SELECT yearid, franchid, world_series_win
--FROM wins_by_year
--WHERE wins_by_year.Rank_by_Total_Wins = 1 AND world_series_win = 'Y'
--ORDER BY yearid
 

--6.Which managers have won the TSN Manager of the Year award in both the National League (NL) 
--and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

-- SELECT manager.namefirst, manager.namelast, manager.playerid
-- FROM(
-- 	SELECT plp.namefirst, plp.namelast, 
-- 		   amgr.awardid, amgr.yearid, amgr.lgid, amgr.playerid, mgr.teamid
-- 	FROM AwardsManagers AS amgr
-- 	LEFT JOIN Managers AS mgr
-- 	USING(playerid)
-- 	LEFT JOIN people AS plp
-- 	USING(playerid)
-- 	WHERE amgr.awardid = 'TSN Manager of the Year' AND amgr.lgid = 'AL' OR amgr.lgid = 'NL') AS manager
-- GROUP BY manager.namefirst, manager.namelast, manager.playerid
-- HAVING COUNT(DISTINCT lgid) = 2;



-- SELECT TSN_WINNERS_Names.playerid, TSN_WINNERS_Names.nameFirst, TSN_WINNERS_Names.nameLast,TSN_WINNERS_Names.Team2, COUNT( DISTINCT lgid) AS lg_count
-- 		FROM (WITH TSN_WINNERS AS (SELECT awardsmanagers.yearid, awardsmanagers.playerid, awardsmanagers.lgid, managers.teamid AS Team, awardid
-- 				FROM awardsmanagers
-- 				INNER JOIN managers
-- 				ON awardsmanagers.playerid = managers.playerid AND awardsmanagers.yearid = managers.yearid
-- 				WHERE awardid LIKE '%TSN%')
-- 			SELECT TSN_WINNERS.yearid, TSN_WINNERS.playerid, nameFirst, nameLast, TSN_WINNERS.Team AS Team2, TSN_WINNERS.lgid
-- 			FROM people
-- 			INNER JOIN TSN_WINNERS
-- 			USING (playerid)) AS TSN_WINNERS_Names
-- 		WHERE TSN_WINNERS_Names.playerid IN ('leylaji99', 'johnsda02', 'coxbo01', 'larusto01')
-- 		GROUP BY TSN_WINNERS_Names.playerid, TSN_WINNERS_Names.nameFirst, TSN_WINNERS_Names.nameLast, TSN_WINNERS_Names.Team2
-- 		ORDER BY lg_count DESC

--7. Which pitcher was the least efficient in 2016 in terms of salary / strikeouts? Only consider pitchers who started at least 10 games (across all teams). 
--Note that pitchers often play for more than one team in a season, so be sure that you are counting all stats for each player.

-- SO / SALARY * 100 = PERCENTAGE OF EFFICIENCY. 
-- WHOEVER HAS THE SMALLEST NUMBER IS THE LEAST EFFICIENT 

-- WITH pitchers AS(
-- SELECT pg.playerid, pg.g, pg.teamid, SUM(so / salary) * 100 AS least_efficient
-- FROM pitching AS pg
-- LEFT JOIN salaries AS sl
-- USING(playerid)
-- WHERE pg.yearid = 2016
-- GROUP BY pg.playerid, pg.g, pg.teamid)

-- SELECT playerid, g, teamid, least_efficient
-- FROM pitchers 
-- ORDER BY g DESC;

--8.Find all players who have had at least 3000 career hits. 
--Report those players' names, total number of hits,
--and the year they were inducted into the hall of fame (If they were not inducted into the hall of fame, put a null in that column.) 
--Note that a player being inducted into the hall of fame is indicated by a 'Y' in the inducted column of the halloffame table.

--SELECT *
--FROM halloffame

WITH 
players_hits AS(
	SELECT playerid, SUM(h) AS sum_hits
	FROM Batting
	GROUP BY playerid),
players_hof AS(
	SELECT playerid, yearid, inducted
	FROM halloffame
	WHERE inducted = 'Y'),
players_name AS(
	SELECT ht.playerid, ht.sum_hits, plp.namefirst, plp.namelast, phof.yearid
	FROM players_hits AS ht
	LEFT JOIN people AS plp
 	USING(playerid)
	LEFT JOIN players_hof as phof
	USING(playerid)
)
SELECT players_name.playerid, players_name.namefirst, players_name.namelast, players_name.sum_hits, players_name.yearid
FROM players_hits
JOIN players_name ON players_hits.playerid = players_name.playerid 
WHERE players_hits.sum_hits >= 3000
ORDER BY players_hits.sum_hits DESC;


--SELECT *
--FROM Batting