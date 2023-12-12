with recursive

puzzle (str_input) as (
	select puzzle_input.str_input
	from puzzle_input
	where 
		puzzle_input.year=2015
		and puzzle_input.day=1
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

select sum(case when expanded_puzzle.val = '('
    then 1
	when expanded_puzzle.val = ')'
	then -1
	else 0
	end) as solution
from expanded_puzzle