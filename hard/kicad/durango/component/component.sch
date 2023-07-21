EESchema Schematic File Version 4
LIBS:component-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Component Video adapter for Durango-X"
Date "2023-02-04"
Rev "v1"
Comp "@zuiko21"
Comment1 "(c) 2023 Carlos J. Santisteban"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Transistor_BJT:BC548 Q1
U 1 1 63DEE1E1
P 3600 2175
F 0 "Q1" H 3475 2050 50  0000 L CNN
F 1 "BC548" H 3450 1975 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 3800 2100 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 3600 2175 50  0001 L CNN
	1    3600 2175
	1    0    0    -1  
$EndComp
$Comp
L Transistor_BJT:BC548 Q2
U 1 1 63DEE71C
P 3900 1975
F 0 "Q2" H 4091 2021 50  0000 L CNN
F 1 "BC548" H 4091 1930 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 4100 1900 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 3900 1975 50  0001 L CNN
	1    3900 1975
	1    0    0    -1  
$EndComp
$Comp
L Transistor_BJT:BC548 Q3
U 1 1 63DEE879
P 5175 2175
F 0 "Q3" H 5050 2050 50  0000 L CNN
F 1 "BC548" H 5025 1975 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 5375 2100 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 5175 2175 50  0001 L CNN
	1    5175 2175
	1    0    0    -1  
$EndComp
$Comp
L Transistor_BJT:BC548 Q4
U 1 1 63DEE9CC
P 5475 1975
F 0 "Q4" H 5666 2021 50  0000 L CNN
F 1 "BC548" H 5666 1930 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 5675 1900 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 5475 1975 50  0001 L CNN
	1    5475 1975
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 63DF53F0
P 3700 1625
F 0 "R4" H 3750 1625 50  0000 L CNN
F 1 "1K" V 3700 1575 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3630 1625 50  0001 C CNN
F 3 "~" H 3700 1625 50  0001 C CNN
	1    3700 1625
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 63DF5C70
P 3400 2525
F 0 "R2" H 3450 2525 50  0000 L CNN
F 1 "3K3" V 3400 2450 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3330 2525 50  0001 C CNN
F 3 "~" H 3400 2525 50  0001 C CNN
	1    3400 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 63DF61C7
P 3700 2525
F 0 "R3" H 3750 2525 50  0000 L CNN
F 1 "1K" V 3700 2475 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3630 2525 50  0001 C CNN
F 3 "~" H 3700 2525 50  0001 C CNN
	1    3700 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 63DF915C
P 4975 2525
F 0 "R11" H 5025 2525 50  0000 L CNN
F 1 "3K3" V 4975 2450 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4905 2525 50  0001 C CNN
F 3 "~" H 4975 2525 50  0001 C CNN
	1    4975 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R12
U 1 1 63DF9166
P 5275 2525
F 0 "R12" H 5325 2525 50  0000 L CNN
F 1 "1K" V 5275 2475 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5205 2525 50  0001 C CNN
F 3 "~" H 5275 2525 50  0001 C CNN
	1    5275 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 63DFB161
P 4000 2525
F 0 "R5" H 4050 2525 50  0000 L CNN
F 1 "330" V 4000 2450 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3930 2525 50  0001 C CNN
F 3 "~" H 4000 2525 50  0001 C CNN
	1    4000 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R14
U 1 1 63DFB780
P 5575 2525
F 0 "R14" H 5625 2525 50  0000 L CNN
F 1 "330" V 5575 2450 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5505 2525 50  0001 C CNN
F 3 "~" H 5575 2525 50  0001 C CNN
	1    5575 2525
	1    0    0    -1  
$EndComp
$Comp
L Device:R R13
U 1 1 63DFBFBE
P 5275 1625
F 0 "R13" H 5325 1625 50  0000 L CNN
F 1 "1K" V 5275 1575 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5205 1625 50  0001 C CNN
F 3 "~" H 5275 1625 50  0001 C CNN
	1    5275 1625
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 63DFC6BC
P 3400 1625
F 0 "R1" H 3450 1625 50  0000 L CNN
F 1 "6K8" V 3400 1550 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3330 1625 50  0001 C CNN
F 3 "~" H 3400 1625 50  0001 C CNN
	1    3400 1625
	1    0    0    -1  
