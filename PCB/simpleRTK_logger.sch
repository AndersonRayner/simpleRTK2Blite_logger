EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ARCL:Pololu_D24V5Fx U3
U 1 1 5FDAB86B
P 5050 6000
F 0 "U3" H 5075 6420 50  0000 C CNN
F 1 "Pololu_D24V5Fx" H 5075 6329 50  0000 C CNN
F 2 "ARCL:Pololu_D24V5Fx" H 5050 5600 50  0001 C CNN
F 3 "" H 5050 5600 50  0001 C CNN
	1    5050 6000
	1    0    0    -1  
$EndComp
$Comp
L ARCL:simpleRTK2blite U1
U 1 1 5FDABC20
P 3600 4400
F 0 "U1" H 3600 4130 50  0000 C CNN
F 1 "simpleRTK2blite" H 3600 4221 50  0000 C CNN
F 2 "ARCL:simpleRTK2blite_THT" H 3600 4750 50  0001 C CNN
F 3 "" H 3600 4750 50  0001 C CNN
	1    3600 4400
	-1   0    0    1   
$EndComp
$Comp
L ARCL:OpenLog U2
U 1 1 5FDAC861
P 5400 3950
F 0 "U2" H 5628 4396 50  0000 L CNN
F 1 "OpenLog" H 5628 4305 50  0000 L CNN
F 2 "ARCL:OpenLog" H 5400 3950 50  0001 C CNN
F 3 "" H 5400 3950 50  0001 C CNN
	1    5400 3950
	1    0    0    1   
$EndComp
Wire Wire Line
	4150 4600 4300 4600
$Comp
L power:Earth #PWR0101
U 1 1 5FDAE573
P 2850 4900
F 0 "#PWR0101" H 2850 4650 50  0001 C CNN
F 1 "Earth" H 2850 4750 50  0001 C CNN
F 2 "" H 2850 4900 50  0001 C CNN
F 3 "~" H 2850 4900 50  0001 C CNN
	1    2850 4900
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0102
U 1 1 5FDAE6F0
P 4300 3800
F 0 "#PWR0102" H 4300 3650 50  0001 C CNN
F 1 "+3.3V" H 4315 3973 50  0000 C CNN
F 2 "" H 4300 3800 50  0001 C CNN
F 3 "" H 4300 3800 50  0001 C CNN
	1    4300 3800
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR0103
U 1 1 5FDAF684
P 4200 5600
F 0 "#PWR0103" H 4200 5450 50  0001 C CNN
F 1 "+BATT" H 4215 5773 50  0000 C CNN
F 2 "" H 4200 5600 50  0001 C CNN
F 3 "" H 4200 5600 50  0001 C CNN
	1    4200 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 5600 4200 5850
Wire Wire Line
	4200 5850 4400 5850
$Comp
L power:Earth #PWR0104
U 1 1 5FDAFD6F
P 4350 6200
F 0 "#PWR0104" H 4350 5950 50  0001 C CNN
F 1 "Earth" H 4350 6050 50  0001 C CNN
F 2 "" H 4350 6200 50  0001 C CNN
F 3 "~" H 4350 6200 50  0001 C CNN
	1    4350 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 6200 4350 6050
Wire Wire Line
	4350 6050 4600 6050
$Comp
L power:Earth #PWR0105
U 1 1 5FDB0445
P 5800 6200
F 0 "#PWR0105" H 5800 5950 50  0001 C CNN
F 1 "Earth" H 5800 6050 50  0001 C CNN
F 2 "" H 5800 6200 50  0001 C CNN
F 3 "~" H 5800 6200 50  0001 C CNN
	1    5800 6200
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0106
U 1 1 5FDB07EF
P 6000 5600
F 0 "#PWR0106" H 6000 5450 50  0001 C CNN
F 1 "+3.3V" H 6015 5773 50  0000 C CNN
F 2 "" H 6000 5600 50  0001 C CNN
F 3 "" H 6000 5600 50  0001 C CNN
	1    6000 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 5850 6000 5850
Wire Wire Line
	6000 5850 6000 5600
Wire Wire Line
	5550 6050 5800 6050
Wire Wire Line
	5800 6050 5800 6200
Wire Wire Line
	4600 5950 4400 5950
Wire Wire Line
	4400 5950 4400 5850
Connection ~ 4400 5850
Wire Wire Line
	4400 5850 4600 5850
$Comp
L Connector:Conn_01x02_Male J1
U 1 1 5FDB1600
P 4500 7100
F 0 "J1" H 4472 6982 50  0000 R CNN
F 1 "Conn_01x02_Male" H 4472 7073 50  0000 R CNN
F 2 "Connector_AMASS:AMASS_XT30PW-M_1x02_P2.50mm_Horizontal" H 4500 7100 50  0001 C CNN
F 3 "~" H 4500 7100 50  0001 C CNN
	1    4500 7100
	1    0    0    1   
