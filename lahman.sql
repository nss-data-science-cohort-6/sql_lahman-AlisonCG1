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

--WITH decades AS (
--	SELECT * FROM generate_series(1870, 2021, 10)AS gen)
--SELECT gen AS Decade, ROUND(AVG((so / g)), 2) AS avg_strikeouts_per_game
--FROM pitching p
--INNER JOIN decades
--ON p.yearid BETWEEN gen AND gen+9
--GROUP BY Decade;

--4.Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases. Report the players' names, number of stolen bases, number of attempts, and stolen base percentage.
--SELECT success.nameFirst, success.nameLast, success.stolen_bases + success.caught_stealing / success.caught_stealing AS success_stealing
--FROM(SELECT nameFirst, nameLast, SUM(sb) AS stolen_bases, SUM(cs) AS caught_stealing
--	FROM people
--	INNER JOIN batting AS B
--	USING(playerid)
--	WHERE sb >= 20 
--		AND yearid = 2016
--	GROUP BY nameFirst, nameLast
--	ORDER BY stolen_bases DESC) AS success;

--5. From 1970 to 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion; determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
SELECT *
FROM teams

