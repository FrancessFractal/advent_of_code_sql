with recursive

puzzle (str_input) as (
	select str_input
	from puzzle_input
	where year=2015
		and day=5
)
,
expanded_puzzle (ind, line, rest) as (
	select
		1,
		-- from start of string to first newline
		substr(puzzle.str_input, 0, instr(puzzle.str_input, char(10))), 
		-- the rest of the string, plus a newline at the end to prevent infinite recursion
		substr(puzzle.str_input, instr(puzzle.str_input, char(10)) + 1) || char(10)
	from puzzle
	union all
	select 
		ind + 1,
		-- from start of string to first newline
		substr(expanded_puzzle.rest, 0, instr(expanded_puzzle.rest, char(10))), 
		-- the rest of the string
		substr(expanded_puzzle.rest, instr(expanded_puzzle.rest, char(10)) + 1)
	from expanded_puzzle
	where length(expanded_puzzle.rest) != 0
)
,
character_split (line, char_at, str_ind) as (
	select expanded_puzzle.line, substr(expanded_puzzle.line, 1, 1), 1
	from expanded_puzzle

	union all
	
	select character_split.line, substr(character_split.line, character_split.str_ind + 1, 1), character_split.str_ind + 1
	from character_split
	join expanded_puzzle on character_split.line=expanded_puzzle.line
	where character_split.str_ind < length(character_split.line)
)
,
two_pairs as (
	select a_first.line
	from character_split as a_first
	join character_split as a_second
		on a_first.line = a_second.line
		and a_first.str_ind + 1 = a_second.str_ind
	join character_split as b_first
		on a_first.line = b_first.line
		and a_first.char_at = b_first.char_at
		and a_first.str_ind + 1 < b_first.str_ind
	join character_split as b_second
		on a_first.line = b_second.line
		and a_second.char_at = b_second.char_at
		and b_first.str_ind + 1 = b_second.str_ind
	group by a_first.line
	
)
,
repeat as (
	select first.line 
	from character_split as first
	join character_split as second
	on first.line = second.line
	and first.str_ind + 2 = second.str_ind
	and first.char_at = second.char_at
	group by first.line
)

select count(*) as solution
from two_pairs
join repeat
on two_pairs.line = repeat.line


