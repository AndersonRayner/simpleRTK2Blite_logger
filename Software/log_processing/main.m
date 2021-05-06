% Script for doing all the simpleRTK logger stuff
clear all
clc
fclose('all');

root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-02-25_Home';  % Static Test
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-01_Caltech';  % Going for a walk to COVID testing
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-08_Home'; % Going around the block
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-14_Home'; % Going around the block
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-15_Home'; % Sitting on the porch
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-16_North_Field\data'; % Flight testing at North Field
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-03-18_North_Field\data\raw_GPS_observations\flight_1'; % Flights with RADAR
root_dir = 'C:\Users\matt\OneDrive - California Institute of Technology\Projects\DARTS\Field Tests\2021-05-03_North_Field\data\gps_logs';

input_file_Rover = fullfile(root_dir,'ROVER.TXT');
input_file_Base  = fullfile(root_dir,'BASE.TXT');

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
























% % Colourmap
% RTK_colours = zeros(numel(ROVER_RTK.fix),3);
% for ii = 1:numel(ROVER_RTK.fix)
%     if (ROVER_RTK.fix(ii) == 0); RTK_colours(ii,:) = [0,0,0]; end % None
%     if (ROVER_RTK.fix(ii) == 1); RTK_colours(ii,:) = [1,0,0]; end % Single
%     if (ROVER_RTK.fix(ii) == 2); RTK_colours(ii,:) = [1,1,0]; end % DGPS
%                                                                   % 3 doesn't exist
%     if (ROVER_RTK.fix(ii) == 4); RTK_colours(ii,:) = [0,0,1]; end % RTK-Fixed
%     if (ROVER_RTK.fix(ii) == 5); RTK_colours(ii,:) = [0,1,0]; end % RTK-Float
% end
%
% PPK_colours = zeros(numel(ROVER_PPK.fix),3);
% for ii = 1:numel(ROVER_PPK.fix)
%     if (ROVER_PPK.fix(ii) == 1); PPK_colours(ii,:) = [1,0,0]; end % Single
%     if (ROVER_PPK.fix(ii) == 5); PPK_colours(ii,:) = [0,1,0]; end % Float
%     if (ROVER_PPK.fix(ii) == 4); PPK_colours(ii,:) = [0,0,1]; end % Fixed
% end
%
% figure(6); clf; hold all; grid on; grid minor; set(gcf,'name','Fix Type Map'); ...
%     plot(ROVER_RTK.E,ROVER_RTK.N,'-','color',[0.8,0.8,0.8]); ...
%     plot(ROVER_PPK.E,ROVER_PPK.N,'-','color',[0.8,0.8,0.8]); ...
%     scatter(ROVER_RTK.E,ROVER_RTK.N,[],RTK_colours); ...
%     scatter(ROVER_PPK.E,ROVER_PPK.N,[],PPK_colours); ...
%     xlabel('East [ m ]'); ylabel('North [ m ]');

% figure(7); clf; hold all; set(gcf,'name','PPK Analysis');
% subplot(2,2,1); hold all; grid on; grid minor; ...
%     plot(ROVER_PPK.t,ROVER_PPK.N); ...
%     plot(ROVER_PPK.t,ROVER_PPK.N+ROVER_PPK.sdN*2,'-','color',[0.8,0.8,0.8]); ...
%     plot(ROVER_PPK.t,ROVER_PPK.N-ROVER_PPK.sdN*2,'-','color',[0.8,0.8,0.8]); ...
%     xlabel('Time [ s ]'); ylabel('Position N [ m ]');
% subplot(2,2,3); hold all; grid on; grid minor; ...
%     plot(ROVER_PPK.t,ROVER_PPK.E); ...
%     plot(ROVER_PPK.t,ROVER_PPK.E+ROVER_PPK.sdE*2,'-','color',[0.8,0.8,0.8]); ...
%     plot(ROVER_PPK.t,ROVER_PPK.E-ROVER_PPK.sdE*2,'-','color',[0.8,0.8,0.8]); ...
%     xlabel('Time [ s ]'); ylabel('Position E [ m ]');
% subplot(2,2,2); hold all; grid on; grid minor; ...
%     plot(ROVER_PPK.t,ROVER_PPK.U); ...
%     plot(ROVER_PPK.t,ROVER_PPK.U+ROVER_PPK.sdU*2,'-','color',[0.8,0.8,0.8]); ...
%     plot(ROVER_PPK.t,ROVER_PPK.U-ROVER_PPK.sdU*2,'-','color',[0.8,0.8,0.8]); ...
%     xlabel('Time [ s ]'); ylabel('Position U [ m ]');
% subplot(2,2,4); hold all; grid on; grid minor; ...
%     plot(ROVER_PPK.t,ROVER_PPK.fix); ...
%     yticks([0:5]); yticklabels({'None','Single','DGPS','-','RTK-Fixed','RTK-Float'}); ...
%     ylabel('Fix Type [ - ]'); xlabel('Time [ s ]');



% Calculate spread of keeping GPS in one spot
locs = find(fix == 4);  % Only take the fixed integer solutions
locs = find(fix > 0);

dist = sqrt((XE(locs)-mean(XE(locs))).^2 + (YE(locs)-mean(YE(locs))).^2);



% Distribution
% Comparison at https://www.ardusimple.com/testing-simplertk2b-accuracy-in-rtk-base-rover-configuration/
figure(5); clf; set(gcf,'name','Local Position Estimate Histogram');
subplot(1,3,1); hold all; grid on; grid minor; ...
    title(sprintf('Standard Deviation (North): %.3f [ m ]\nStandard Deviation (East): %.3f [ m ]',std(YE(locs)),std(XE(locs))));
histogram(YE(locs) - mean(YE(locs)),'displayName','North'); ...
    histogram(XE(locs) - mean(XE(locs)),'displayName','East'); ...
    legend show; box off; ...
    xlabel('Distance from Mean [ m ]'); ylabel('Num Elements [ - ]');
subplot(1,3,2); hold all; grid on; grid minor; ...
    histogram(dist,'displayName','2D');
legend show; box off; ...
    xlabel('Distance from Mean [ m ]'); ylabel('Num Elements [ - ]');

subplot(1,3,3); hold all; grid on; grid minor; ...
    title(sprintf('Standard Deviation (Altitude): %.3f [ m ]',std(altE(locs))));
histogram(altE(locs) - mean(altE(locs)),'displayName','Alt'); ...
    legend show; box off; ...
    xlabel('Altitude from Mean [ m ]'); ylabel('Num Elements [ - ]');



return












