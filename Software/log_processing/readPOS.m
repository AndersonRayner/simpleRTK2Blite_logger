function pos = readPOS(input_file)
% Reads a Post-Processed File from RTKLIB

fprintf('Reading POS file\n');

% Start variables
year = [];
month = [];
day = [];
hour = [];
minute = [];
second = [];
east = [];
north = [];
up = [];
quality = [];
ns = [];
sde = [];
sdn = [];
sdu = [];
sden = [];
sdnu = [];
sdue = [];
age = [];
ratio = [];
VE = [];
VN = [];
VU = [];
sdVE = [];
sdVN = [];
sdVU = [];
sdVEN = [];
sdVNU = [];
sdVUE = [];

t = [];

%% Read the File
fid = fopen(input_file,'r');

% Read in the header
for ii = 1:22; xx = fgetl(fid); end

yy = sscanf(xx,'%*s ref pos %*s %f %f %f');
ref_pos = yy;

% Read the data
while ~feof(fid)
    xx = fgetl(fid);
    %  GPST   E (m)  N (m) U(m) Q  ns  sde(m)   sdn(m)   sdu(m)  sden(m)  sdnu(m)  sdue(m) age(s)  ratio    ve(m/s)    vn(m/s)    vu(m/s)      sdve     sdvn     sdvu    sdven    sdvnu    sdvue
    
    yy = sscanf(xx,'%d/%d/%d %f:%f:%f %f %f %f %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f')';

    if (numel(yy)>5)
        year(end+1,1)    = yy(1);
        month(end+1,1)   = yy(2);
        day(end+1,1)     = yy(3);
        hour(end+1,1)    = yy(4);
        minute(end+1,1)  = yy(5);
        second(end+1,1)  = yy(6);
        
        east(end+1,1)    = yy(7);
        north(end+1,1)   = yy(8);
        up(end+1,1)      = yy(9);
        
        quality(end+1,1) = yy(10);
        ns(end+1,1)      = yy(11);
        
        sde(end+1,1)     = yy(12);
        sdn(end+1,1)     = yy(13);
        sdu(end+1,1)     = yy(14);
        sden(end+1,1)    = yy(15);
        sdnu(end+1,1)    = yy(16);
        sdue(end+1,1)    = yy(17);
        
        age(end+1,1)     = yy(18);
        ratio(end+1,1)   = yy(19);
        
        try VE(end+1,1)    = yy(20); catch; VE(end+1,1) = nan; end
        try VN(end+1,1)    = yy(21);catch; VN(end+1,1) = nan; end
        try VU(end+1,1)    = yy(22);catch; VU(end+1,1) = nan; end
        try sdVE(end+1,1)  = yy(23);catch; sdVE(end+1,1) = nan; end
        try sdVN(end+1,1)  = yy(24);catch; sdVN(end+1,1) = nan; end
        try sdVU(end+1,1)  = yy(25);catch; sdVU(end+1,1) = nan; end
        try sdVEN(end+1,1) = yy(26);catch; sdVEN(end+1,1) = nan; end
        try sdVNU(end+1,1) = yy(27);catch; sdVNU(end+1,1) = nan; end
        try sdVUE(end+1,1) = yy(28);catch; sdVUE(end+1,1) = nan; end
        
        t(end+1,1) = hour(end)*60*60 + minute(end)*60 + second(end);
        
    end
    
end

fclose(fid);

%% Post calcs
% t = t - t(1);
% north = north - mean(north) + mean(YE(end-100,end));
% east = east - mean(east) + mean(XE(end-100,end));
% up = up - mean(up) + mean(altE(end-100,end));

% Convert quality over the fix numbers from ublox
%   from Q=1:fix,   2:float,3:sbas,4:dgps      5:single    6:ppp
%     to   1:Single 2:DGPS ,3:-    4:RTK-Fixed 5:RTK-Float 6:ppp 7:sbas
quality(quality == 1) = 14;
quality(quality == 2) = 15;
quality(quality == 3) = 17;
quality(quality == 4) = 12;
quality(quality == 5) = 11;
quality(quality == 6) = 16;
quality = quality - 10;

% Convert to lat/lon/alt
lla = flat2lla([north,east,up], [ref_pos(1),ref_pos(2)], 0, ref_pos(3));

%% Prepare for output
pos.t = t;

pos.lat = lla(:,1);
pos.lon = lla(:,2);
pos.alt = lla(:,3);

pos.N = north;
pos.E = east;
pos.U = up;

pos.fix = quality;  % be careful, fix numbers are different
pos.sats = ns;

pos.sdN = sdn;
pos.sdE = sde;
pos.sdU = sdu;
pos.sdEN = sden;
pos.sdNU = sdnu;
pos.sdUE = sdue;
pos.age = age;
pos.ratio = ratio;

pos.VE    = VE;
pos.VN    = VN;
pos.VU    = VU;
pos.sdVE  = sdVE;
pos.sdVN  = sdVN;
pos.sdVU  = sdVU;
pos.sdVEN = sdVEN;
pos.sdVNU = sdVNU;
pos.sdVUE = sdVUE;

pos.ref.lat = ref_pos(1);
pos.ref.lon = ref_pos(2);
pos.ref.alt = ref_pos(3);

% Write KML File
[dir,file,~] = fileparts(input_file);
kml_file = fullfile(dir,[file,'-PPK.kml']);
fid = fopen(kml_file,'w');
fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<kml xmlns="http://earth.google.com/kml/2.1">\n');
fprintf(fid,'<Document>\n');
fprintf(fid,'<Placemark>\n');
fprintf(fid,'<name>Rover Track (PPK)</name>\n');
fprintf(fid,'<Style>\n');
fprintf(fid,'<LineStyle>\n');
fprintf(fid,'<color>ff0000ff</color>\n');
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
