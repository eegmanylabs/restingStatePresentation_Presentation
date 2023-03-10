RestingState EEG Presentation Code
#EEGManyLabs
Dr. Leon Kroczek, 2023
leon.kroczek@ur.de

Set-Up Instructions

Before start of the script and before data acquisiton some individual settings need to be adjusted:
These settings concern 
(1) the port of the system by which codes are sent to the EEG system;
(2) language of instructions used in the task: Currently German, English, Dutch, French, and Russian are available 
(3) Screen settings

1) Set-Up Port
Please define ports in the experiment file according to your local set-up
You can do so via:
Settings/Port/Output Ports
Currently serial port COM3 is selected, but this may not be correct for your system

If using a serial port one should check the box on "Emulate parallel


2) Language

Currently German is selected as a default to change language follow instructions below

2A) Language of Audio Instructions
Define the Stimulus Directory in the experiment file as teh correct language:
Scenarios/ Stimulus Directory --> [YourTaskFolder]\Languages\[German|English|French|Dutch|Russian]

2B) Language of written Instruction
The initial instruction is presented via text:
The text is set as a variable by loading from the file [YourTaskFolder]\input\instruction.txt

Edit this file and uncomment the line with the correct language. All other lines should be commented.

(3) Screen settings (Width, Height, and bit depth) shoudl be entered in the RestingState.sce file: Lines 30-223

screen_width = 1920; 					#change according to the screen used (eg. 1920)
screen_height = 1080; 					#change according to the screen used (eg. 1080)
screen_bit_depth = 32;


Before Start:

Please double check if all markers are sent correctly and stimuli are presented in the correct size.
No warranty given.


