function [zenith,azimuth,E0]=solarPosition(time,lat,lon,elevation)
%SOLARPOSITION Original fallback algorithm, preserved for reproducibility.
doy=day(time,'dayofyear'); g=2*pi*(doy-1)/365;
E0=1367*(1.00011+0.034221*cos(g)+0.00128*sin(g)+0.000719*cos(2*g)+0.000077*sin(2*g));
if exist('pvl_ephemeris','file')==2
    try
        [az,el]=pvl_ephemeris(datenum(time),lat,lon,elevation); azimuth=az(:); zenith=90-el(:); return
    catch
    end
end
fracHour=hour(time)+minute(time)/60+second(time)/3600;
decl=23.45*sind(360*(284+doy)/365); hra=15*(fracHour-12);
zenith=acosd(sind(lat).*sind(decl)+cosd(lat).*cosd(decl).*cosd(hra));
azSouth=atan2d(sind(hra),cosd(hra).*sind(lat)-tand(decl).*cosd(lat));
azimuth=mod(azSouth+180,360);
end

