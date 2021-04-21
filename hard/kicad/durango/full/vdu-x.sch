EESchema Schematic File Version 4
LIBS:full-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
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
L 74xx:74LS161 U?
U 1 1 610E5426
P 2100 2400
AR Path="/610E5426" Ref="U?"  Part="1" 
AR Path="/60C42E7C/610E5426" Ref="U9"  Part="1" 
F 0 "U9" H 2100 3381 50  0000 C CNN
F 1 "74HC161" H 2100 3290 50  0000 C CNN
F 2 "" H 2100 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 2100 2400 50  0001 C CNN
	1    2100 2400
	1    0    0    -1  
$EndComp
$Comp
L 4xxx:4040 U?
U 1 1 610E542C
P 6800 3800
AR Path="/610E542C" Ref="U?"  Part="1" 
AR Path="/60C42E7C/610E542C" Ref="U12"  Part="1" 
F 0 "U12" H 6600 4450 50  0000 C CNN
F 1 "74HCT4040" H 7050 4450 50  0000 C CNN
F 2 "" H 6800 3800 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 6800 3800 50  0001 C CNN
	1    6800 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 1900 1600 2000
Connection ~ 1600 2000
Wire Wire Line
	1600 2000 1600 2100
Connection ~ 1600 2100
Wire Wire Line
	1600 2100 1600 2200
$Comp
L power:GND #PWR?
U 1 1 610E5437
P 1600 2200
AR Path="/610E5437" Ref="#PWR?"  Part="1" 
AR Path="/60C42E7C/610E5437" Ref="#PWR0109"  Part="1" 
F 0 "#PWR0109" H 1600 1950 50  0001 C CNN
F 1 "GND" H 1700 2150 50  0000 C CNN
F 2 "" H 1600 2200 50  0001 C CNN
F 3 "" H 1600 2200 50  0001 C CNN
	1    1600 2200
	1    0    0    -1  
$EndComp
Connection ~ 1600 2200
Wire Wire Line
	1600 2400 1550 2400
Wire Wire Line
	1550 2400 1550 1600
Wire Wire Line
	1550 1600 2100 1600
Wire Wire Line
	1600 2400 1600 2500
Connection ~ 1600 2400
Connection ~ 1600 2500
Wire Wire Line
	1600 2500 1600 2600
Wire Wire Line
	1600 2700 1550 2700
Wire Wire Line
	1550 2700 1550 3250
Wire Wire Line
	1550 3250 3000 3250
Wire Wire Line
	2600 1900 2600 1350
Wire Wire Line
	2600 2000 2700 2000
Wire Wire Line
	2700 2000 2700 1350
Wire Wire Line
	2600 2100 2800 2100
Wire Wire Line
	2800 2100 2800 1350
Wire Wire Line
	2600 2200 2900 2200
Wire Wire Line
	2900 2200 2900 1350
$Comp
L 74xx:74LS161 U?
U 1 1 610E544F
P 3550 2400
AR Path="/610E544F" Ref="U?"  Part="1" 
AR Path="/60C42E7C/610E544F" Ref="U10"  Part="1" 
F 0 "U10" H 3550 3381 50  0000 C CNN
F 1 "74HC161" H 3550 3290 50  0000 C CNN
F 2 "" H 3550 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3550 2400 50  0001 C CNN
	1    3550 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 2400 3000 1600
Wire Wire Line
	3000 1600 3550 1600
Wire Wire Line
	3000 2400 3050 2400
Wire Wire Line
	4050 1900 4050 1350
Wire Wire Line
	4050 2000 4150 2000
Wire Wire Line
	4150 2000 4150 1350
Wire Wire Line
	4050 2100 4250 2100
Wire Wire Line
	4250 2100 4250 1350
Wire Wire Line
	4050 2200 4350 2200
Wire Wire Line
	4350 2200 4350 1350
Wire Wire Line
	3050 2700 3000 2700
Wire Wire Line
	3000 2700 3000 3250
Connection ~ 3000 3250
Wire Wire Line
	3000 3250 4450 3250
