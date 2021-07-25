# cityHaskell

This is a program written in Haskell that performs querying and updating population figures for a list of major European cities.

## More information

Each city has a name, a location expressed in degrees
north and degrees east, and a list of metropolitan area population figures expressed in
thousands of inhabitants: the first value in the list is the current population, the second
is the population a year ago, the third is the population two years ago, etc. The list of cities
is kept in alphabetical order. You can assume that the population lists have a common length
of at least two

## Main functionalities

# Demo 1

i. Return a list of the names of all the cities

# Demo 2

ii. Given a city name and a number, return the population of the city that number of
years ago (or “no data” if no such record exists); the returned value should be a string
representing the population in millions to 3 decimal places (e.g. “9.123m”)

# Demo 3

iii. Return all the data as a single string which, when output using putStr, will display the
data formatted neatly into five columns giving the name, location (degrees N & E), this
year’s population and last year’s population. (The populations should be formatted as
for (ii).)

# Demo 4

iv. Update the data with a list of new population figures (one value for each city); this
should increase the length of each of the cities’ population lists so that what was the
current figure now becomes last year’s figure, and so on.

# Demo 5

v. Add a new city to the list preserving its alphabetical ordering; the new city should have
a population list of length equal to those of the other cities.

# Demo 6

vi. For a given city name, return a list of annual percentage population growth figures for
that city (i.e., the result list should begin with the percentage increase from last year’s
figure to this year’s; the second value should give the increase from two years ago to
last year, etc.). The list will include negative values for shrinking populations.

# Demo 7

vii. Given a location and a number, return the name of the closest city with a population
bigger than the number, or “no city” if there are no such cities; use Pythagoras’ theorem
to calculate the distance between locations (i.e. assume the world is flat!)

## Manual to run the program

Add program.hs within the same folder where cities.txt exists. After accessing the current folder in the `ghci` terminal, enter `main`. User can select from 1-8 and a I/O will be initialize to request user for data input. 
