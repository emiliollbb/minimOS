EESchema Schematic File Version 4
LIBS:picoVDU-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "picoVDU 128x128"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Oscillator:ACO-xxxMHz X1
U 1 1 606A166F
P 800 1000
F 0 "X1" H 457 1046 50  0000 R CNN
F 1 "ACO-24.576MHz" H 457 955 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 1250 650 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 700 1000 50  0001 C CNN
	1    800  1000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS93 U1
U 1 1 606A0B55
P 1700 1200
F 0 "U1" H 1700 1881 50  0000 C CNN
F 1 "74HCT93" H 1700 1790 50  0000 C CNN
F 2 "" H 1700 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS93" H 1700 1200 50  0001 C CNN
	1    1700 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 1000 1200 1000
Wire Wire Line
	1200 1100 1150 1100
Wire Wire Line
	1150 1100 1150 650 
Wire Wire Line
	1150 650  2200 650 
Wire Wire Line
	2200 650  2200 1000
Wire Wire Line
	1200 1300 1200 1400
$Comp
L 4xxx_IEEE:4024 U2
U 1 1 606A4438
P 1700 2500
F 0 "U2" H 1700 3116 50  0000 C CNN
F 1 "74HCT4024" H 1700 3025 50  0000 C CNN
F 2 "" H 1700 2500 50  0001 C CNN
F 3 "" H 1700 2500 50  0001 C CNN
	1    1700 2500
	1    0    0    -1  
$EndComp
$Comp
L 4xxx:4040 U3
U 1 1 606A9A83
P 1700 4650
F 0 "U3" H 1700 5631 50  0000 C CNN
F 1 "74HCT4040" H 1700 5540 50  0000 C CNN
F 2 "" H 1700 4650 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 1700 4650 50  0001 C CNN
	1    1700 4650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 606AB7E0
P 800 700
F 0 "#PWR0101" H 800 550 50  0001 C CNN
F 1 "+5V" H 815 873 50  0000 C CNN
F 2 "" H 800 700 50  0001 C CNN
F 3 "" H 800 700 50  0001 C CNN
	1    800  700 
	1    0    0    -1  
$EndComp
Connection ~ 800  700 
Wire Wire Line
	800  700  1100 700 
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 606ACFB4
P 1100 700
F 0 "#FLG0101" H 1100 775 50  0001 C CNN
F 1 "PWR_FLAG" H 1100 873 50  0000 C CNN
F 2 "" H 1100 700 50  0001 C CNN
F 3 "~" H 1100 700 50  0001 C CNN
	1    1100 700 
	1    0    0    -1  
$EndComp
Connection ~ 1100 700 
Wire Wire Line
	1100 700  1700 700 
Wire Wire Line
	1700 1700 1000 1700
Wire Wire Line
	800  1700 800  1300
$Comp
L power:GND #PWR0102
U 1 1 606AD4D3
P 800 1700
F 0 "#PWR0102" H 800 1450 50  0001 C CNN
F 1 "GND" H 805 1527 50  0000 C CNN
F 2 "" H 800 1700 50  0001 C CNN
F 3 "" H 800 1700 50  0001 C CNN
	1    800  1700
	1    0    0    -1  
$EndComp
Connection ~ 800  1700
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 606AD870
P 1000 1700
F 0 "#FLG0102" H 1000 1775 50  0001 C CNN
F 1 "PWR_FLAG" H 1000 1873 50  0000 C CNN
F 2 "" H 1000 1700 50  0001 C CNN
F 3 "~" H 1000 1700 50  0001 C CNN
	1    1000 1700
	1    0    0    -1  
$EndComp
Connection ~ 1000 1700
Wire Wire Line
	1000 1700 800  1700
$Comp
L power:GND #PWR0103
U 1 1 606AFC81
P 1700 2800
F 0 "#PWR0103" H 1700 2550 50  0001 C CNN
F 1 "GND" H 1705 2627 50  0000 C CNN
F 2 "" H 1700 2800 50  0001 C CNN
F 3 "" H 1700 2800 50  0001 C CNN
	1    1700 2800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 606B223D
P 1700 5550
F 0 "#PWR0106" H 1700 5300 50  0001 C CNN
F 1 "GND" H 1705 5377 50  0000 C CNN
F 2 "" H 1700 5550 50  0001 C CNN
F 3 "" H 1700 5550 50  0001 C CNN
	1    1700 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 2450 1150 3450
Wire Wire Line
	1150 4150 1200 4150
Wire Wire Line
	1150 2300 1150 1800
Wire Wire Line
	1150 1800 2200 1800
Wire Wire Line
	1200 4450 1100 4450
Wire Wire Line
	1100 4450 1100 1400
Wire Wire Line
	1100 1400 1200 1400
Connection ~ 1200 1400
Wire Wire Line
	1700 3850 1050 3850
Wire Wire Line
	1050 3850 1050 2050
Wire Wire Line
	1050 2050 1300 2050
Wire Wire Line
	1700 2050 1700 2100
$Comp
L power:+5V #PWR0104
U 1 1 606D9390
P 1300 2050
F 0 "#PWR0104" H 1300 1900 50  0001 C CNN
F 1 "+5V" H 1315 2223 50  0000 C CNN
F 2 "" H 1300 2050 50  0001 C CNN
F 3 "" H 1300 2050 50  0001 C CNN
	1    1300 2050
	1    0    0    -1  