$EndComp
$Comp
L Device:R R10
U 1 1 63DFDD81
P 4975 1625
F 0 "R10" H 5025 1625 50  0000 L CNN
F 1 "6K8" V 4975 1550 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4905 1625 50  0001 C CNN
F 3 "~" H 4975 1625 50  0001 C CNN
	1    4975 1625
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2175 4000 2375
Wire Wire Line
	3400 1775 3400 2175
Connection ~ 3400 2175
Wire Wire Line
	3400 2175 3400 2375
Wire Wire Line
	3700 1775 3700 1975
Connection ~ 3700 1975
Wire Wire Line
	3400 1475 3700 1475
Wire Wire Line
	4000 1475 4000 1775
Connection ~ 3700 1475
Wire Wire Line
	3700 1475 4000 1475
Wire Wire Line
	4000 1475 4975 1475
Wire Wire Line
	5575 1475 5575 1775
Connection ~ 4000 1475
Connection ~ 4975 1475
Wire Wire Line
	4975 1475 5275 1475
Connection ~ 5275 1475
Wire Wire Line
	5275 1475 5575 1475
Wire Wire Line
	5575 2175 5575 2375
Wire Wire Line
	4975 2375 4975 2175
Connection ~ 4975 2175
Wire Wire Line
	4975 2175 4975 1775
Wire Wire Line
	5275 1775 5275 1975
Connection ~ 5275 1975
Wire Wire Line
	3400 2675 3700 2675
Connection ~ 3700 2675
Wire Wire Line
	3700 2675 4000 2675
Connection ~ 4000 2675
Wire Wire Line
	4000 2675 4975 2675
Connection ~ 4975 2675
Wire Wire Line
	4975 2675 5275 2675
Connection ~ 5275 2675
Wire Wire Line
	5275 2675 5575 2675
$Comp
L Device:CP C4
U 1 1 63DFFDC4
P 4200 2325
F 0 "C4" H 4225 2425 50  0000 L CNN
F 1 "100µF" H 4200 2225 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 4238 2175 50  0001 C CNN
F 3 "~" H 4200 2325 50  0001 C CNN
	1    4200 2325
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 2175 4000 2175
Connection ~ 4000 2175
$Comp
L Device:R R9
U 1 1 63E00D65
P 4200 2875
F 0 "R9" H 4050 2875 50  0000 L CNN
F 1 "68" V 4200 2825 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4130 2875 50  0001 C CNN
F 3 "~" H 4200 2875 50  0001 C CNN
	1    4200 2875
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 2475 4200 2725
$Comp
L Device:CP C8
U 1 1 63E0134E
P 5775 2325
F 0 "C8" H 5800 2425 50  0000 L CNN
F 1 "100µF" H 5775 2225 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 5813 2175 50  0001 C CNN
F 3 "~" H 5775 2325 50  0001 C CNN
	1    5775 2325
	1    0    0    -1  
$EndComp
Wire Wire Line
	5775 2175 5575 2175
$Comp
L Device:R R18
U 1 1 63E01359
P 5775 2875
F 0 "R18" H 5575 2875 50  0000 L CNN
F 1 "68" V 5775 2825 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5705 2875 50  0001 C CNN
F 3 "~" H 5775 2875 50  0001 C CNN
	1    5775 2875
	1    0    0    -1  
$EndComp
Wire Wire Line
	5775 2475 5775 2725
Connection ~ 5575 2175
$Comp
L Device:CP C9
U 1 1 63E02D28
P 5775 1625
F 0 "C9" H 5800 1725 50  0000 L CNN
F 1 "470µF" H 5800 1525 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 5813 1475 50  0001 C CNN
F 3 "~" H 5775 1625 50  0001 C CNN
	1    5775 1625
	1    0    0    -1  
$EndComp
$Comp
L Device:C C10
U 1 1 63E035EC
P 6125 1625
F 0 "C10" H 6150 1725 50  0000 L CNN
F 1 "22nF" H 6150 1525 50  0000 L CNN
F 2 "Capacitor_THT:C_Rect_L7.0mm_W2.0mm_P5.00mm" H 6163 1475 50  0001 C CNN
F 3 "~" H 6125 1625 50  0001 C CNN
	1    6125 1625
	1    0    0    -1  
$EndComp
Wire Wire Line
	6125 1475 5775 1475
Connection ~ 5575 1475
Connection ~ 5775 1475
Wire Wire Line
	5775 1475 5575 1475
