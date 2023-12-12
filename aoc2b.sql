with recursive

puzzle (str_input) as (
	select str_input
	from puzzle_input
	where year=2015
		and day=2
)
,
line_separated (line, rest) as (
	select
		-- from start of string to first newline
		substr(puzzle.str_input, 0, instr(puzzle.str_input, char(10))), 
		-- the rest of the string, plus a newline at the end to prevent infinite recursion
		substr(puzzle.str_input, instr(puzzle.str_input, char(10)) + 1) || char(10)
	from puzzle
	union all
	select 
		-- from start of string to first newline
		substr(line_separated.rest, 0, instr(line_separated.rest, char(10))), 
		-- the rest of the string
		substr(line_separated.rest, instr(line_separated.rest, char(10)) + 1)
	from line_separated
	where length(line_separated.rest) != 0
)
,
expanded_puzzle (l, w, h) as (
	select  
		-- first_x = instr(line, 'x')
		--   gives the location of the first x
		-- second_x = instr(substr(line, instr(line,'x')+1), 'x') + instr(line, 'x')
		--   gives the location of the second x
		
		-- substr(line, 0, first_x) 
		cast(substr(line, 0, instr(line, 'x')) as numeric),
		-- substr(line, first_x + 1, second_x + first_x - 1)
		cast(substr(line, instr(line, 'x')+1, instr(substr(line, instr(line,'x')+1), 'x') + instr(line, 'x') - instr(line, 'x') - 1) as numeric),
		-- substr(line, second_x + 1)
		cast(substr(line, instr(substr(line, instr(line,'x')+1), 'x') + instr(line, 'x') + 1) as numeric)
		
	from line_separated
)

select sum(2*(l + w + h - max(l,w,h)) + l*w*h)
from expanded_puzzle