$Comp
L 74xx:74LS161 U?
U 1 1 610E5463
P 5000 2400
AR Path="/610E5463" Ref="U?"  Part="1" 
AR Path="/60C42E7C/610E5463" Ref="U11"  Part="1" 
F 0 "U11" H 5000 3381 50  0000 C CNN
F 1 "74HC161" H 5000 3290 50  0000 C CNN
F 2 "" H 5000 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 5000 2400 50  0001 C CNN
	1    5000 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 1600 5000 1600
Wire Wire Line
	4450 1600 4450 2400
Wire Wire Line
	4450 2400 4500 2400
Wire Wire Line
	3050 1900 3050 2000
Connection ~ 3050 2000
Wire Wire Line
	3050 2000 3050 2100
Connection ~ 3050 2100
Wire Wire Line
	3050 2100 3050 2200
Wire Wire Line
	4500 1900 4500 2000
Connection ~ 4500 2000
Wire Wire Line
	4500 2000 4500 2100
Connection ~ 4500 2100
Wire Wire Line
	4500 2100 4500 2200
$Comp
L power:GND #PWR?
U 1 1 610E5476
P 3050 2200
AR Path="/610E5476" Ref="#PWR?"  Part="1" 
AR Path="/60C42E7C/610E5476" Ref="#PWR0110"  Part="1" 
F 0 "#PWR0110" H 3050 1950 50  0001 C CNN
F 1 "GND" H 3150 2150 50  0000 C CNN
F 2 "" H 3050 2200 50  0001 C CNN
F 3 "" H 3050 2200 50  0001 C CNN
	1    3050 2200
	1    0    0    -1  
$EndComp
Connection ~ 3050 2200
$Comp
L power:GND #PWR?
U 1 1 610E547D
P 4500 2200
AR Path="/610E547D" Ref="#PWR?"  Part="1" 
AR Path="/60C42E7C/610E547D" Ref="#PWR0111"  Part="1" 
F 0 "#PWR0111" H 4500 1950 50  0001 C CNN
F 1 "GND" H 4600 2150 50  0000 C CNN
F 2 "" H 4500 2200 50  0001 C CNN
F 3 "" H 4500 2200 50  0001 C CNN
	1    4500 2200
	1    0    0    -1  
$EndComp
Connection ~ 4500 2200
Wire Wire Line
	5500 1900 5500 1350
Wire Wire Line
	5500 2000 5600 2000
Wire Wire Line
	5600 2000 5600 1350
Wire Wire Line
	5500 2100 5700 2100
Wire Wire Line
	5700 2100 5700 1350
Wire Wire Line
	5500 2200 5800 2200
Wire Wire Line
	5800 2200 5800 1350
Wire Wire Line
	2100 3200 3550 3200
Connection ~ 3550 3200
Wire Wire Line
	3550 3200 5000 3200
Wire Wire Line
	2100 3200 1400 3200
Wire Wire Line
	1250 3200 1250 3000
Connection ~ 2100 3200
$Comp
L power:GND #PWR?
U 1 1 610E5491
P 1250 3200
AR Path="/610E5491" Ref="#PWR?"  Part="1" 
AR Path="/60C42E7C/610E5491" Ref="#PWR0112"  Part="1" 
F 0 "#PWR0112" H 1250 2950 50  0001 C CNN
F 1 "GND" H 1255 3027 50  0000 C CNN
F 2 "" H 1250 3200 50  0001 C CNN
F 3 "" H 1250 3200 50  0001 C CNN
	1    1250 3200
	1    0    0    -1  
$EndComp
Connection ~ 1250 3200
Wire Wire Line
	2100 1600 3000 1600
Connection ~ 2100 1600
Connection ~ 3000 1600
Wire Wire Line
	3550 1600 4450 1600
Connection ~ 3550 1600
Connection ~ 4450 1600
$Comp
L power:+5V #PWR?
U 1 1 610E549E
P 1550 1600
AR Path="/610E549E" Ref="#PWR?"  Part="1" 
AR Path="/60C42E7C/610E549E" Ref="#PWR0113"  Part="1" 
F 0 "#PWR0113" H 1550 1450 50  0001 C CNN
F 1 "+5V" H 1565 1773 50  0000 C CNN
F 2 "" H 1550 1600 50  0001 C CNN
F 3 "" H 1550 1600 50  0001 C CNN
	1    1550 1600
	1    0    0    -1  
