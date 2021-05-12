% Script for doing all the simpleRTK logger stuff
clear all
clc
fclose('all');

root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-05-03_North_Field\data\gps_logs';

input_file_Rover = fullfile(root_dir,'ROVER.TXT');
input_file_Base  = fullfile(root_dir,'BASE.TXT');  % BASE.TXT

output_dir       = fullfile(root_dir,'outputs');
images_dir       = fullfile(root_dir,'images');

rtklib_path = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\RTKlib\demo5_b33d';
% rtklib_path = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\RTKlib\demo5_b34a';
ppk_config_file = 'C:\Users\matt\Documents\DARTS\DARTS\GPS_Logger\Configuration Files\RTKlib\dualband-rtk1.conf';

%% Set up folder structures
if ~exist(output_dir,'dir'); mkdir(output_dir); end
if ~exist(images_dir,'dir'); mkdir(images_dir); end

%% Get GPS Positions from files
% Find base station position reference position
BASE = extractGNGGA(input_file_Base,[0,0,0],output_dir);
base_ref = [BASE.lat(end),BASE.lon(end),BASE.alt(end)];

% Calculate all positions
BASE = extractGNGGA(input_file_Base,base_ref,output_dir);
ROVER_RTK = extractGNGGA(input_file_Rover,base_ref,output_dir);

%% Extract RINEX Date from files
[OBS_Rover,NAV_Rover] = extractRINEX(input_file_Rover,output_dir,rtklib_path);
[OBS_Base ,NAV_Base ] = extractRINEX(input_file_Base ,output_dir,rtklib_path);

% Check quality of RINEX files
checkOBS(OBS_Rover,1);
checkOBS(OBS_Base,2);

%% Run and read the PPK
ppk_file = runPPK(OBS_Rover,OBS_Base,NAV_Base,rtklib_path,ppk_config_file,output_dir);
ROVER_PPK = readPOS(ppk_file);

%% Plot Results
a = lines;

t_offset = min([min(ROVER_RTK.t),min(ROVER_PPK.t)]);
ROVER_RTK.t = ROVER_RTK.t - t_offset;
ROVER_PPK.t = ROVER_PPK.t - t_offset;
BASE.t =      BASE.t - t_offset;

for ii = 2:numel(ROVER_RTK.t); ROVER_RTK.t_samples(ii) = ROVER_RTK.t(ii) - ROVER_RTK.t(ii-1); end
for ii = 2:numel(ROVER_PPK.t); ROVER_PPK.t_samples(ii) = ROVER_PPK.t(ii) - ROVER_PPK.t(ii-1); end

figure(4); clf; hold all; set(gcf,'name','Solution Comparison Map'); set(gcf,'position',[115 48 1758 911]);
subplot(1,2,1); hold all; grid on; grid minor; ...
    plot(ROVER_RTK.E,ROVER_RTK.N,'displayName','Rover RTK'); ...
    plot(ROVER_PPK.E,ROVER_PPK.N,'displayName','Rover PPK'); ...
    plot(0,0,'o','markerSize',10,'lineWidth',1.4,'displayName','Base Station'); ...
    axis equal; legend show; legend boxoff; ...
    xlabel('Position E [ m ]'); ylabel('Position N [ m ]');
subplot(3,2,2); hold all; grid on; grid minor; ...
    plot(ROVER_RTK.t,ROVER_RTK.fix,'displayName','Rover RTK'); ...
    plot(ROVER_PPK.t,ROVER_PPK.fix,'displayName','Rover PPK'); ...
    yticks([0:5]); yticklabels({'None','Single','DGPS','-','RTK-Fixed','RTK-Float'}); ...
    legend show; legend boxoff; legend('location','southEast'); ...
    ylabel('Fix Type [ - ]'); xlabel('Time [ s ]');
subplot(3,2,4); hold all; grid on; grid minor; ...
    plot(ROVER_RTK.t,ROVER_RTK.sats,'displayName','Rover RTK'); ...
    plot(ROVER_PPK.t,ROVER_PPK.sats,'displayName','Rover PPK'); ...
    plot(     BASE.t,     BASE.sats,'displayName','Base');      ...
    legend show; legend boxoff; legend('location','southEast'); ...
    ylabel('Satellites [ - ]'); xlabel('Time [ s ]');
subplot(3,2,6); hold all; grid on; grid minor; ...
    plot(ROVER_RTK.t,ROVER_RTK.t_samples,'displayName','Rover RTK'); ...
    plot(ROVER_PPK.t,ROVER_PPK.t_samples,'displayName','Rover PPK'); ...
    xlabel('Time [ s ]'); ylabel('Time between Samples [ s ]'); ...
    legend show; legend boxoff; legend('location','northEast'); ...