$EndComp
$Comp
L power:+BATT #PWR0107
U 1 1 5FDB1E22
P 5000 6800
F 0 "#PWR0107" H 5000 6650 50  0001 C CNN
F 1 "+BATT" H 5015 6973 50  0000 C CNN
F 2 "" H 5000 6800 50  0001 C CNN
F 3 "" H 5000 6800 50  0001 C CNN
	1    5000 6800
	1    0    0    -1  
$EndComp
$Comp
L power:Earth #PWR0108
U 1 1 5FDB2A4E
P 4850 7200
F 0 "#PWR0108" H 4850 6950 50  0001 C CNN
F 1 "Earth" H 4850 7050 50  0001 C CNN
F 2 "" H 4850 7200 50  0001 C CNN
F 3 "~" H 4850 7200 50  0001 C CNN
	1    4850 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 7100 4850 7100
Wire Wire Line
	4850 7100 4850 7200
Wire Wire Line
	4700 7000 5000 7000
Wire Wire Line
	5000 7000 5000 6900
$Comp
L Mechanical:MountingHole H1
U 1 1 5FDB5733
P 7300 3950
F 0 "H1" H 7400 3996 50  0000 L CNN
F 1 "MountingHole" H 7400 3905 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 7300 3950 50  0001 C CNN
F 3 "~" H 7300 3950 50  0001 C CNN
	1    7300 3950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5FDB5C5F
P 7300 4150
F 0 "H2" H 7400 4196 50  0000 L CNN
F 1 "MountingHole" H 7400 4105 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 7300 4150 50  0001 C CNN
F 3 "~" H 7300 4150 50  0001 C CNN
	1    7300 4150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 5FDB5E5C
P 7300 4350
F 0 "H3" H 7400 4396 50  0000 L CNN
F 1 "MountingHole" H 7400 4305 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 7300 4350 50  0001 C CNN
F 3 "~" H 7300 4350 50  0001 C CNN
	1    7300 4350
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 5FDB5FBF
P 7300 4550
F 0 "H4" H 7400 4596 50  0000 L CNN
F 1 "MountingHole" H 7400 4505 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 7300 4550 50  0001 C CNN
F 3 "~" H 7300 4550 50  0001 C CNN
	1    7300 4550
	1    0    0    -1  
$EndComp
$Comp
L power:Earth #PWR0109
U 1 1 5FDBD6C0
P 5050 4800
F 0 "#PWR0109" H 5050 4550 50  0001 C CNN
F 1 "Earth" H 5050 4650 50  0001 C CNN
F 2 "" H 5050 4800 50  0001 C CNN
F 3 "~" H 5050 4800 50  0001 C CNN
	1    5050 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3050 4450 2850 4450
Wire Wire Line
	2850 4450 2850 4550
Wire Wire Line
	3050 4550 2850 4550
Connection ~ 2850 4550
Wire Wire Line
	2850 4550 2850 4900
Wire Wire Line
	4650 4400 5250 4400
Wire Wire Line
	4650 4500 5250 4500
Wire Wire Line
	5250 4200 5050 4200
Wire Wire Line
	5050 4200 5050 4800
Wire Wire Line
	4300 4600 4300 4300
$Comp
L pspice:CAP C1
U 1 1 5FF9230C
P 5450 7050
F 0 "C1" H 5628 7096 50  0000 L CNN
F 1 "CAP" H 5628 7005 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 5450 7050 50  0001 C CNN
F 3 "~" H 5450 7050 50  0001 C CNN
	1    5450 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 6900 5200 6900
Wire Wire Line
	5200 6900 5200 6800
Wire Wire Line
	5200 6800 5450 6800
Connection ~ 5000 6900
Wire Wire Line
	5000 6900 5000 6800
Wire Wire Line
	4850 7100 5200 7100
Wire Wire Line
	5200 7100 5200 7300
Wire Wire Line
	5200 7300 5450 7300
Connection ~ 4850 7100
Wire Wire Line
	4300 4300 4350 4300
Wire Wire Line
	4300 4300 4300 3800
Connection ~ 4300 4300
$Comp
L Connector:Conn_01x02_Male J2
U 1 1 608B4439
P 4450 4100
F 0 "J2" V 4512 4144 50  0000 L CNN
F 1 "Conn_01x02_Male" V 4400 4000 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 4450 4100 50  0001 C CNN
F 3 "~" H 4450 4100 50  0001 C CNN
	1    4450 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	4450 4300 5250 4300
$EndSCHEMATC