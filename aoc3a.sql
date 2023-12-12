with recursive

puzzle (str_input) as (
	select puzzle_input.str_input
	from puzzle_input
	where 
		puzzle_input.year=2015
		and puzzle_input.day=3
)
,
indices (ind) as (
select 1
union
select ind+1 from indices
limit (select length(puzzle.str_input) from puzzle)
)
,
expanded_puzzle (ind, val) as (
select ind, substr((select puzzle.str_input from puzzle), ind, 1)
from indices
)
,
location (ind, move, x, y) as (
	-- one starting move for each santa
	select 0, null, 0, 0
	union all
	select 0, null, 0, 0	
	union all
	select 
		location.ind+1, 
		expanded_puzzle.val,
		case 
			when expanded_puzzle.val = '>'
			then location.x + 1
			when expanded_puzzle.val = '<'
			then location.x - 1
			else location.x
		end,
		case
			when expanded_puzzle.val = '^'
			then location.y + 1
			when expanded_puzzle.val = 'v'
			then location.y - 1
			else location.y
		end
	from location
	join expanded_puzzle
	on location.ind+1 = expanded_puzzle.ind
)

select count(*)
from (
	select distinct x, y
	from location
)