figure(6); clf; set(gcf,'name','PPK Accuracy'); set(gcf,'position',[115 48 1758 911]);
subplot(2,4,1); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.sdN,'displayName','North'); ...
    plot(ROVER_PPK.t,ROVER_PPK.sdE,'displayName','East'); ...
    plot(ROVER_PPK.t,ROVER_PPK.sdU,'displayName','Up'); ...
    xlabel('Time [ s ]'); ylabel('Standard Deviation [ m ]'); ...
    legend show; legend boxoff; ylim([0,1]);
subplot(2,4,2); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.VN,'displayName','North'); ...
    plot(ROVER_PPK.t,ROVER_PPK.VE,'displayName','East'); ...
    plot(ROVER_PPK.t,ROVER_PPK.VU,'displayName','Up'); ...
    xlabel('Time [ s ]'); ylabel('Velocity [ m/s ]'); ...
    legend show; legend boxoff;
subplot(2,4,5); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.fix); ...
    xlabel('Time [ s ]'); ylabel('Fix Type [ - ]'); ...
    yticks([0:5]); yticklabels({'None','Single','DGPS','-','RTK-Fixed','RTK-Float'});
subplot(2,4,6); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.sats); ...
    xlabel('Time [ s ]'); ylabel('Satellites [ - ]');
subplot(3,2,[2,4]); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.E,ROVER_PPK.N,'-','color',[0.8,0.8,0.8],'displayName','Path'); ...
    locs = find(ROVER_PPK.fix==1); plot(ROVER_PPK.E(locs),ROVER_PPK.N(locs),'.','color',a(4,:),'displayName','Single'); ... % Single
    locs = find(ROVER_PPK.fix==2); plot(ROVER_PPK.E(locs),ROVER_PPK.N(locs),'.','color',a(3,:),'displayName','DGPS'); ... % DGPS
    locs = find(ROVER_PPK.fix==5); plot(ROVER_PPK.E(locs),ROVER_PPK.N(locs),'.','color',a(2,:),'displayName','RTK-Float'); ... % RTK-Float
    locs = find(ROVER_PPK.fix==4); plot(ROVER_PPK.E(locs),ROVER_PPK.N(locs),'.','color',a(1,:),'displayName','RTK-Fixed'); ... % RTK-Fixed
    axis equal; legend show; legend boxoff; ...
    xlabel('Position E [ m ]'); ylabel('Position N [ m ]');
subplot(3,2,6); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.U,'-','color',[0.8,0.8,0.8],'displayName','Path'); ...    
    locs = find(ROVER_PPK.fix==1); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(4,:),'displayName','Single'); ... % Single
    locs = find(ROVER_PPK.fix==2); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(3,:),'displayName','DGPS'); ... % DGPS
    locs = find(ROVER_PPK.fix==5); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(2,:),'displayName','RTK-Float'); ... % RTK-Float
    locs = find(ROVER_PPK.fix==4); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(1,:),'displayName','RTK-Fixed'); ... % RTK-Fixed
    legend show; legend boxoff; ...
    xlabel('Time [ s ]'); ylabel('Altitude [ m ]');

figure(7); clf; hold all;
subplot(3,1,1); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.N,'-','color',[0.8,0.8,0.8],'displayName','Path'); ...    
    locs = find(ROVER_PPK.fix==1); plot(ROVER_PPK.t(locs),ROVER_PPK.N(locs),'.','color',a(4,:),'displayName','Single'); ... % Single
    locs = find(ROVER_PPK.fix==2); plot(ROVER_PPK.t(locs),ROVER_PPK.N(locs),'.','color',a(3,:),'displayName','DGPS'); ... % DGPS
    locs = find(ROVER_PPK.fix==5); plot(ROVER_PPK.t(locs),ROVER_PPK.N(locs),'.','color',a(2,:),'displayName','RTK-Float'); ... % RTK-Float
    locs = find(ROVER_PPK.fix==4); plot(ROVER_PPK.t(locs),ROVER_PPK.N(locs),'.','color',a(1,:),'displayName','RTK-Fixed'); ... % RTK-Fixed
    legend show; legend boxoff; ...
    xlabel('Time [ s ]'); ylabel('North [ m ]');