$EndComp
Connection ~ 1300 2050
Wire Wire Line
	1300 2050 1700 2050
NoConn ~ 2200 4150
NoConn ~ 2200 5150
NoConn ~ 2200 5050
NoConn ~ 2200 5250
$Comp
L 74xx:74HC245 U4
U 1 1 606E0359
P 6200 2450
F 0 "U4" H 6200 3431 50  0000 C CNN
F 1 "74HC245" H 6200 3340 50  0000 C CNN
F 2 "" H 6200 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 6200 2450 50  0001 C CNN
	1    6200 2450
	-1   0    0    -1  
$EndComp
NoConn ~ 6700 1950
NoConn ~ 6700 2050
NoConn ~ 6700 2150
NoConn ~ 6700 2250
Wire Wire Line
	6700 2850 6750 2850
Wire Wire Line
	6750 2850 6750 3250
Wire Wire Line
	6750 3250 6200 3250
$Comp
L 74xx:74HC245 U5
U 1 1 606EF8C2
P 6200 4750
F 0 "U5" H 6200 5731 50  0000 C CNN
F 1 "74HC245" H 6200 5640 50  0000 C CNN
F 2 "" H 6200 4750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 6200 4750 50  0001 C CNN
	1    6200 4750
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6700 5150 6750 5150
Wire Wire Line
	6750 5150 6750 5450
Wire Wire Line
	6750 5550 6200 5550
$Comp
L power:GND #PWR0108
U 1 1 606F8C53
P 6200 5550
F 0 "#PWR0108" H 6200 5300 50  0001 C CNN
F 1 "GND" H 6205 5377 50  0000 C CNN
F 2 "" H 6200 5550 50  0001 C CNN
F 3 "" H 6200 5550 50  0001 C CNN
	1    6200 5550
	1    0    0    -1  
$EndComp
Connection ~ 6200 5550
Wire Wire Line
	6700 2950 6850 2950
Wire Wire Line
	6850 2950 6850 3500
Wire Wire Line
	6850 5250 6700 5250
NoConn ~ 6700 4950
Wire Wire Line
	1700 3850 2050 3850
Connection ~ 1700 3850
$Comp
L Device:R_Network04 RN1
U 1 1 6075D211
P 5500 2050
F 0 "RN1" V 5825 2050 50  0000 C CNN
F 1 "4K7" V 5734 2050 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP5" V 5775 2050 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 5500 2050 50  0001 C CNN
	1    5500 2050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6850 3500 5300 3500
Wire Wire Line
	5300 3500 5300 2250
Connection ~ 6850 3500
$Comp
L power:GND #PWR0105
U 1 1 60762596
P 6200 3250
F 0 "#PWR0105" H 6200 3000 50  0001 C CNN
F 1 "GND" H 6205 3077 50  0000 C CNN
F 2 "" H 6200 3250 50  0001 C CNN
F 3 "" H 6200 3250 50  0001 C CNN
	1    6200 3250
	1    0    0    -1  
$EndComp
Connection ~ 6200 3250
Wire Wire Line
	5700 4950 5650 4950
Wire Wire Line
	5650 4950 5650 3950
Wire Wire Line
	5650 3950 6200 3950
Wire Wire Line
	1700 2050 2250 2050
Wire Wire Line
	2250 2050 2250 1650
Connection ~ 1700 2050
Wire Wire Line
	2250 2350 5700 2350
Wire Wire Line
	2250 2450 3100 2450
Wire Wire Line
	2250 2550 3900 2550
Wire Wire Line
	2250 2650 2350 2650
Wire Wire Line
	2200 4250 5700 4250
Wire Wire Line
	2200 4450 2450 4450
Wire Wire Line
	2200 4550 2650 4550
Wire Wire Line
	2200 4650 2550 4650
Wire Wire Line
	2200 4750 5700 4750
Wire Wire Line
	2250 1650 6200 1650
$Comp
L Memory_RAM:6116 U6
U 1 1 607C2B43
P 7450 4650
F 0 "U6" H 7450 5831 50  0000 C CNN
F 1 "6116" H 7450 5740 50  0000 C CNN
F 2 "Package_DIP:DIP-24_W15.24mm" H 7450 4650 50  0001 C CNN
F 3 "http://www.princeton.edu/~mae412/HANDOUTS/Datasheets/6116.pdf" H 7450 4650 50  0001 C CNN
	1    7450 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 5550 7050 5550
Connection ~ 6750 5550
Wire Wire Line
	7050 5450 6750 5450
Connection ~ 6750 5450
Wire Wire Line
	6750 5450 6750 5550
$Comp
L 74xx:74LS165 U7
U 1 1 607D2B41
P 8900 4350
F 0 "U7" H 8900 5431 50  0000 C CNN
F 1 "74HC165" H 8900 5340 50  0000 C CNN
F 2 "" H 8900 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS165" H 8900 4350 50  0001 C CNN
	1    8900 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 5550 6750 5750
Wire Wire Line
	6750 5750 7450 5750
Wire Wire Line
	8900 5750 8900 5350
Connection ~ 7450 5750
Wire Wire Line
	8400 5050 8400 5750
