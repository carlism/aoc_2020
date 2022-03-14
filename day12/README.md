# Day12

## Part 1

All that's being asked for is the distance.  My thought is that if I can calculate a distance per move,
all I have to do is sum them all up.  Distance per move will depend on the instuction as well as the
current heading.

I will test that all turns are a multiple of 90deg.  Confirmed!

I'm going to represent direction as a multiplier East-{0,1}, West-{0,-1}, North-{1,0}, South-{-1,0}
This simplifies the distance calculation of F movement of n to {x*n, y*n}

N, S, E, W movement is all very simple. Same as forward movement above but with specific direction,
as opposed to heading, as multiplier.

The only messy bit is calculating turns
turns of 0 are always just whatever direction you had
turns of 180 are always {x*-1,y*-1}, just reverse polarity of whatever direction you had

take the remainder after dividing by 360, if left, take 360-turn and go right
then, divide the turn by 90 getting the number of 90 deg turns, or steps to take thru the turn array

right turns of 90:
east -> south -> west -> north
{0,1} => {-1,0} => {0,-1} => {1,0} => {0,1}
