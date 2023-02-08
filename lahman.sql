--1. Find all players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
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

--2.Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
--SELECT pe.playerid, fg.pos AS position,
--	CASE WHEN fg.pos = 'OF' THEN 'Outfield'
--	WHEN fg.pos = 'SS' OR fg.pos = '1B' OR fg.pos = '2B' OR fg.pos = '3B' THEN 'Infield' 
--	WHEN fg.pos = 'P' OR fg.pos = 'C' THEN 'Battery' END AS positioning
--FROM fielding AS fg
--INNER JOIN people AS pe
--ON pe.playerid = fg.playerid
--GROUP BY pe.playerid, fg.pos;



