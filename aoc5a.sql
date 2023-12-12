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
double_letters as (
	select first.line 
	from character_split as first
	join character_split as second
	on first.line = second.line
	and first.str_ind + 1 = second.str_ind
	and first.char_at = second.char_at
	group by first.line
)
,
three_vowels as (
	select line, count(*) as num_vowels
	from character_split
	where char_at in ('a', 'e', 'i', 'o', 'u')
	group by line
	having num_vowels >= 3
)

select count(*) as solution
from double_letters
join three_vowels
on double_letters.line = three_vowels.line
where instr(double_letters.line, 'ab') = 0
and instr(double_letters.line, 'cd') = 0
and instr(double_letters.line, 'pq') = 0
and instr(double_letters.line, 'xy') = 0