$EndComp
Connection ~ 1550 1600
$Comp
L power:PWR_FLAG #FLG?
U 1 1 610E54A5
P 3000 1600
AR Path="/610E54A5" Ref="#FLG?"  Part="1" 
AR Path="/60C42E7C/610E54A5" Ref="#FLG0103"  Part="1" 
F 0 "#FLG0103" H 3000 1675 50  0001 C CNN
F 1 "PWR_FLAG" H 3000 1773 50  0000 C CNN
F 2 "" H 3000 1600 50  0001 C CNN
F 3 "~" H 3000 1600 50  0001 C CNN
	1    3000 1600
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG?
U 1 1 610E54AB
P 1400 3200
AR Path="/610E54AB" Ref="#FLG?"  Part="1" 
AR Path="/60C42E7C/610E54AB" Ref="#FLG0104"  Part="1" 
F 0 "#FLG0104" H 1400 3275 50  0001 C CNN
F 1 "PWR_FLAG" H 1500 3100 50  0000 C CNN
F 2 "" H 1400 3200 50  0001 C CNN
F 3 "~" H 1400 3200 50  0001 C CNN
	1    1400 3200
	1    0    0    -1  
$EndComp
Connection ~ 1400 3200
Wire Wire Line
	1400 3200 1250 3200
Wire Wire Line
	3050 2500 2950 2500
Wire Wire Line
	2950 2500 2950 2400
Wire Wire Line
	2950 2400 2600 2400
Wire Wire Line
	3050 2500 3050 2600
Connection ~ 3050 2500
Wire Wire Line
	4500 2500 4500 2600
Wire Wire Line
	4500 2500 4400 2500
Wire Wire Line
	4400 2500 4400 2400
Wire Wire Line
	4400 2400 4050 2400
Connection ~ 4500 2500
NoConn ~ 5500 2400
Wire Wire Line
	1600 2900 1600 3300
Wire Wire Line
	1600 3300 3050 3300
Wire Wire Line
	3050 3300 3050 2900
Wire Wire Line
	3050 3300 4500 3300
Wire Wire Line
	4500 3300 4500 2900
Connection ~ 3050 3300
Wire Wire Line
	4450 3250 4450 2700
Wire Wire Line
	4450 2700 4500 2700
Connection ~ 4500 3300
Wire Wire Line
	7300 3300 7300 1350
Wire Wire Line
	7300 3400 7400 3400
Wire Wire Line
	7400 3400 7400 1350
Wire Wire Line
	7300 3500 7500 3500
Wire Wire Line
	7500 3500 7500 1350
Wire Wire Line
	7300 3600 7500 3600
Wire Wire Line
	7600 3600 7600 1350
Wire Wire Line
	7300 3700 7700 3700
Wire Wire Line
	7700 3700 7700 1350
Wire Wire Line
	7300 3800 7800 3800
Wire Wire Line
	7800 3800 7800 1350
Wire Wire Line
	7900 3900 7900 1350
Wire Wire Line
	7300 4000 8000 4000
Wire Wire Line
	8000 4000 8000 1350
NoConn ~ 7300 4200
NoConn ~ 7300 4300
NoConn ~ 7300 4400
Connection ~ 1550 2700
$Comp
L Oscillator:ACO-xxxMHz X?
U 1 1 610E54DD
P 1250 2700
AR Path="/610E54DD" Ref="X?"  Part="1" 
AR Path="/60C42E7C/610E54DD" Ref="X1"  Part="1" 
F 0 "X1" H 1000 2750 50  0000 R CNN
F 1 "24.576 MHz" H 1000 2650 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 1700 2350 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 1150 2700 50  0001 C CNN
	1    1250 2700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS20 U13
U 1 1 6110CD6A
P 3700 3750
F 0 "U13" H 3700 4125 50  0000 C CNN
F 1 "74HC20" H 3700 4034 50  0000 C CNN
F 2 "" H 3700 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS20" H 3700 3750 50  0001 C CNN
	1    3700 3750
	-1   0    0    -1  
$EndComp
$Comp
L 74xx:74LS20 U13
U 2 1 6110E097
P 7650 4500
F 0 "U13" V 7750 4850 50  0000 R CNN
F 1 "74HC20" V 7850 4900 50  0000 R CNN
F 2 "" H 7650 4500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS20" H 7650 4500 50  0001 C CNN
	2    7650 4500
	0    -1   1    0   
