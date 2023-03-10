############################################################
## Resting State EEG  
## EEG ManyLabs
## Code by Leon Kroczek, 2023
############################################################

############################################################
## Header
############################################################

# Trigger Options
default_output_port 	= 1;						# define in Settings
write_codes 			= true;
pulse_width 			= 5;

response_matching = simple_matching;

# Visual setting
default_background_color 	= 128,128,128;		# grey
default_font 					= "Arial";
default_font_size 			= 25;
default_text_color 			= 255,255,255;	# white

# Buttons
active_buttons 				= 1; 				# Space - define in Settings
response_port_output 		= false;
response_logging 				= log_active;

# Screen setting
screen_width = 1920; 					#change according to the screen used (eg. 1920)
screen_height = 1080; 					#change according to the screen used (eg. 1080)
screen_bit_depth = 32;


begin;

############################################################
## SCE Part
############################################################

# Fixation text
picture{
	text{
		caption = "+"; 
		font_size = 60;
		font = "Open Sans";
	} txt_fixation;
	x = 0; y = 0;
} p_fix;
	

# Instruction Text
picture {
	text {caption = "Test"; 
			font_size = 30;
			max_text_width = 1000;
	}txt_final_instr; 
	x = 0; y = 0;
} p_instr;

# Instruction Sound
sound{
    wavefile { 
      filename	= "";        # PCL Program fills the file name  
      preload 	= false;
    } WAV;
} sound_instr;

# Instruction Trial
trial {
	trial_duration = forever;
	trial_type = first_response;
	
	picture p_instr;
	time = 0;
	
	stimulus_event {
		nothing{};
		time = 2000;
		port_code = 70;
	}ev_start;
}tr_instr;

# Instruction Trial2
trial {
	trial_duration = 6000;
	picture {};
	
	stimulus_event {
		sound sound_instr;
		time = 0;
		port_code = 7;    # PCL Program fills the correct code
	}ev_start2;
	
}tr_instr2;

# Resting State Trial
trial{
	trial_duration = 5000;
	
	stimulus_event{
		picture p_fix;
		time=0;      
		port_code = 1; 		# PCL Program fills the correct code
	}ev_fix;	
	
	stimulus_event{			
		sound sound_instr; 	# PCL Program fills the correct sound  
		time = 0;
	}ev_sound;
	
}tr_resting;

# End Trial
trial{
	trial_duration = 15000;
	
	picture p_fix;
	time=0; 	
	
	stimulus_event{			
		sound sound_instr;
		time = 6000;
		port_code = 71;
	}ev_end;
	
}tr_end;

begin_pcl;

############################################################
## PCL Part
############################################################

# Set Variables from Input File
include "\input\\instruction.txt";
int number_trials  	= 8;

# Generate Random Order
int order = random(1,2);


# Update Instruction Text
txt_final_instr.set_caption(instr_new);
txt_final_instr.redraw();


# Read in Trial Order
string trial_file = "Cond" + string(order) +"_Resting_EEG_trials.txt";

array<string> trial_rando[number_trials][2];
input_file a = new input_file;
a.open(trial_file);
loop
int x = 1;
until x > number_trials
begin
	string line;
	line = a.get_line();
	array<string> parts[1];
	line.split("\t",parts);
	loop
	int y = 1
	until y > 2
		begin
			trial_rando[x][y] = parts[y];
			y = y+1;
		end;
	x = x+1;
end;
a.close();

# Logfile: Add which trial order was used
logfile.add_event_entry("Cond" + string(order) +"_Resting_EEG_trials.txt");

# Present Initial Instruction
tr_instr.present();

# Present Start Trial
WAV.set_filename("Instruction_start_recording.wav");
WAV.load();

if order == 1 then
	ev_start2.set_port_code(7);
else
	ev_start2.set_port_code(8);
end;
	
tr_instr2.present();
WAV.unload();

# Loop across Trials
loop
int t = 1;
until t > number_trials
begin

	# Read Variables from Array
	string instr_file = trial_rando[t][1];
	string code_str   = trial_rando[t][2];
	int code_int      = int(code_str);

	# Update trial codes
	ev_fix.set_port_code(code_int);
	ev_fix.set_event_code(instr_file);
	
	# Update Audio file
	WAV.set_filename(instr_file);
	WAV.load();
	
	# Present Trial
	tr_resting.present();
	WAV.unload();

	# Trial Counter
	t = t +1;
	
end;

# End resting EEG
WAV.set_filename("Instruction_end_recording.wav");
WAV.load();
tr_end.present();
WAV.unload();