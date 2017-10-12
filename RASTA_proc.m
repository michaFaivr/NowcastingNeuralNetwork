%%%20141208 et RASTA read and proc in routine
    gunzip(strcat('/home/faivre/RASTAv02/HAIC_DARWIN_2014',Mnum,Dnum,'_F',Fnum1,'_radonvar_W_0.nc.gz'))
    %
    Fnum2=sprintf('%02d',Frank);   %'06'; %will come from bash loop on Fnum
    Fnum1=sprintf('%d',Frank);
    %
    input_dir_RASTA = '/home/faivre/RASTAv02/'
    input_file_RASTA =strcat('HAIC_DARWIN_2014',Mnum,Dnum,'_F',Fnum1,'_radonvar_W_0.nc');
    thedate_of_reference = [2014 MMonth DDay 0 0 0];
    addpath('./TOOLS/')
        read_RASTA;
    rmpath('./TOOLS/')
    %readRASTA_IWPheight;
    %
    RASTA_hour = floor(RASTA_time/3600.0);
    RASTA_minute = floor((RASTA_time - RASTA_hour*3600.0)/60.0);
    RASTA_second = RASTA_time - RASTA_hour*3600.0 - RASTA_minute*60.0;
    RASTA_time_datenum = datenum(cast([thedate_of_reference(1)*ones(length(RASTA_time), 1) ...
        thedate_of_reference(2)*ones(length(RASTA_time), 1) ...
        thedate_of_reference(3)*ones(length(RASTA_time), 1) ...
        RASTA_hour RASTA_minute RASTA_second], 'double'));
    clear RASTA_second RASTA_minute RASTA_hour

    %------ define lat,lon ROI from RSTA flight positions min,max +/-1°
    lonmin = min(RASTA_longitude(RASTA_longitude>-999))-1;
    lonmax = max(RASTA_longitude(RASTA_longitude>-999))+1;
    latmin = min(RASTA_latitude(RASTA_longitude>-999))-1;
    latmax = max(RASTA_latitude(RASTA_longitude>-999))+1;
disp('hello from RASTA_proc')
%%pause

    if (latmax-latmin) > (lonmax-lonmin)
        tempo = (lonmax+lonmin)/2.0;
        lonmin = tempo - (latmax-latmin)/2.0;
        lonmax = lonmin + (latmax-latmin);
        clear tempo
    else
        tempo = (latmax+latmin)/2.0;
        latmin = tempo - (lonmax-lonmin)/2.0;
        latmax = latmin + (lonmax-lonmin);
        clear tempo
    end
