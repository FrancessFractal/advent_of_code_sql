A few years ago, I wanted to experiment with recursive common table expressions in SQL and see how far I could go with them. This is the result. I took some programming exercises from https://adventofcode.com and implemented them in SQLite. Each exercise involves computing some number based on input provided in a .txt file. The general idea is that this is some sort of competition, so each user gets the same puzzle but with different inputs provided in the .txt file. This means that every user has a different puzzle answer and can't cheat by submitting someone else's answer, as they will have to run their code on their own unique puzzle input file.

Since SQLite doesn't actually have any way to read .txt files as input, first I copied the .txt files into a table, 'puzzle_input'. You can run puzzle_input.sql on an empty db to set up the table with my version of all the puzzle inputs. I'm also including the SQLite .db file that has all that data already inserted.

My goal was mostly just to see how far I could go in making use of the expressiveness of SQL expressions. So, the rules I made for myself were that each answer had to be a single SELECT query that would return a 1x1 table containing the solution. The puzzle inputs had to be copied directly from the .txt file, no preprocessing or anything. No views, stored procedures, etc. Just a single SELECT query that has access to a single table.

The puzzle questions can be found at the links below. (you have to be logged in and have already submitted the correct 'part 1' solution in order to see 'part 2' of each question.)

https://adventofcode.com/2015/day/1

https://adventofcode.com/2015/day/2

https://adventofcode.com/2015/day/3

I skipped 4 because SQLite doesn't do MD5 hashes.

https://adventofcode.com/2015/day/5

https://adventofcode.com/2015/day/6 - I started this puzzle and never finished it.

The answers associated with my input data were:

1a) 138

1b) 1771

2a) 1606483

2b) 3842356

3a) 2565

3b) 2639

5a) 238

5b) 69
