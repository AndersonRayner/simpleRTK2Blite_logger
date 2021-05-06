function ppk_file = runPPK(roverOBS,baseOBS,NAV,rtklib_path,config_file,output_dir)

% Does the PPK for a given set of observation files and nav file

fprintf('Calculating the PPK Solution\n');

[~,FILE,~] = fileparts(roverOBS);
ppk_file = fullfile(output_dir,[FILE,'.pos']);

if exist(fullfile(rtklib_path,'rnx2rtkp_win64.exe'),'file')
    rnx2rtkp_name = fullfile(rtklib_path,'rnx2rtkp_win64');
elseif exist(fullfile(rtklib_path,'rnx2rtkp.exe'),'file')
    rnx2rtkp_name = fullfile(rtklib_path,'rnx2rtkp');
else
    error('Couldn''t find rnx2rtkp');
end

cmd = sprintf('!"%s" -k "%s" -x 2 -o "%s" "%s" "%s" "%s"',rnx2rtkp_name,config_file,ppk_file,roverOBS,baseOBS,NAV);
eval(cmd);

return
end