$EndComp
$Comp
L power:+5V #PWR0114
U 1 1 6112D9B0
P 4000 3600
F 0 "#PWR0114" H 4000 3450 50  0001 C CNN
F 1 "+5V" H 4015 3773 50  0000 C CNN
F 2 "" H 4000 3600 50  0001 C CNN
F 3 "" H 4000 3600 50  0001 C CNN
	1    4000 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 4100 7600 4100
Wire Wire Line
	7800 4200 7800 3800
Connection ~ 7800 3800
Wire Wire Line
	7700 3700 7700 4200
Connection ~ 7700 3700
Wire Wire Line
	7500 3600 7500 4200
Connection ~ 7500 3600
Wire Wire Line
	7500 3600 7600 3600
Wire Wire Line
	7300 3900 7900 3900
Wire Wire Line
	7600 4200 7600 4100
Connection ~ 7600 4100
Wire Wire Line
	7600 4100 8100 4100
Wire Wire Line
	1550 1600 1250 1600
Wire Wire Line
	1250 1600 1250 2400
Text Label 8000 1750 1    50   ~ 0
VA19
Text Label 7900 1750 1    50   ~ 0
VA18
Text Label 7800 1750 1    50   ~ 0
VA17
Text Label 7700 1750 1    50   ~ 0
VA16
Text Label 7600 1750 1    50   ~ 0
VA15
Text Label 7500 1750 1    50   ~ 0
VA14
Text Label 7400 1750 1    50   ~ 0
VA13
Text Label 7300 1750 1    50   ~ 0
VA12
Text Label 5800 1750 1    50   ~ 0
VA11
Text Label 5700 1750 1    50   ~ 0
VA10
Text Label 5600 1750 1    50   ~ 0
VA9
Text Label 5500 1750 1    50   ~ 0
VA8
Text Label 4350 1750 1    50   ~ 0
VA7
Text Label 4250 1750 1    50   ~ 0
VA6
Text Label 4150 1750 1    50   ~ 0
VA5
Text Label 4050 1750 1    50   ~ 0
VA4
Text Label 2900 1750 1    50   ~ 0
VA3
Text Label 2800 1750 1    50   ~ 0
VA2
Text Label 2700 1750 1    50   ~ 0
VA1
Text Label 2600 1750 1    50   ~ 0
VA0
Entry Wire Line
	8000 1350 8100 1250
Entry Wire Line
	7900 1350 8000 1250
Entry Wire Line
	7800 1350 7900 1250
Entry Wire Line
	7700 1350 7800 1250
Entry Wire Line
	7600 1350 7700 1250
Entry Wire Line
	7500 1350 7600 1250
Entry Wire Line
	7400 1350 7500 1250
Entry Wire Line
	7300 1350 7400 1250
Entry Wire Line
	5800 1350 5900 1250
Entry Wire Line
	5700 1350 5800 1250
Entry Wire Line
	5600 1350 5700 1250
Entry Wire Line
	5500 1350 5600 1250
Entry Wire Line
	4350 1350 4450 1250
Entry Wire Line
	4250 1350 4350 1250
Entry Wire Line
	4150 1350 4250 1250
Entry Wire Line
	4050 1350 4150 1250
Entry Wire Line
	2900 1350 3000 1250
Entry Wire Line
	2800 1350 2900 1250
Entry Wire Line
	2700 1350 2800 1250
Entry Wire Line
	2600 1350 2700 1250
Text GLabel 8100 1250 2    50   Input ~ 0
VA[0..19]
Wire Wire Line
	5000 1600 6800 1600
Wire Wire Line
	6800 1600 6800 3000
$Comp
L power:GND #PWR0117
U 1 1 61380C56
P 6800 4700
F 0 "#PWR0117" H 6800 4450 50  0001 C CNN
F 1 "GND" H 6650 4650 50  0000 C CNN
F 2 "" H 6800 4700 50  0001 C CNN
F 3 "" H 6800 4700 50  0001 C CNN
	1    6800 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3700 4000 3700
Wire Wire Line
	5700 3800 4000 3800
Wire Wire Line
	4500 3300 6300 3300
Wire Wire Line
	3050 3300 3050 3750
Wire Wire Line
	3050 3750 3400 3750