Wire Wire Line
	5775 1775 6125 1775
Wire Wire Line
	5575 2675 5875 2675
Wire Wire Line
	6125 2675 6125 1775
Connection ~ 5575 2675
Connection ~ 6125 1775
$Comp
L power:+5V #PWR0101
U 1 1 63E05BA4
P 3700 1475
F 0 "#PWR0101" H 3700 1325 50  0001 C CNN
F 1 "+5V" H 3715 1648 50  0000 C CNN
F 2 "" H 3700 1475 50  0001 C CNN
F 3 "" H 3700 1475 50  0001 C CNN
	1    3700 1475
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 63E05E97
P 3700 2675
F 0 "#PWR0102" H 3700 2425 50  0001 C CNN
F 1 "GND" H 3705 2502 50  0000 C CNN
F 2 "" H 3700 2675 50  0001 C CNN
F 3 "" H 3700 2675 50  0001 C CNN
	1    3700 2675
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 63E0614F
P 6125 1475
F 0 "#FLG0101" H 6125 1550 50  0001 C CNN
F 1 "PWR_FLAG" H 6125 1648 50  0000 C CNN
F 2 "" H 6125 1475 50  0001 C CNN
F 3 "~" H 6125 1475 50  0001 C CNN
	1    6125 1475
	1    0    0    -1  
$EndComp
Connection ~ 6125 1475
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 63E06644
P 6125 2675
F 0 "#FLG0102" H 6125 2750 50  0001 C CNN
F 1 "PWR_FLAG" H 5875 2750 50  0000 C CNN
F 2 "" H 6125 2675 50  0001 C CNN
F 3 "~" H 6125 2675 50  0001 C CNN
	1    6125 2675
	-1   0    0    1   
$EndComp
Connection ~ 6125 2675
$Comp
L Device:R R6
U 1 1 63E06A57
P 3100 1975
F 0 "R6" V 3000 1975 50  0000 C CNN
F 1 "1K" V 3100 1975 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3030 1975 50  0001 C CNN
F 3 "~" H 3100 1975 50  0001 C CNN
	1    3100 1975
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 63E06F13
P 3200 2325
F 0 "R8" H 3075 2175 50  0000 L CNN
F 1 "12K" V 3200 2250 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3130 2325 50  0001 C CNN
F 3 "~" H 3200 2325 50  0001 C CNN
	1    3200 2325
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 63E073A6
P 3000 2325
F 0 "R7" H 2875 2175 50  0000 L CNN
F 1 "2K7" V 3000 2250 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 2930 2325 50  0001 C CNN
F 3 "~" H 3000 2325 50  0001 C CNN
	1    3000 2325
	1    0    0    -1  
$EndComp
$Comp
L Device:R R17
U 1 1 63E08EBE
P 4775 2325
F 0 "R17" H 4625 2175 50  0000 L CNN
F 1 "6K8" V 4775 2250 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4705 2325 50  0001 C CNN
F 3 "~" H 4775 2325 50  0001 C CNN
	1    4775 2325
	1    0    0    -1  
$EndComp
$Comp
L Device:R R16
U 1 1 63E08EC8
P 4575 2325
F 0 "R16" H 4425 2175 50  0000 L CNN
F 1 "3K3" V 4575 2250 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4505 2325 50  0001 C CNN
F 3 "~" H 4575 2325 50  0001 C CNN
	1    4575 2325
	1    0    0    -1  
$EndComp
Wire Wire Line
	4575 2175 4775 2175
Connection ~ 4775 2175
Wire Wire Line
	4775 2175 4975 2175
Wire Wire Line
	3700 1975 3250 1975
$Comp
L Device:R R15
U 1 1 63E0DC61
P 4675 1975
F 0 "R15" V 4575 1975 50  0000 C CNN
F 1 "1K" V 4675 1975 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4605 1975 50  0001 C CNN
F 3 "~" H 4675 1975 50  0001 C CNN
	1    4675 1975
	0    1    1    0   
$EndComp
Wire Wire Line
	5275 1975 4825 1975
