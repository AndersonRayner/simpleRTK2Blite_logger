# SimpleRTK2Blite Logger Board
A simple logging board for the simpleRTK2BLite board from ArduSimple.  Uses COTS components to make assembly quick and easy.

<p align="center">
  <img src="https://raw.githubusercontent.com/AndersonRayner/simpleRTK2Blite_logger/master/Images/featured.png" width="400" >
</p>

Make sure to clone recursively!
```
https://github.com/AndersonRayner/simpleRTK2Blite_logger.git --recursive
```

Features:
- 5-36 V Input (XT30 Connector) 
- Logging to SD Card

## Hardware
Design files (KiCAD) are in the hardware folder.
Most parts are COTS
- simpleRTK2blite board | https://www.ardusimple.com/simplertk2blite/
- SparkFun OpenLog | https://www.sparkfun.com/products/13712
- Pololu 3V3 Regulator | https://www.pololu.com/product/2842
- XBee Radio v3
  - PCB Antenna | https://www.sparkfun.com/products/15126
  - External Antenna | https://www.sparkfun.com/products/15131 
- Custom PCB | See the hardware folder

## Software
Various scripts for generating post-processed solutions and extracting NMEA data.

### Configuration Files
Configuration files for the Base and Rover. 

## Notes
### GPS Accuracy vs. Decimal Places
| Decimals | Degrees    | Distance |
|----------|------------|----------|
| 0        | 1.0        | 111 km   |
| 1        | 0.1        | 11.1 km  |
| 2        | 0.01       | 1.11 km  |
| 3        | 0.001      | 111 m    |
| 4        | 0.0001     | 11.1 m   |
| 5        | 0.00001    | 1.11 m   |
| 6        | 0.000001   | 0.111 m  |
| 7        | 0.0000001  | 1.11 cm  |
| 8        | 0.00000001 | 1.11 mm  |