Wire Wire Line
	7050 2350 6700 2350
Wire Wire Line
	7050 3950 7000 3950
Wire Wire Line
	7000 2450 6700 2450
Wire Wire Line
	7050 4050 6950 4050
Wire Wire Line
	6950 2550 6700 2550
Wire Wire Line
	7050 4150 6900 4150
Wire Wire Line
	6900 2650 6700 2650
Entry Wire Line
	6800 4950 6900 4850
Entry Wire Line
	6800 4850 6900 4750
Entry Wire Line
	6800 4750 6900 4650
Entry Wire Line
	6800 4650 6900 4550
Entry Wire Line
	6800 4550 6900 4450
Entry Wire Line
	6800 4450 6900 4350
Entry Wire Line
	6800 4350 6900 4250
Text Label 6900 4250 0    50   ~ 0
VA4
Text Label 6900 4350 0    50   ~ 0
VA5
Text Label 6900 4450 0    50   ~ 0
VA6
Text Label 6900 4550 0    50   ~ 0
VA7
Text Label 6900 4650 0    50   ~ 0
VA8
Text Label 6900 4750 0    50   ~ 0
VA9
Text Label 6900 4850 0    50   ~ 0
VA10
Entry Wire Line
	6900 3650 7000 3550
Entry Wire Line
	6950 3650 7050 3550
Wire Wire Line
	6850 3500 6850 5250
Entry Wire Line
	7000 3650 7100 3550
Entry Wire Line
	7050 3650 7150 3550
Text Label 6900 3800 1    50   ~ 0
VA3
Text Label 6950 3800 1    50   ~ 0
VA2
Text Label 7000 3800 1    50   ~ 0
VA1
Text Label 7050 3800 1    50   ~ 0
VA0
Entry Wire Line
	7150 1950 7250 1850
Entry Wire Line
	7150 2050 7250 1950
Entry Wire Line
	7150 2150 7250 2050
Entry Wire Line
	7150 2250 7250 2150
Entry Wire Line
	7150 2350 7250 2250
Entry Wire Line
	7150 2450 7250 2350
Entry Wire Line
	7150 2550 7250 2450
Entry Wire Line
	7150 2650 7250 2550
Entry Wire Line
	7150 2750 7250 2650
Entry Wire Line
	7150 2850 7250 2750
Entry Wire Line
	7150 2950 7250 2850
Wire Wire Line
	7250 1850 7400 1850
$Comp
L Connector_Generic:Conn_01x11 J1
U 1 1 6085BA23
P 7600 2350
F 0 "J1" H 7680 2392 50  0000 L CNN
F 1 "LATCH ADDRESS" H 7680 2301 50  0000 L CNN
F 2 "" H 7600 2350 50  0001 C CNN
F 3 "~" H 7600 2350 50  0001 C CNN
	1    7600 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 1950 7400 1950
Wire Wire Line
	7250 2050 7400 2050
Wire Wire Line
	7250 2150 7400 2150
Wire Wire Line
	7250 2250 7400 2250
Wire Wire Line
	7250 2350 7400 2350
Wire Wire Line
	7250 2450 7400 2450
Wire Wire Line
	7250 2550 7400 2550
Wire Wire Line
	7250 2650 7400 2650
Wire Wire Line
	7250 2750 7400 2750
Text Label 7250 1850 0    50   ~ 0
VA0
Text Label 7250 1950 0    50   ~ 0
VA1
Text Label 7250 2050 0    50   ~ 0
VA2
Text Label 7250 2150 0    50   ~ 0
VA3
Text Label 7250 2250 0    50   ~ 0
VA4
Text Label 7250 2350 0    50   ~ 0
VA5
Text Label 7250 2450 0    50   ~ 0
VA6
Text Label 7250 2550 0    50   ~ 0
VA7
Text Label 7250 2650 0    50   ~ 0
VA8
Text Label 7250 2750 0    50   ~ 0
VA9
Wire Wire Line
	7250 2850 7400 2850
Text Label 7250 2850 0    50   ~ 0
VA10
Wire Wire Line
	7450 3450 8900 3450
$Comp
L power:+5V #PWR0107
U 1 1 60884EB2
P 7450 3400
F 0 "#PWR0107" H 7450 3250 50  0001 C CNN
F 1 "+5V" H 7465 3573 50  0000 C CNN
F 2 "" H 7450 3400 50  0001 C CNN
F 3 "" H 7450 3400 50  0001 C CNN
	1    7450 3400
	1    0    0    -1  
$EndComp
Connection ~ 8400 5750
Wire Wire Line
	7450 5750 8400 5750
Wire Wire Line
	7450 3400 7450 3450
Wire Wire Line
	8400 5750 8900 5750
Connection ~ 7450 3450
Wire Wire Line
	7450 3450 7450 3650
Wire Wire Line
	8350 1200 8350 4950
Wire Wire Line
	8350 4950 8400 4950
$Comp
L 74xx:74LS10 U8
U 1 1 608EA304
P 2700 1400
F 0 "U8" H 2700 1725 50  0000 C CNN
F 1 "74HCT10" H 2700 1634 50  0000 C CNN
F 2 "" H 2700 1400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS10" H 2700 1400 50  0001 C CNN
	1    2700 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 1800 2200 1400
