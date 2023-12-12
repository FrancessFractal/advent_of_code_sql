with recursive

puzzle (str_input) as (
	select str_input
	from puzzle_input
	where year=2015
		and day=6
)
,
line_separated (line_no, line, rest) as (
	select
		1,
		-- from start of string to first newline
		substr(puzzle.str_input, 0, instr(puzzle.str_input, char(10))), 
		-- the rest of the string, plus a newline at the end to prevent infinite recursion
		substr(puzzle.str_input, instr(puzzle.str_input, char(10)) + 1) || char(10)
	from puzzle
	union all
	select 
		line_separated.line_no + 1,
		-- from start of string to first newline
		substr(line_separated.rest, 0, instr(line_separated.rest, char(10))), 
		-- the rest of the string
		substr(line_separated.rest, instr(line_separated.rest, char(10)) + 1)
	from line_separated
	where length(line_separated.rest) != 0
)
,
split1  as (
	select line_no,
	
	substr(line, 0, 
		case
		when instr(line, 'toggle ')
		then 7
		when instr(line, 'turn off')
		then 9
		when instr(line, 'turn on')
		then 8
		end	
	) as instruction,
	
	substr(
		line, 
		
		case
		when instr(line, 'toggle ')
		then 7
		when instr(line, 'turn off')
		then 9
		when instr(line, 'turn on')
		then 8
		end,
		
		case
		when instr(line, 'toggle ')
		then instr(line, ' through ') - 7
		when instr(line, 'turn off')
		then instr(line, ' through ') - 9
		when instr(line, 'turn on')
		then instr(line, ' through ') - 8
		end
		
	) as lower_left,
	
	substr(line, instr(line, ' through ') + 9) as upper_right
		
	from line_separated
)
,
expanded_puzzle (line_no, instruction, ll_x, ll_y, ur_x, ur_y) as (
	select line_no,
		instruction,
		cast(substr(lower_left, 0, instr(lower_left, ',')) as numeric),
		cast(substr(lower_left, instr(lower_left, ',') + 1) as numeric),
		cast(substr(upper_right, 0, instr(upper_right, ',')) as numeric),
		cast(substr(upper_right, instr(upper_right, ',') + 1) as numeric)
		
	from split1
)
,
x_expansion as (
	select x
	from (
		select ll_x as x
		from expanded_puzzle
		
		union all
		
		select ur_x as x
		from expanded_puzzle
		
		union all select 0
		union all select 1000
	) as all_x
	group by x
	order by x
),
y_expansion as (
	select y
	from (
		select ll_y as y
		from expanded_puzzle
		
		union all
		
		select ur_y as y
		from expanded_puzzle
		
		union all select 0
		union all select 1000
	) as all_y
	group by y
	order by y
)
,
x_ranges (low, high) as (
	select a.x, min(b.x)-1
	from x_expansion as a
	join x_expansion as b
	on a.x < b.x
	group by a.x
)
,
y_ranges (low, high) as (
	select a.y, min(b.y)-1
	from y_expansion as a
	join y_expansion as b
	on a.y < b.y
	group by a.y
)
,
-- we now have a grid of rectangles, all the largest poosible size, in which all contained lights always turn on/off together
grid as (
	select x_ranges.low as x_low, x_ranges.high as x_high, y_ranges.low as y_low, y_ranges.high as y_high,
	(X_ranges.high - x_ranges.low + 1) * (y_ranges.high - y_ranges.low + 1) as num_lights
	from x_ranges, y_ranges	
)
,
grid_instructions as (
	select * from grid
	join expanded_puzzle
	
)



select *
from grid_instructions

limit 100