# FCC-number-guessing-game

Creating database using two tables: users and games.

users: rows: pkey, serial.  username, varchar(30)

games: game_id pkey, serial.  guesses, int. user_id int fkey references users(user_id)