Wire Wire Line
	2200 1200 8350 1200
Wire Wire Line
	2200 1400 2400 1400
Connection ~ 2200 1400
Wire Wire Line
	2200 1400 2200 1300
Wire Wire Line
	2300 1500 2300 2150
Wire Wire Line
	2300 2150 2250 2150
Wire Wire Line
	2300 1500 2400 1500
Wire Wire Line
	2250 2250 2350 2250
Wire Wire Line
	2350 2250 2350 1300
Wire Wire Line
	2350 1300 2400 1300
NoConn ~ 2200 1100
Wire Wire Line
	3000 1400 4850 1400
Wire Wire Line
	8300 1400 8300 4750
Wire Wire Line
	8300 4750 8400 4750
Wire Bus Line
	8250 5400 9300 5400
Entry Wire Line
	8150 3850 8250 3750
Entry Wire Line
	8150 3950 8250 3850
Entry Wire Line
	8150 4050 8250 3950
Entry Wire Line
	8150 4150 8250 4050
Entry Wire Line
	8150 4250 8250 4150
Entry Wire Line
	8150 4350 8250 4250
Entry Wire Line
	8150 4450 8250 4350
Entry Wire Line
	8150 4550 8250 4450
Text Label 8000 3850 0    50   ~ 0
VD0
Text Label 8000 3950 0    50   ~ 0
VD1
Text Label 8000 4050 0    50   ~ 0
VD2
Text Label 8000 4150 0    50   ~ 0
VD3
Text Label 8000 4250 0    50   ~ 0
VD4
Text Label 8000 4350 0    50   ~ 0
VD5
Text Label 8000 4450 0    50   ~ 0
VD6
Text Label 8000 4550 0    50   ~ 0
VD7
$Comp
L Connector_Generic:Conn_01x08 J2
U 1 1 6093BD0C
P 10750 4450
F 0 "J2" H 10830 4442 50  0000 L CNN
F 1 "6502 DATA BUS" H 10830 4351 50  0000 L CNN
F 2 "" H 10750 4450 50  0001 C CNN
F 3 "~" H 10750 4450 50  0001 C CNN
	1    10750 4450
	1    0    0    -1  
$EndComp
Entry Wire Line
	9300 4050 9400 4150
Entry Wire Line
	9300 4150 9400 4250
Entry Wire Line
	9300 4250 9400 4350
Entry Wire Line
	9300 4350 9400 4450
Entry Wire Line
	9300 4450 9400 4550
Entry Wire Line
	9300 4550 9400 4650
Entry Wire Line
	9300 4650 9400 4750
Entry Wire Line
	9300 4750 9400 4850
Wire Wire Line
	9400 4150 9550 4150
Wire Wire Line
	9400 4250 9550 4250
Wire Wire Line
	9400 4350 9550 4350
Wire Wire Line
	9400 4450 9550 4450
Wire Wire Line
	9400 4550 9550 4550
Wire Wire Line
	9400 4650 9550 4650
Wire Wire Line
	9400 4750 9550 4750
Wire Wire Line
	9400 4850 9550 4850
Text Label 9400 4350 0    50   ~ 0
VD0
Text Label 9400 4250 0    50   ~ 0
VD1
Text Label 9400 4150 0    50   ~ 0
VD2
Text Label 9400 4850 0    50   ~ 0
VD3
Text Label 9400 4750 0    50   ~ 0
VD4
Text Label 9400 4650 0    50   ~ 0
VD5
Text Label 9400 4550 0    50   ~ 0
VD6
Text Label 9400 4450 0    50   ~ 0
VD7
$Comp
L 74xx:74HC245 U9
U 1 1 60984ED6
P 10050 4650
F 0 "U9" H 10050 5631 50  0000 C CNN
F 1 "74HC245" H 10050 5540 50  0000 C CNN
F 2 "" H 10050 4650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 10050 4650 50  0001 C CNN
	1    10050 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 5750 9350 5750
Wire Wire Line
	10050 5750 10050 5450
Connection ~ 8900 5750
Wire Wire Line
	8900 3450 9750 3450
Wire Wire Line
	10050 3450 10050 3850
Connection ~ 8900 3450
Wire Wire Line
	9550 5050 9350 5050
Wire Wire Line
	9350 5050 9350 5750
Connection ~ 9350 5750
Wire Wire Line
	9350 5750 10050 5750
Wire Wire Line
	6700 4250 7050 4250
Wire Bus Line
	6800 3550 7150 3550
Wire Bus Line
	8250 3750 8250 5400
$Comp
L 74xx:74LS21 U10
U 2 1 60785E6F
P 2300 3150
F 0 "U10" V 2254 3388 50  0000 L CNN
F 1 "74HC21" V 2345 3388 50  0000 L CNN
F 2 "" H 2300 3150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS21" H 2300 3150 50  0001 C CNN
	2    2300 3150
	0    1    1    0   
$EndComp
Wire Wire Line
	2150 2850 2050 2850
Wire Wire Line
	2050 2850 2050 3850
Wire Wire Line
	2250 2850 2250 2750
Wire Wire Line
	2350 2850 2350 2650
Connection ~ 2350 2650
Wire Wire Line
	2350 2650 5700 2650
Wire Wire Line
	2450 2850 2450 2250
