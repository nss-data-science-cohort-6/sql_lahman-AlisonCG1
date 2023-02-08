--1. Find all players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT *
FROM schools AS sc
INNER JOIN people AS pe
ON sc.schoolcity = pe.birthcity
LEFT JOIN salaries AS sl
ON pe.birthyear = sl.yearid
WHERE schoolname LIKE '%Vanderbilt University%'

SELECT namefirst,
		namelast,
		SUM(salary)
