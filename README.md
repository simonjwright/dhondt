# D'Hondt Calculator #

This is an [Ada 2012](http://getadanow.com) program to predict electoral results in a party-list proportional representation election conducted according to the [D'Hondt](https://en.wikipedia.org/wiki/D'Hondt_method) method (as will be the case for the British EU election to be conducted on 23 May 2019).

## Building ##

Using your favourite Ada compiler,
```
gnatmake dhondt_calculator.adb
```

## Data prep ##

The input data file should look like this (comments optional, first character of line is space, `-` or `#`):
```text
--  Dhondt electoral data for South West region.

--  The number of seats
6

--  The party polling data (or actual number of votes). No spaces
--  in party names!
Brexit 42
Change_UK 4
Green 12
Labour 8
LibDem 20
Conservatives 9
UKIP 3
```

## Running ##

```shell
./dhondt_calculator < dhondt_sw.dat
```

## Notes ##

The usefulness of this program is likely to be limited, so I've not been as careful of input validation as would be normal.

The result of running with the current data set is
```text
$ ./dhondt_calculator < dhondt_sw.dat
Winner of round 1 is Brexit
Winner of round 2 is Brexit
Winner of round 3 is LibDem
Winner of round 4 is Brexit
Winner of round 5 is Green
Winner of round 6 is Brexit

Brexit won 4 seats.
Change_UK won 0 seats.
Conservatives won 0 seats.
Green won 1 seats.
Labour won 0 seats.
LibDem won 1 seats.
UKIP won 0 seats.
```