Wire Wire Line
	2450 2250 2350 2250
Connection ~ 2350 2250
Wire Wire Line
	2300 3450 1150 3450
Connection ~ 1150 3450
Wire Wire Line
	1150 3450 1150 4150
$Comp
L 74xx:74LS21 U10
U 1 1 607C83CE
P 2500 5350
F 0 "U10" V 2454 5588 50  0000 L CNN
F 1 "74HC21" V 2545 5588 50  0000 L CNN
F 2 "" H 2500 5350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS21" H 2500 5350 50  0001 C CNN
	1    2500 5350
	0    1    1    0   
$EndComp
Wire Wire Line
	2200 4950 2350 4950
Wire Wire Line
	2450 5050 2450 4450
Connection ~ 2450 4450
Wire Wire Line
	2550 5050 2550 4650
Connection ~ 2550 4650
Wire Wire Line
	2650 5050 2650 4550
Connection ~ 2650 4550
Wire Wire Line
	1100 4450 1100 5800
Wire Wire Line
	1100 5800 2500 5800
Connection ~ 1100 4450
$Comp
L 74xx:74LS20 U11
U 2 1 60814898
P 3150 3250
F 0 "U11" V 3104 3045 50  0000 R CNN
F 1 "74HC20" V 3195 3045 50  0000 R CNN
F 2 "" H 3150 3250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS20" H 3150 3250 50  0001 C CNN
	2    3150 3250
	0    -1   1    0   
$EndComp
Wire Wire Line
	2300 2150 3000 2150
Wire Wire Line
	3000 2150 3000 2950
Connection ~ 2300 2150
Wire Wire Line
	3100 2950 3100 2450
Connection ~ 3100 2450
Wire Wire Line
	3100 2450 5700 2450
Wire Wire Line
	2250 2750 3200 2750
Wire Wire Line
	3200 2750 3200 2950
Connection ~ 2250 2750
$Comp
L 74xx:74HCT02 U12
U 2 1 60843475
P 3600 2950
F 0 "U12" H 3600 3275 50  0000 C CNN
F 1 "74HCT02" H 3600 3184 50  0000 C CNN
F 2 "" H 3600 2950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 3600 2950 50  0001 C CNN
	2    3600 2950
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3900 2550 3900 2850
Connection ~ 3900 2550
Wire Wire Line
	3900 2550 4200 2550
$Comp
L power:GND #PWR0109
U 1 1 6085F647
P 3900 3050
F 0 "#PWR0109" H 3900 2800 50  0001 C CNN
F 1 "GND" H 3905 2877 50  0000 C CNN
F 2 "" H 3900 3050 50  0001 C CNN
F 3 "" H 3900 3050 50  0001 C CNN
	1    3900 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 5800 2500 5650
Wire Wire Line
	2350 4950 2350 5050
$Comp
L 74xx:74HCT02 U12
U 4 1 608C71E9
P 3800 5150
F 0 "U12" H 3800 5475 50  0000 C CNN
F 1 "74HCT02" H 3800 5384 50  0000 C CNN
F 2 "" H 3800 5150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 3800 5150 50  0001 C CNN
	4    3800 5150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2350 4950 3400 4950
Wire Wire Line
	3400 4950 3400 5150
Connection ~ 2350 4950
$Comp
L 74xx:74LS20 U11
U 1 1 60909A7C
P 3350 5450
F 0 "U11" V 3304 5688 50  0000 L CNN
F 1 "74HC20" V 3395 5688 50  0000 L CNN
F 2 "" H 3350 5450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS20" H 3350 5450 50  0001 C CNN
	1    3350 5450
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 5050 4100 4650
Connection ~ 4100 4650
$Comp
L 74xx:74LS10 U8
U 3 1 6092EC3B
P 4200 3150
F 0 "U8" V 4154 2970 50  0000 R CNN
F 1 "74HCT10" V 4245 2970 50  0000 R CNN
F 2 "" H 4200 3150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS10" H 4200 3150 50  0001 C CNN
	3    4200 3150
	0    -1   1    0   
$EndComp
Wire Wire Line
	3200 2750 4100 2750
Connection ~ 3200 2750
Wire Wire Line
	4200 2550 4200 2850
Connection ~ 4200 2550
Wire Wire Line
	4200 2550 5700 2550
Wire Wire Line
	3000 2150 4300 2150
Wire Wire Line
	4300 2150 4300 2850
Connection ~ 3000 2150
Wire Wire Line
	2200 4350 3200 4350
Wire Wire Line
	2650 4550 3300 4550
Wire Wire Line
	4150 4450 4500 4450
Connection ~ 4150 4450
Wire Wire Line
	4150 4450 4150 5250
Wire Wire Line
	4150 5250 4100 5250
Wire Wire Line
	2200 4850 5700 4850
$Comp
L 74xx:74LS10 U8
U 2 1 60A0F397
P 4400 5350
F 0 "U8" V 4354 5170 50  0000 R CNN
F 1 "74HCT10" V 4445 5170 50  0000 R CNN
F 2 "" H 4400 5350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS10" H 4400 5350 50  0001 C CNN
	2    4400 5350
	0    -1   1    0   
$EndComp
Wire Wire Line
	3400 4950 4300 4950
