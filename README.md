AUTO DRIVING CAR

Part 1
 You're working on a brand new auto driving car to compete against Tesla. You've already gotten the prototype
 car working but rather primitively.
 You're testing your prototype on a large rectangular field, with coordinates denoting the position on that field.
 Based on the coordinates, bottom left position is denoted (0, 0), and top right position is denoted (width,
 height).
 At this moment, it can only follow these commands:
 L: rotates the car by 90 degrees to the left
 R: rotates the car by 90 degress to the right
 F: moves forward by 1 grid point
 At the same time, the car has a facing direction, which follows usual map convention. So for a car at position
 (1,2) facing North, and moves forward by 1 grid point, it'll end up at (1, 3), still facing North

 Sample Input
 Your sample input consists 3 lines. The fist line indicates the width and height of the field. The second line
 indicates the current position and facing direction of the car. The last line shows the subsequent commands it
 will execute. For example
 10 10 
1 2 N 
FFRFFFRRLF 
To intepret the input above: the field 10 by 10 in size, hence upper right coordinate is (9,9). The car is at
 position (1,2) facing North, and executes these steps FFRFFFRRLF sequentially. So where would the car end
 up? What direction will it facing?
 If the car tries to go out of the boundary, that command is ignored. E.g. For a car at (0,0) facing South, when it
 receives a F command to move forward, the command is ignored, as else the car will move outside of the
 boundary.
 Sample Output
 Based on the sample input above, the output would be:
 4 3 S 


 Part 2
 You now want to deploy multiple cars on the same field at the same time but you want to ensure that they
 don't collide. Collision can happen when two cars or more want to move to the same coordinate.
 Sample Input
 Similar to Par 1, the sample input consists the field width and height. But this time, it contains multiple
 sections for each car:
 10 10 
A 
1 2 N 
FFRFFFFRRL 
B 
7 8 W 
FFLFFFFFFF 
If we deploy these two cars at the same time, will they collide into each other at some point?
 Sample Output
 Based on the sample input above, the output would be:
 A B 
5 4 
7 

This means that car A and B will collide into each other at (5,4) at 7th step.
 If there is no collision, simply output the following:
 no collision