$Comp
L 74xx:74LS85 U14
U 1 1 607EF60C
P 5400 4600
F 0 "U14" V 5050 5250 50  0000 R CNN
F 1 "74HC85" V 5050 4200 50  0000 R CNN
F 2 "" H 5400 4600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS85" H 5400 4600 50  0001 C CNN
	1    5400 4600
	0    -1   1    0   
$EndComp
$Comp
L 74xx:74LS85 U15
U 1 1 607F05F3
P 8900 4600
F 0 "U15" V 8550 4150 50  0000 R CNN
F 1 "74HC85" V 9250 4200 50  0000 R CNN
F 2 "" H 8900 4600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS85" H 8900 4600 50  0001 C CNN
	1    8900 4600
	0    -1   1    0   
$EndComp
Wire Wire Line
	4700 4600 4700 5100
NoConn ~ 5600 5100
NoConn ~ 5700 5100
NoConn ~ 9100 5100
NoConn ~ 9200 5100
Wire Wire Line
	8200 4600 8200 5100
Wire Wire Line
	8200 5100 8500 5100
Connection ~ 8500 5100
Wire Wire Line
	8500 5100 8600 5100
$Comp
L power:GND #PWR0118
U 1 1 6080613A
P 9600 4600
F 0 "#PWR0118" H 9600 4350 50  0001 C CNN
F 1 "GND" H 9605 4427 50  0000 C CNN
F 2 "" H 9600 4600 50  0001 C CNN
F 3 "" H 9600 4600 50  0001 C CNN
	1    9600 4600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 608064C6
P 6100 4600
F 0 "#PWR0119" H 6100 4350 50  0001 C CNN
F 1 "GND" H 6105 4427 50  0000 C CNN
F 2 "" H 6100 4600 50  0001 C CNN
F 3 "" H 6100 4600 50  0001 C CNN
	1    6100 4600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0120
U 1 1 6080689B
P 4700 4600
F 0 "#PWR0120" H 4700 4450 50  0001 C CNN
F 1 "+5V" V 4715 4728 50  0000 L CNN
F 2 "" H 4700 4600 50  0001 C CNN
F 3 "" H 4700 4600 50  0001 C CNN
	1    4700 4600
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0121
U 1 1 60806BB3
P 8200 4600
F 0 "#PWR0121" H 8200 4450 50  0001 C CNN
F 1 "+5V" H 8215 4773 50  0000 C CNN
F 2 "" H 8200 4600 50  0001 C CNN
F 3 "" H 8200 4600 50  0001 C CNN
	1    8200 4600
	1    0    0    -1  
$EndComp
Connection ~ 8200 4600
Text Label 5800 5100 0    50   ~ 0
HSYNC
Text Label 9300 5100 0    50   ~ 0
VSYNC
Text Label 5850 2200 0    50   ~ 0
~DEH
Text Label 7950 4100 0    50   ~ 0
~DEV
Wire Wire Line
	5800 2200 8100 2200
Connection ~ 5800 2200
Wire Wire Line
	8100 4100 8100 2400
$Comp
L 74xx:74HCT02 U16
U 1 1 6080EDF3
P 8400 2300
F 0 "U16" H 8400 2625 50  0000 C CNN
F 1 "74HCT02*" H 8400 2534 50  0000 C CNN
F 2 "" H 8400 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 8400 2300 50  0001 C CNN
	1    8400 2300
	1    0    0    -1  
$EndComp
Text Label 8700 2300 0    50   ~ 0
DE
Text Label 3200 3750 0    50   ~ 0
~LEND
Text Label 7650 4900 0    50   ~ 0
~FEND
Wire Wire Line
	5800 3900 4000 3900
Wire Wire Line
	5800 2200 5800 3900
Wire Wire Line
	5700 3800 5700 2100
Connection ~ 5700 2100
Connection ~ 4250 2100
Wire Wire Line
	4250 2100 4250 3700
Wire Wire Line
	5800 4100 5800 3900
Connection ~ 5800 3900
Wire Wire Line
	5700 4100 5700 3800
Connection ~ 5700 3800
Wire Wire Line
	5600 4100 5600 2000
Connection ~ 5600 2000
Connection ~ 5500 1900
Wire Wire Line
	5500 1900 5500 4100