$Comp
L Device:CP C3
U 1 1 63E10BE9
P 3200 2875
F 0 "C3" H 3200 2975 50  0000 L CNN
F 1 "10µ" H 3200 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 3238 2725 50  0001 C CNN
F 3 "~" H 3200 2875 50  0001 C CNN
	1    3200 2875
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C2
U 1 1 63E10BF3
P 3000 2875
F 0 "C2" H 3000 2975 50  0000 L CNN
F 1 "10µ" H 3000 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 3038 2725 50  0001 C CNN
F 3 "~" H 3000 2875 50  0001 C CNN
	1    3000 2875
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C1
U 1 1 63E10BFD
P 2800 2875
F 0 "C1" H 2800 2975 50  0000 L CNN
F 1 "10µ" H 2800 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 2838 2725 50  0001 C CNN
F 3 "~" H 2800 2875 50  0001 C CNN
	1    2800 2875
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C7
U 1 1 63E13AD2
P 4775 2875
F 0 "C7" H 4775 2975 50  0000 L CNN
F 1 "10µ" H 4775 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 4813 2725 50  0001 C CNN
F 3 "~" H 4775 2875 50  0001 C CNN
	1    4775 2875
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C6
U 1 1 63E13ADC
P 4575 2875
F 0 "C6" H 4575 2975 50  0000 L CNN
F 1 "10µ" H 4575 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 4613 2725 50  0001 C CNN
F 3 "~" H 4575 2875 50  0001 C CNN
	1    4575 2875
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C5
U 1 1 63E13AE6
P 4375 2875
F 0 "C5" H 4375 2975 50  0000 L CNN
F 1 "10µ" H 4375 2775 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D4.0mm_P1.50mm" H 4413 2725 50  0001 C CNN
F 3 "~" H 4375 2875 50  0001 C CNN
	1    4375 2875
	1    0    0    -1  
$EndComp
Wire Wire Line
	4775 2475 4775 2725
Wire Wire Line
	4575 2725 4575 2475
Wire Wire Line
	4375 2725 4375 1975
Wire Wire Line
	4375 1975 4525 1975
Wire Wire Line
	3200 2725 3200 2475
Wire Wire Line
	3000 2725 3000 2475
Wire Wire Line
	2800 2725 2800 1975
Wire Wire Line
	2800 1975 2950 1975
Wire Wire Line
	3000 2175 3200 2175
Connection ~ 3200 2175
Wire Wire Line
	3200 2175 3400 2175
$Comp
L Connector_Generic:Conn_2Rows-21Pins J1
U 1 1 63E19FA1
P 2375 3325
F 0 "J1" H 2425 4042 50  0000 C CNN
F 1 "SCART" H 2425 3925 50  0000 C CNN
F 2 "durango:SCART" H 2375 3325 50  0001 C CNN
F 3 "~" H 2375 3325 50  0001 C CNN
	1    2375 3325
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_Coaxial_x3 J2
U 1 1 63E1DCC9
P 6125 3450
F 0 "J2" H 6225 3453 50  0000 L CNN
F 1 "Component Video [Y/Pb/Pr]" H 6225 3362 50  0000 L CNN
F 2 "durango:3xRCA" H 6125 3450 50  0001 C CNN
F 3 " ~" H 6125 3450 50  0001 C CNN
	1    6125 3450
	1    0    0    -1  
$EndComp
Text Label 2800 2625 0    50   ~ 0
Rr
Text Label 3000 2625 0    50   ~ 0
Gr
Text Label 3200 2625 0    50   ~ 0
Br
Text Label 4375 2625 0    50   ~ 0
Bb
Text Label 4575 2625 0    50   ~ 0
Gb
Text Label 4775 2625 0    50   ~ 0
Rb
Text Label 3175 2175 2    50   ~ 0
BIASr
Text Label 4750 2175 2    50   ~ 0
BIASb
Text Label 3625 1975 2    50   ~ 0
UR
Text Label 5200 1975 2    50   ~ 0
UB
Text Label 3700 2375 0    50   ~ 0
ER
Text Label 5275 2375 0    50   ~ 0
EB
Text Label 4075 2175 0    50   ~ 0
BUFr
Text Label 5650 2175 0    50   ~ 0
BUFb
Text Label 4200 2625 0    50   ~ 0
CR
Text Label 5775 2625 0    50   ~ 0
CB
Text Label 5775 3075 2    50   ~ 0
Pb
Text Label 4200 3075 2    50   ~ 0
Pr
Text Label 2800 3075 0    50   ~ 0
R
Text Label 3000 3075 0    50   ~ 0
G
Text Label 3200 3075 0    50   ~ 0
B
Text Label 4375 3075 0    50   ~ 0
B
Text Label 4575 3075 0    50   ~ 0
G
Text Label 4775 3075 0    50   ~ 0
R
Wire Wire Line
	5875 3750 5875 3550
