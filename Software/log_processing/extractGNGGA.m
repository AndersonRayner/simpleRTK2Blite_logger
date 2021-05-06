function pos = extractGNGGA(input_file,ref_pos,output_dir)
% Extracts the GNGGA data out of a file
%   from https://www.trimble.com/OEM_ReceiverHelp/V4.44/en/NMEA-0183messages_GGA.html

fprintf('Extracting GNGGA data from %s\n',input_file);

% Start variables
xx = 0;
counter = 0;

t = [];
lat = [];
lon = [];
fix = [];
sv = [];
alt = [];

% Read the file
fid = fopen(input_file,'r');

while ~feof(fid)
    xx = fgetl(fid);
    
    loc = strfind(xx,'$GNGGA');
    
    if ~isempty(loc)
        
        yy = sscanf(xx(loc:end),'$GNGGA,%f,%f,%*c,%f,%*c,%f,%f,%f,%f,%*c,%f,%*c,%*s')';
        zz = sscanf(xx(loc:end),'$GNGGA,%*f,%*f,%c,%*f,%c')';
        
        if numel(yy)>=7
            
            if (zz(1) == 78); lat_dir =  1; else; lat_dir = -1; end  % Look for a N for north (positive)
            if (zz(2) == 87); lon_dir = -1; else; lon_dir =  1; end  % Look for a W for west  (negative)
            
            time_str = yy(1);
            HH = floor(time_str/10000);
            time_str = time_str - (HH*10000);
            MM = floor(time_str/100);
            time_str = time_str - (MM*100);
            SS = time_str;
            t(end+1,1) = HH*60*60 + MM*60 + SS;
            lat(end+1) = lat_dir*(floor(yy(2)/100) + mod(yy(2)/100,1)*10/6);
            lon(end+1) = lon_dir*(floor(yy(3)/100) + mod(yy(3)/100,1)*10/6);
            fix(end+1) = yy(4);
            sv(end+1) = yy(5);
            alt(end+1) = yy(7);
            
        end
    end
    
    
    counter = counter + 1;
end

fclose(fid);

%% Post-Calcs
if ~exist('ref_pos','var')
    ref_pos = [mean(lat),mean(lon),mean(alt)];
end

flatEarth = lla2flat([lat',lon',alt'], [ref_pos(1),ref_pos(2)], 0, ref_pos(3));
YE = flatEarth(:,1);
XE = flatEarth(:,2);
altE = flatEarth(:,3);

%% Compile everything for sending back
pos.t = t;
pos.lat = lat';
pos.lon = lon';
pos.alt = alt';
pos.fix = fix';
pos.sats = sv';
pos.N = YE;
pos.E = XE;
pos.U = altE;

pos.ref.lat = ref_pos(1);
pos.ref.lon = ref_pos(2);
pos.ref.alt = ref_pos(3);


%% Write kml file
[dir,file,~] = fileparts(input_file);

kml_file = fullfile(output_dir,[file,'-RTK.kml']);
fid = fopen(kml_file,'w');

fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<kml xmlns="http://earth.google.com/kml/2.1">\n');
fprintf(fid,'<Document>\n');
fprintf(fid,'<Placemark>\n');
fprintf(fid,'<name>Rover Track (RTK)</name>\n');
fprintf(fid,'<Style>\n');
fprintf(fid,'<LineStyle>\n');
fprintf(fid,'<color>ffff5500</color>\n');
fprintf(fid,'<width>2</width>\n');
fprintf(fid,'</LineStyle>\n');
fprintf(fid,'</Style>\n');
fprintf(fid,'<LineString>\n');
fprintf(fid,'<altitudeMode>absolute</altitudeMode>\n');
fprintf(fid,'<coordinates>\n');

for ii = 1:numel(pos.t)
    fprintf(fid,'%f,%f,%f\n',pos.lon(ii),pos.lat(ii),0.0);
end

fprintf(fid,'</coordinates>\n');
fprintf(fid,'</LineString>\n');
fprintf(fid,'</Placemark>\n');

fprintf(fid,'</Document>\n');
fprintf(fid,'</kml>\n');
fclose(fid);

return
end