Wire Wire Line
	4700 5100 5000 5100
Connection ~ 5000 1600
Connection ~ 4700 4600
Wire Wire Line
	5300 4100 5300 4000
Wire Wire Line
	5300 4000 5000 4000
Wire Wire Line
	5000 4000 5000 4100
Wire Wire Line
	5000 4000 4700 4000
Wire Wire Line
	4700 4000 4700 4600
Connection ~ 5000 4000
Wire Wire Line
	5200 4100 5200 4050
Wire Wire Line
	5200 4050 6100 4050
Wire Wire Line
	6100 4050 6100 4600
Connection ~ 6100 4600
Connection ~ 5000 5100
Wire Wire Line
	5000 5100 5100 5100
Connection ~ 5100 5100
Wire Wire Line
	5100 5100 5200 5100
Wire Wire Line
	5200 4050 5100 4050
Wire Wire Line
	5100 4050 5100 4100
Connection ~ 5200 4050
Wire Wire Line
	8100 4100 8100 5150
Wire Wire Line
	8100 5150 8700 5150
Wire Wire Line
	8700 5150 8700 5100
Connection ~ 8100 4100
Wire Wire Line
	7800 3800 9000 3800
Wire Wire Line
	9000 3800 9000 4100
Wire Wire Line
	7700 3700 9100 3700
Wire Wire Line
	9100 3700 9100 4100
Wire Wire Line
	7600 3600 9200 3600
Wire Wire Line
	9200 3600 9200 4100
Connection ~ 7600 3600
Wire Wire Line
	7500 3500 9300 3500
Wire Wire Line
	9300 3500 9300 4100
Connection ~ 7500 3500
Wire Wire Line
	8500 4100 8500 4050
Wire Wire Line
	8500 4050 8700 4050
Wire Wire Line
	8700 4050 8700 4100
Wire Wire Line
	8600 4100 8600 4000
Wire Wire Line
	8600 4000 8800 4000
Wire Wire Line
	8800 4000 8800 4100
$Comp
L power:+5V #PWR0122
U 1 1 608EF096
P 8800 4000
F 0 "#PWR0122" H 8800 3850 50  0001 C CNN
F 1 "+5V" H 8800 4150 50  0000 C CNN
F 2 "" H 8800 4000 50  0001 C CNN
F 3 "" H 8800 4000 50  0001 C CNN
	1    8800 4000
	1    0    0    -1  
$EndComp
Connection ~ 8800 4000
$Comp
L power:GND #PWR0123
U 1 1 608EF4C1
P 8500 4050
F 0 "#PWR0123" H 8500 3800 50  0001 C CNN
F 1 "GND" V 8505 3922 50  0000 R CNN
F 2 "" H 8500 4050 50  0001 C CNN
F 3 "" H 8500 4050 50  0001 C CNN
	1    8500 4050
	0    1    1    0   
$EndComp
Connection ~ 8500 4050
$Comp
L 74xx:74HCT02 U16
U 2 1 608EFBD8
P 7100 5100
F 0 "U16" H 7100 5425 50  0000 C CNN
F 1 "74HCT02*" H 7100 5334 50  0000 C CNN
F 2 "" H 7100 5100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hct02" H 7100 5100 50  0001 C CNN
	2    7100 5100
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6300 3600 6300 5100
Wire Wire Line
	6300 5100 6800 5100
Wire Wire Line
	7400 5000 7650 5000
Wire Wire Line
	7650 5000 7650 4800
$Comp
L power:GND #PWR0124
U 1 1 60903516
P 7400 5200
F 0 "#PWR0124" H 7400 4950 50  0001 C CNN
F 1 "GND" H 7405 5027 50  0000 C CNN
F 2 "" H 7400 5200 50  0001 C CNN
F 3 "" H 7400 5200 50  0001 C CNN
	1    7400 5200
	1    0    0    -1  
$EndComp
Text Notes 4100 3600 0    50   ~ 0
May use an HC10 here,\nplacing U13A for ~LE
Wire Bus Line
	2700 1250 8100 1250
Text Notes 8600 2650 0    50   ~ 0
SPLIT IN TWO ‘175 INPUTS\nGATED BY ~HIRES~ AND ~COL\n\nPERHAPS VIA A ‘257
$EndSCHEMATC