Connection ~ 5875 2675
Wire Wire Line
	5875 2675 6125 2675
Connection ~ 5875 3350
Wire Wire Line
	5875 3350 5875 2675
Connection ~ 5875 3550
Wire Wire Line
	5875 3550 5875 3350
Wire Wire Line
	5775 3025 5775 3450
Wire Wire Line
	5775 3450 5925 3450
Wire Wire Line
	4200 3025 4200 3250
Wire Wire Line
	4200 3250 5925 3250
Wire Wire Line
	2575 3125 3200 3125
Wire Wire Line
	3200 3125 3200 3025
Wire Wire Line
	4375 3025 4375 3125
Wire Wire Line
	4375 3125 3200 3125
Connection ~ 3200 3125
Wire Wire Line
	2575 3325 3000 3325
Wire Wire Line
	3000 3325 3000 3025
Wire Wire Line
	3000 3325 4575 3325
Wire Wire Line
	4575 3325 4575 3025
Connection ~ 3000 3325
Wire Wire Line
	2575 3525 2800 3525
Wire Wire Line
	2800 3525 2800 3025
Wire Wire Line
	2800 3525 4775 3525
Wire Wire Line
	4775 3525 4775 3025
Connection ~ 2800 3525
$Comp
L Device:R R19
U 1 1 63EA99D0
P 5125 3125
F 0 "R19" V 5125 3375 50  0000 C CNN
F 1 "150" V 5125 3125 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5055 3125 50  0001 C CNN
F 3 "~" H 5125 3125 50  0001 C CNN
	1    5125 3125
	0    1    1    0   
$EndComp
$Comp
L Device:R R20
U 1 1 63EAA1C9
P 5125 3325
F 0 "R20" V 5125 3575 50  0000 C CNN
F 1 "150" V 5125 3325 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5055 3325 50  0001 C CNN
F 3 "~" H 5125 3325 50  0001 C CNN
	1    5125 3325
	0    1    1    0   
$EndComp
$Comp
L Device:R R21
U 1 1 63EAA600
P 5125 3525
F 0 "R21" V 5125 3775 50  0000 C CNN
F 1 "150" V 5125 3525 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5055 3525 50  0001 C CNN
F 3 "~" H 5125 3525 50  0001 C CNN
	1    5125 3525
	0    1    1    0   
$EndComp
Wire Wire Line
	5275 2675 5275 3125
Connection ~ 5275 3125
Wire Wire Line
	5275 3125 5275 3325
Connection ~ 5275 3325
Wire Wire Line
	5275 3325 5275 3525
Wire Wire Line
	4375 3125 4975 3125
Connection ~ 4375 3125
Wire Wire Line
	4575 3325 4975 3325
Connection ~ 4575 3325
Wire Wire Line
	4775 3525 4975 3525
Connection ~ 4775 3525
Wire Wire Line
	5775 3900 5775 3650
Wire Wire Line
	5775 3650 5925 3650
Wire Wire Line
	2075 3125 1975 3125
Wire Wire Line
	1975 3125 1975 1475
Wire Wire Line
	1975 1475 3400 1475
Connection ~ 3400 1475
$Comp
L Device:R R22
U 1 1 63EB6583
P 1925 3675
F 0 "R22" H 1725 3675 50  0000 L CNN
F 1 "12K" V 1925 3600 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 1855 3675 50  0001 C CNN
F 3 "~" H 1925 3675 50  0001 C CNN
	1    1925 3675
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 63EB6EA2
P 1925 3975
F 0 "D1" V 1925 4125 50  0000 R CNN
F 1 "RGB mode" V 1825 4125 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 1925 3975 50  0001 C CNN
F 3 "~" H 1925 3975 50  0001 C CNN
	1    1925 3975
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1925 3525 2075 3525
$Comp
L power:GND #PWR0103
U 1 1 63EBA497
P 1925 4125
F 0 "#PWR0103" H 1925 3875 50  0001 C CNN
F 1 "GND" H 1930 3952 50  0000 C CNN
F 2 "" H 1925 4125 50  0001 C CNN
F 3 "" H 1925 4125 50  0001 C CNN
	1    1925 4125
	1    0    0    -1  