Connection ~ 3400 4950
Wire Wire Line
	2550 4650 4100 4650
Wire Wire Line
	3300 5150 3300 4550
Connection ~ 3300 4550
Wire Wire Line
	3300 4550 4400 4550
Wire Wire Line
	2450 4450 4150 4450
Wire Wire Line
	3200 5150 3200 4350
Connection ~ 3200 4350
Wire Wire Line
	3200 4350 5700 4350
Wire Wire Line
	4100 4650 5700 4650
Wire Wire Line
	4400 5050 4400 4550
Connection ~ 4400 4550
Wire Wire Line
	4400 4550 5700 4550
Wire Wire Line
	4500 5050 4500 4450
Connection ~ 4500 4450
Wire Wire Line
	4500 4450 5700 4450
$Comp
L 74xx:74HCT00 U13
U 4 1 60AA7E0E
P 3600 3750
F 0 "U13" V 3554 3938 50  0000 L CNN
F 1 "74HCT00" V 3645 3938 50  0000 L CNN
F 2 "" H 3600 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct00" H 3600 3750 50  0001 C CNN
	4    3600 3750
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0110
U 1 1 60AEEAF2
P 5650 3950
F 0 "#PWR0110" H 5650 3800 50  0001 C CNN
F 1 "+5V" H 5665 4123 50  0000 C CNN
F 2 "" H 5650 3950 50  0001 C CNN
F 3 "" H 5650 3950 50  0001 C CNN
	1    5650 3950
	1    0    0    -1  
$EndComp
Connection ~ 5650 3950
$Comp
L 74xx:74HCT00 U13
U 3 1 60AF8E31
P 4100 3750
F 0 "U13" V 4054 3938 50  0000 L CNN
F 1 "74HCT00" V 4145 3938 50  0000 L CNN
F 2 "" H 4100 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct00" H 4100 3750 50  0001 C CNN
	3    4100 3750
	0    1    1    0   
$EndComp
Wire Wire Line
	3150 3550 3350 3550
Wire Wire Line
	3350 3550 3350 3450
Wire Wire Line
	3350 3450 3500 3450
Wire Wire Line
	3700 3450 3800 3450
Wire Wire Line
	3800 3450 3900 4050
Wire Wire Line
	3900 4050 4100 4050
Wire Wire Line
	3600 4050 3800 4050
Wire Wire Line
	3800 4050 3900 3450
Wire Wire Line
	4000 3450 3900 3450
$Comp
L 74xx:74HCT00 U13
U 2 1 60BB88BB
P 4300 5950
F 0 "U13" V 4254 5770 50  0000 R CNN
F 1 "74HCT00" V 4345 5770 50  0000 R CNN
F 2 "" H 4300 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct00" H 4300 5950 50  0001 C CNN
	2    4300 5950
	0    -1   1    0   
$EndComp
$Comp
L 74xx:74HCT00 U13
U 1 1 60BD5362
P 3800 5950
F 0 "U13" V 3754 5770 50  0000 R CNN
F 1 "74HCT00" V 3845 5770 50  0000 R CNN
F 2 "" H 3800 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct00" H 3800 5950 50  0001 C CNN
	1    3800 5950
	0    -1   1    0   
$EndComp
Wire Wire Line
	3350 5750 3550 5750
Wire Wire Line
	3550 5750 3550 5650
Wire Wire Line
	3550 5650 3700 5650
Wire Wire Line
	3900 5650 4000 5650
Wire Wire Line
	4000 5650 4100 6250
Wire Wire Line
	4200 5650 4100 5650
Wire Wire Line
	4100 5650 4000 6250
$Comp
L 74xx:74HCT02 U12
U 1 1 60C6BC04
P 5100 5250
F 0 "U12" V 5054 5438 50  0000 L CNN
F 1 "74HCT02" V 5145 5438 50  0000 L CNN
F 2 "" H 5100 5250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 5100 5250 50  0001 C CNN
	1    5100 5250
	0    1    1    0   
$EndComp
Wire Wire Line
	3800 6250 4000 6250
Wire Wire Line
	4100 6250 4300 6250
Wire Wire Line
	4300 4950 4300 5050
Wire Wire Line
	4300 4950 5000 4950
Connection ~ 4300 4950
Wire Wire Line
	4100 2750 4100 2850
Wire Wire Line
	4100 2750 5200 2750
Wire Wire Line
	5200 2750 5200 4950
Connection ~ 4100 2750
$Comp
L 74xx:74LS175 U14
U 1 1 60E5D46E
P 5600 6300
F 0 "U14" H 5600 7181 50  0000 C CNN
F 1 "74HC175" H 5600 7090 50  0000 C CNN
F 2 "" H 5600 6300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS175" H 5600 6300 50  0001 C CNN
	1    5600 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 5550 5100 5900
Connection ~ 5100 5900
Wire Wire Line
	5100 5900 5100 6100
NoConn ~ 6100 6100
NoConn ~ 6100 6200
NoConn ~ 6100 5900
NoConn ~ 6100 6400
NoConn ~ 6100 6600
Wire Wire Line
	4300 6250 4300 6500
Wire Wire Line
	4300 6500 5100 6500