subplot(3,1,2); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.E,'-','color',[0.8,0.8,0.8],'displayName','Path'); ...    
    locs = find(ROVER_PPK.fix==1); plot(ROVER_PPK.t(locs),ROVER_PPK.E(locs),'.','color',a(4,:),'displayName','Single'); ... % Single
    locs = find(ROVER_PPK.fix==2); plot(ROVER_PPK.t(locs),ROVER_PPK.E(locs),'.','color',a(3,:),'displayName','DGPS'); ... % DGPS
    locs = find(ROVER_PPK.fix==5); plot(ROVER_PPK.t(locs),ROVER_PPK.E(locs),'.','color',a(2,:),'displayName','RTK-Float'); ... % RTK-Float
    locs = find(ROVER_PPK.fix==4); plot(ROVER_PPK.t(locs),ROVER_PPK.E(locs),'.','color',a(1,:),'displayName','RTK-Fixed'); ... % RTK-Fixed
    legend show; legend boxoff; ...
    xlabel('Time [ s ]'); ylabel('East [ m ]');
subplot(3,1,3); hold all; grid on; grid minor; ...
    plot(ROVER_PPK.t,ROVER_PPK.U,'-','color',[0.8,0.8,0.8],'displayName','Path'); ...    
    locs = find(ROVER_PPK.fix==1); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(4,:),'displayName','Single'); ... % Single
    locs = find(ROVER_PPK.fix==2); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(3,:),'displayName','DGPS'); ... % DGPS
    locs = find(ROVER_PPK.fix==5); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(2,:),'displayName','RTK-Float'); ... % RTK-Float
    locs = find(ROVER_PPK.fix==4); plot(ROVER_PPK.t(locs),ROVER_PPK.U(locs),'.','color',a(1,:),'displayName','RTK-Fixed'); ... % RTK-Fixed
    legend show; legend boxoff; ...
    xlabel('Time [ s ]'); ylabel('Altitude [ m ]');

%% Export to Excel csv and save images
filename = fullfile(output_dir,'RoverRTK_pos.csv');
fid = fopen(filename,'w+');
    
fprintf(fid,'ref pos:, lat (dd.dd), lon (dd.dd), alt (m),,,fix: 0:None 1:Single 2:DGPS 4:RTK-Fixed 5:RTK-Float\n');
fprintf(fid,'        , %15.11f,%15.11f,%7.3f\n',ROVER_RTK.ref.lat,ROVER_RTK.ref.lon,ROVER_RTK.ref.alt);
fprintf(fid,'=========================================================================\n');
fprintf(fid,'t, lat, lon, alt, fix, sats, north, east, up\n');
fprintf(fid,'[ s ], [ dd.dd ], [ dd.dd ], [ m ], [ - ], [ - ], [ m ], [ m ], [ m ]\n');
fprintf(fid,'------------------------------------------------------------------------------\n');
for ii = 1:numel(ROVER_RTK.t)
    fprintf(fid,'%8.3f, %15.11f, %15.11f, %7.3f, %g, %g, %8.3f, %8.3f, %8.3f\n', ...
        ROVER_RTK.t(ii), ...
        ROVER_RTK.lat(ii), ROVER_RTK.lon(ii), ROVER_RTK.alt(ii), ...
        ROVER_RTK.fix(ii), ROVER_RTK.sats(ii), ...
        ROVER_RTK.N(ii), ROVER_RTK.E(ii), ROVER_RTK.U(ii));
    
end 
fclose(fid);

% Images
saveas(1, fullfile(images_dir,'Rover_Consistency'), 'png');
saveas(2, fullfile(images_dir,'Base_Consistency'), 'png');
saveas(4, fullfile(images_dir,'Solution_Comparisons'), 'png');
saveas(6, fullfile(images_dir,'PPK_Analysis'), 'png');
saveas(7, fullfile(images_dir,'PPK_Path'), 'png');

%% Print results
fprintf('\n\n\nReference Positions\n');
fprintf('\t     BASE: ( %12.7f, %12.7f,%8.3f )\n',BASE.ref.lat,BASE.ref.lon,BASE.ref.alt);
fprintf('\tROVER RTK: ( %12.7f, %12.7f,%8.3f )\n',ROVER_RTK.ref.lat,ROVER_RTK.ref.lon,ROVER_RTK.ref.alt);
fprintf('\tROVER PPK: ( %12.7f, %12.7f,%8.3f )\n',ROVER_PPK.ref.lat,ROVER_PPK.ref.lon,ROVER_PPK.ref.alt);
fprintf('\n');
fprintf('\t     HOME: ( %12.7f, %12.7f,%8.3f )\n',34.1420060,-118.1302375,207.030);


return