$EndComp
Wire Wire Line
	2575 3025 2625 3025
Wire Wire Line
	2625 3025 2625 3225
Wire Wire Line
	2625 3225 2575 3225
Wire Wire Line
	2625 3225 2625 3425
Wire Wire Line
	2625 3425 2575 3425
Connection ~ 2625 3225
Wire Wire Line
	2625 3425 2625 3625
Wire Wire Line
	2625 3625 2575 3625
Connection ~ 2625 3425
Wire Wire Line
	2625 3625 2625 3825
Wire Wire Line
	2625 3825 2575 3825
Connection ~ 2625 3625
Wire Wire Line
	2075 3625 2025 3625
Wire Wire Line
	2025 3625 2025 3425
Wire Wire Line
	2025 3425 2075 3425
Wire Wire Line
	2025 3425 2025 2925
Wire Wire Line
	2025 2925 2075 2925
Connection ~ 2025 3425
NoConn ~ 2075 3225
NoConn ~ 2075 3325
NoConn ~ 2575 2925
NoConn ~ 2575 2825
Wire Wire Line
	2025 2925 2025 2675
Wire Wire Line
	2025 2675 2625 2675
Connection ~ 2025 2925
Connection ~ 3400 2675
Wire Wire Line
	2625 3025 2625 2675
Connection ~ 2625 3025
Connection ~ 2625 2675
Wire Wire Line
	2625 2675 3400 2675
Text Label 5725 3900 2    50   ~ 0
Y
Text Label 2000 3525 2    50   ~ 0
RGB
Text Label 1925 3825 0    50   ~ 0
LED
Wire Wire Line
	2075 3725 2075 3900
Wire Wire Line
	2075 3900 5775 3900
NoConn ~ 2575 3725
Wire Wire Line
	2075 2825 1700 2825
Wire Wire Line
	1700 2825 1700 3025
Wire Wire Line
	1700 4350 5775 4350
Wire Wire Line
	2075 3025 1700 3025
Connection ~ 1700 3025
Wire Wire Line
	1700 3025 1700 4350
Wire Wire Line
	5925 4550 5775 4550
Wire Wire Line
	5775 4550 5775 4350
Connection ~ 5775 4350
Wire Wire Line
	5775 4350 5925 4350
Connection ~ 5875 3750
Wire Wire Line
	5875 4750 5875 3750
Text Label 5725 4350 2    50   ~ 0
AUDIO
$Comp
L Connector:Conn_Coaxial_x2 J3
U 1 1 64ADAA19
P 6125 4450
F 0 "J3" H 6225 4425 50  0000 L CNN
F 1 "Audio" H 6225 4334 50  0000 L CNN
F 2 "durango:2xRCA_vertical" H 6125 4350 50  0001 C CNN
F 3 " ~" H 6125 4350 50  0001 C CNN
	1    6125 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6125 4750 5875 4750
$Comp
L Mechanical:MountingHole H1
U 1 1 64B085AE
P 3150 4775
F 0 "H1" H 3250 4821 50  0000 L CNN
F 1 "M3" H 3250 4730 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965" H 3150 4775 50  0001 C CNN
F 3 "~" H 3150 4775 50  0001 C CNN
	1    3150 4775
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 64B0D1E0
P 3500 4775
F 0 "H2" H 3600 4821 50  0000 L CNN
F 1 "M3" H 3600 4730 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965" H 3500 4775 50  0001 C CNN
F 3 "~" H 3500 4775 50  0001 C CNN
	1    3500 4775
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 64B0DA00
P 3875 4775
F 0 "H3" H 3975 4821 50  0000 L CNN
F 1 "M3" H 3975 4730 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965" H 3875 4775 50  0001 C CNN
F 3 "~" H 3875 4775 50  0001 C CNN
	1    3875 4775
	1    0    0    -1  
$EndComp
$Comp
L Graphic:Logo_Open_Hardware_Small LOGO1
U 1 1 64B4A91C
P 4675 4800
F 0 "LOGO1" H 4675 5075 50  0001 C CNN
F 1 "Logo_Open_Hardware_Small" H 4675 4575 50  0001 C CNN
F 2 "durango:jaqueria" H 4675 4800 50  0001 C CNN
F 3 "~" H 4675 4800 50  0001 C CNN
	1    4675 4800
	1    0    0    -1  
$EndComp
$EndSCHEMATC
