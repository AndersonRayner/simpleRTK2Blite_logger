function [rinex_obs,rinex_nav] = extractRINEX(input_file,output_dir,rtklib_path)
%% Convert file to RINEX
% from http://www.rtklib.com/prog/manual_2.4.2.pdf and http://rtkexplorer.com/downloads/rtklib-code/

% Start Stuff
[DIR,FILE,EXT] = fileparts(input_file);
fprintf('Converting %s.%s to RINEX\n',FILE,EXT);

% Create output directory
RINEX2_dir = fullfile(output_dir,'RINEX_2x');
RINEX3_dir = fullfile(output_dir,'RINEX_3x');

if ~exist(RINEX2_dir,'dir'); mkdir(RINEX2_dir); end
if ~exist(RINEX3_dir,'dir'); mkdir(RINEX3_dir); end

% Create RINEX File
% v2.12
cmd1 = sprintf('!"%s" -r ubx -v 2.12 -od -os -oi -ot -hc "%s" -d "%s" "%s"',fullfile(rtklib_path,'convbin'),['Log File: ',FILE,EXT],RINEX2_dir,input_file);

% v3.x
cmd2 = sprintf('!"%s" -r ubx -od -os -oi -ot -hc "%s" -d "%s" "%s"',fullfile(rtklib_path,'convbin'),['Log File: ',FILE,EXT],RINEX3_dir,input_file);

eval(cmd1);
eval(cmd2);

% Done
rinex_obs = fullfile(RINEX3_dir,[FILE,'.obs']);
rinex_nav = fullfile(RINEX3_dir,[FILE,'.nav']);

return
end