Connection ~ 4300 6250
$Comp
L power:GND #PWR0111
U 1 1 60ED2E62
P 5600 7100
F 0 "#PWR0111" H 5600 6850 50  0001 C CNN
F 1 "GND" H 5605 6927 50  0000 C CNN
F 2 "" H 5600 7100 50  0001 C CNN
F 3 "" H 5600 7100 50  0001 C CNN
	1    5600 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 6300 4900 6300
Wire Wire Line
	4900 6300 4900 4050
Wire Wire Line
	4900 4050 4100 4050
Connection ~ 4100 4050
Wire Wire Line
	5100 6700 4850 6700
Wire Wire Line
	4850 6700 4850 1400
Connection ~ 4850 1400
Wire Wire Line
	4850 1400 8300 1400
Wire Wire Line
	5100 6800 5000 6800
Wire Wire Line
	5000 6800 5000 5600
Wire Wire Line
	5000 5600 5600 5600
Connection ~ 5600 5600
Wire Wire Line
	5600 5600 5900 5600
$Comp
L power:+5V #PWR0112
U 1 1 60F54A8C
P 5900 5600
F 0 "#PWR0112" H 5900 5450 50  0001 C CNN
F 1 "+5V" H 5915 5773 50  0000 C CNN
F 2 "" H 5900 5600 50  0001 C CNN
F 3 "" H 5900 5600 50  0001 C CNN
	1    5900 5600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U15
U 4 1 60F7CF26
P 6400 6400
F 0 "U15" H 6400 6083 50  0000 C CNN
F 1 "74HC86" H 6400 6174 50  0000 C CNN
F 2 "" H 6400 6400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 6400 6400 50  0001 C CNN
	4    6400 6400
	1    0    0    1   
$EndComp
$Comp
L 74xx:74HC86 U15
U 3 1 60F8DB5D
P 7000 6300
F 0 "U15" H 7000 6625 50  0000 C CNN
F 1 "74HC86" H 7000 6534 50  0000 C CNN
F 2 "" H 7000 6300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 7000 6300 50  0001 C CNN
	3    7000 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 5600 5900 5750
Wire Wire Line
	5900 5750 6700 5750
Wire Wire Line
	6700 5750 6700 6200
Connection ~ 5900 5600
$Comp
L 74xx:74HC86 U15
U 1 1 60FA4104
P 4700 6900
F 0 "U15" H 4700 7225 50  0000 C CNN
F 1 "74HC86" H 4700 7134 50  0000 C CNN
F 2 "" H 4700 6900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 4700 6900 50  0001 C CNN
	1    4700 6900
	-1   0    0    -1  
$EndComp
Connection ~ 5000 6800
Wire Wire Line
	5000 6800 5000 7000
NoConn ~ 4400 6900
Wire Wire Line
	6100 6000 7900 6000
Wire Wire Line
	7300 6300 7950 6300
NoConn ~ 9400 3750
Wire Wire Line
	9400 3850 9450 3850
Wire Wire Line
	9450 3850 9450 3300
$Comp
L 74xx:74HC86 U15
U 2 1 6104FAF4
P 9550 3000
F 0 "U15" V 9596 2820 50  0000 R CNN
F 1 "74HC86" V 9505 2820 50  0000 R CNN
F 2 "" H 9550 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 9550 3000 50  0001 C CNN
	2    9550 3000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9650 3300 9650 3750
Wire Wire Line
	9650 3950 9450 3950
Wire Wire Line
	9450 3950 9450 5700
Wire Wire Line
	7050 5150 7000 5150
Wire Wire Line
	7000 5150 7000 5800
Wire Wire Line
	7000 5800 10550 5800
Wire Wire Line
	6850 5250 6850 5900
Wire Wire Line
	6850 5900 10550 5900
Connection ~ 6850 5250
$Comp
L Connector_Generic:Conn_01x04 J3
U 1 1 610AD836
P 10750 5700
F 0 "J3" H 10830 5692 50  0000 L CNN
F 1 "CONTROL" H 10830 5601 50  0000 L CNN
F 2 "" H 10750 5700 50  0001 C CNN
F 3 "~" H 10750 5700 50  0001 C CNN
	1    10750 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 5150 9550 5600
Wire Wire Line
	9550 5600 10550 5600
Wire Wire Line
	10550 5700 9450 5700
Text Label 10400 5600 0    50   ~ 0
~DBE
Text Label 10400 5800 0    50   ~ 0
~WE
Text Label 10400 5900 0    50   ~ 0
ABE
$Comp
L Device:R R1
U 1 1 611548BC
P 9750 3600
F 0 "R1" H 9820 3646 50  0000 L CNN
F 1 "100K" H 9820 3555 50  0000 L CNN
F 2 "" V 9680 3600 50  0001 C CNN
F 3 "~" H 9750 3600 50  0001 C CNN
	1    9750 3600
	1    0    0    -1  
$EndComp
Connection ~ 9750 3450
Wire Wire Line
	9750 3450 10050 3450
Wire Wire Line
	9750 3750 9650 3750
Connection ~ 9650 3750
Wire Wire Line
	9650 3750 9650 3950
$Comp
L 74xx:74HCT02 U12
U 3 1 6117A45F
P 9450 2400
F 0 "U12" V 9496 2220 50  0000 R CNN
F 1 "74HCT02" V 9405 2220 50  0000 R CNN
F 2 "" H 9450 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 9450 2400 50  0001 C CNN
	3    9450 2400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9350 2700 7900 2700
