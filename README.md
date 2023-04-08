# Space Shooter

#### Video Demo: https://youtu.be/Ksf8aNWVZ9k

#### Description:

# This was my final project for when I did CS50x.
# I looked back to all the old games I played
# while growing up, and recalled the classic space strategy game 'Star Control'

# I wanted to create a base of a 1v1 local space fighter versus games.
# Initially it was just pure space combat, but with the way
# the map wraps around, it was easy to spam shoot as soon as the game starts,
# so there are Asteroids to avoid, move around or shoot through.

# Players could spin around to try and shoot and wrap around behind them, but
# the turning speed is slow enough for the opponent to read this and move
# accordingly to avoid such a tactic.

# Player will get two points for shooting the opponent
# Player loses one point for crashing into an asteroid, and score can't go below zero points

# I decided to force players to lose a point for crashing into an asteroid. This was to
# prevent players from denying their opponent points by purposely crashing.
# While I respect playing to win strategies, I didn't want the game to devolve into
# a stalling like game play.

# One thing I want to learn is, I think it's called object orientated coding.
# I found with this project, I was repeating a lot of code, duplicating things like
# the variables for player one and player two, but needing to differentiate between
# the two players.

# An example I encountered, I initially tried to have both players share bullet tables.
# But because of the collision code, as soon as a player would shoot a bullet, it was already
# overlapping that player. As a result I had to again duplicate the shooting code, even
# making the bullet shot from the player, the same colour as the nose of their ship

# This did mean that you could no longer shoot yourself by chasing your own bullet wrapping
# around the screen, which I thought was an interesting function to have to play around, forcing
# players to not be so careless and shooting non stop as they zip around space.

# The fully fleshed out idea would be to have different ships, of different speed, size, weapons,
# turning speed etc

# I had tried drawing the ships as triangles, but I was having difficulty with collision detection.
# The guide and code I had used, based collision detection on circles, so for my first time I stuck
# with the circle shape for all the objects.

# Scope ideas beyond would be, a full galaxy map of sectors, where players would fight to take
# control of as many sectors as possible. They could give resources, or could just be ideal
# pathways to even more sectors.

# But for now, and the purpose of this project, I wanted to keep the scope small and focus on
# getting the base of the 1v1 shooting aspect working, which I feel I have accomplished.

# I definitely learnt a lot during the course, this has been an amazing experience and learning journey
# I plan to use what I learnt, to learn more about machine learning development and AI.

# I'm still interested in games, an idea would be to put in what I learn about coding machine learning
# and AI, into games. That woulid be amazing.

# Thank you for your time.
