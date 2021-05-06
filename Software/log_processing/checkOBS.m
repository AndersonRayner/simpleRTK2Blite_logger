function checkOBS(input_file,figure_number)

%% Check how good the RINEX file came out
[DIR,FILE,EXT] = fileparts(input_file);
fid = fopen(input_file);

xx = 0;
t_obs = [];
n_sats = [];

% Read file
while xx ~= -1
    xx = fgetl(fid);
    if strcmp(xx(1),'>')
        yy = sscanf(xx,'> %d %d %d %d %d %f %d %d');
        t_obs(end+1) = yy(4)*60*60 + yy(5)*60 + yy(6);
        n_sats(end+1) = yy(8);
        
    end
end

fclose(fid);

% Post Calcs
t_obs = t_obs - t_obs(1);
dt = t_obs(2:end) - t_obs(1:end-1);
n_sats(1) = n_sats(2);

% Plots
figure(figure_number); clf; hold all; set(gcf,'name',[FILE,' - obs File']);
subplot(2,1,1); hold all; grid on; grid minor; ...
    title([FILE,' OBS File Consistency'],'interpreter','none');
plot(t_obs(2:end),dt); ...
    xlabel('Time [ s ]'); ylabel({'Time between','Samples [ s ]'});
subplot(2,1,2); hold all; grid on; grid minor; ...
    plot(t_obs,n_sats); ...
    xlabel('Time [ s ]'); ylabel('Sats [ - ]');