Wire Wire Line
	7900 2700 7900 6000
$Comp
L Device:R R2
U 1 1 611CEF06
P 9450 1950
F 0 "R2" H 9520 1996 50  0000 L CNN
F 1 "1K3" H 9520 1905 50  0000 L CNN
F 2 "" V 9380 1950 50  0001 C CNN
F 3 "~" H 9450 1950 50  0001 C CNN
	1    9450 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 611CF376
P 9100 1950
F 0 "R3" H 9170 1996 50  0000 L CNN
F 1 "1K" H 9170 1905 50  0000 L CNN
F 2 "" V 9030 1950 50  0001 C CNN
F 3 "~" H 9100 1950 50  0001 C CNN
	1    9100 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 611D0596
P 9450 1650
F 0 "R4" H 9520 1696 50  0000 L CNN
F 1 "220" H 9520 1605 50  0000 L CNN
F 2 "" V 9380 1650 50  0001 C CNN
F 3 "~" H 9450 1650 50  0001 C CNN
	1    9450 1650
	1    0    0    -1  
$EndComp
$Comp
L Transistor_BJT:BC547 Q1
U 1 1 611D1202
P 9950 1800
F 0 "Q1" H 9950 2050 50  0000 L CNN
F 1 "BC547B" H 9750 1950 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 10150 1725 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 9950 1800 50  0001 L CNN
	1    9950 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 1800 9450 1800
Connection ~ 9450 1800
Wire Wire Line
	9450 1800 9100 1800
Wire Wire Line
	9450 1500 10050 1500
Wire Wire Line
	10050 1500 10050 1600
$Comp
L power:+5V #PWR0113
U 1 1 611F9AFD
P 9450 1500
F 0 "#PWR0113" H 9450 1350 50  0001 C CNN
F 1 "+5V" H 9465 1673 50  0000 C CNN
F 2 "" H 9450 1500 50  0001 C CNN
F 3 "" H 9450 1500 50  0001 C CNN
	1    9450 1500
	1    0    0    -1  
$EndComp
Connection ~ 9450 1500
$Comp
L Device:R R5
U 1 1 611FAE4B
P 10050 2150
F 0 "R5" H 10120 2196 50  0000 L CNN
F 1 "1K" H 10120 2105 50  0000 L CNN
F 2 "" V 9980 2150 50  0001 C CNN
F 3 "~" H 10050 2150 50  0001 C CNN
	1    10050 2150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 611FB3B2
P 10050 2300
F 0 "#PWR0114" H 10050 2050 50  0001 C CNN
F 1 "GND" H 10055 2127 50  0000 C CNN
F 2 "" H 10050 2300 50  0001 C CNN
F 3 "" H 10050 2300 50  0001 C CNN
	1    10050 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C1
U 1 1 611FC1A3
P 10300 2000
F 0 "C1" V 10555 2000 50  0000 C CNN
F 1 "470uF" V 10464 2000 50  0000 C CNN
F 2 "" H 10338 1850 50  0001 C CNN
F 3 "~" H 10300 2000 50  0001 C CNN
	1    10300 2000
	0    -1   -1   0   
$EndComp
Connection ~ 10050 2000
Wire Wire Line
	10050 2000 10150 2000
$Comp
L Connector:Conn_Coaxial J4
U 1 1 61226EE6
P 10650 2000
F 0 "J4" H 10750 1975 50  0000 L CNN
F 1 "COMPOSITE" H 10750 1884 50  0000 L CNN
F 2 "" H 10650 2000 50  0001 C CNN
F 3 " ~" H 10650 2000 50  0001 C CNN
	1    10650 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 2300 10650 2300
Wire Wire Line
	10650 2300 10650 2200
Connection ~ 10050 2300
Wire Wire Line
	7950 2800 9100 2800
Wire Wire Line
	9100 2800 9100 2100
Wire Wire Line
	7950 2800 7950 6300
Wire Wire Line
	7850 4550 8400 4550
Wire Wire Line
	7850 4450 8400 4450
Wire Wire Line
	7850 4350 8400 4350
Wire Wire Line
	7850 4250 8400 4250
Wire Wire Line
	7850 4150 8400 4150
Wire Wire Line
	7850 4050 8400 4050
Wire Wire Line
	7850 3950 8400 3950
Wire Wire Line
	7850 3850 8400 3850
Wire Wire Line
	7050 2350 7050 3850
Wire Wire Line
	7000 2450 7000 3950
Wire Wire Line
	6950 2550 6950 4050
Wire Wire Line
	6900 2650 6900 4150
Wire Wire Line
	6700 4350 7050 4350
Wire Wire Line
	6700 4450 7050 4450
Wire Wire Line
	6700 4550 7050 4550
Wire Wire Line
	6700 4650 7050 4650
Wire Wire Line
	6700 4750 7050 4750
Wire Wire Line
	6700 4850 7050 4850
Wire Bus Line
	6800 3550 6800 4950
Wire Bus Line
	9300 4050 9300 5400
Wire Bus Line
	7150 1950 7150 3550
Text Label 10400 5700 0    50   ~ 0
~INV
$EndSCHEMATC
