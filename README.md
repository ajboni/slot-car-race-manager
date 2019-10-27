[![forthebadge](https://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](https://forthebadge.com)

# slot-car-race-manager

Slot Car Race manager, server, and racer database for DYI slot car racer track controlled by Arduino.

# Byte Commands

0000 0000 = RESERVED

0001 0000 = START RACE (1 player)
0001 0001 = START RACE (2 player)
0001 0010 = START RACE (3 player)
0001 0011 = START RACE (4 player)

0010 0000 = FALSE START (1 player)
0010 0001 = FALSE START (2 player)
0010 0010 = FALSE START (3 player)
0010 0011 = FALSE START (4 player)

1111 0000 = STATUS_IDLE
1111 0001 = STATUS_COUNTDOWN
1111 0010 = FALSE_START
1111 0011 = STARTED
1111 0100 = FINISHED







1000 0001 = START COUNTDOWN


0000 0100
