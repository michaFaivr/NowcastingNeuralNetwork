 %///////////////////////
FMT=find(Fnumvect(sample_set)==Frank & MTnumvect(sample_set)==MTnum);
        %--=== B: plotting section ===---
        %
        %--- B2.IR1 ----
%       thefield = flipud(rot90(ir1_count_radiance));

switch Part
    case 'PartA'
        fignum=30;
    case 'PartB'
        fignum=32;
end

minRAD1=sprintf('%4i',floor(min(min(PixelRAD1))));
maxRAD1=sprintf('%4i',floor(max(max(PixelRAD1))));

%# 20150310
if useRADavg==0
   RADSneighbor=0;
end

clear figure
        thefield = flipud(rot90(PixelRAD1));
        figure(30)
        colormap(1-gray(256))
%       imagesc(ir_longitude, ir_latitude, thefield, [0 14])
        imagesc(PixelLon, PixelLat, thefield, [0 11])
        set(gca, 'ydir', 'normal')
        hold on
        plot(RASTAlon(sample_set(FMT)), RASTAlat(sample_set(FMT)), 'b.', 'linewidth', 1.);

        xlim([lonmin-ddegre lonmax+ddegre])
        ylim([latmin-ddegre latmax+ddegre])
        title({name_input_file_title;['minRAD1 on RASTA track' minRAD1];['maxRAD1 on RASTA track' maxRAD1]});
        ca = colorbar;
        set(get(ca, 'ylabel'), 'string', 'IR1 radiance (W/(m^2 sr micron)');
        axis square
        grid on

%# 20150330 add coastline
        load coast;
        plot(long, lat, 'w-','linewidth', 1.);
%# 20150409 dpng --> depsc
        print('-depsc', '-r2000',['NNET_MTSATmapF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype trainingfct Part sprintf('%02i',RADSneighbor) 'km' ])

%# 20150330 plot MTSAT R1<=0.9)
seuil1=0.9; seuil2=1.25;
thefieldTMP=thefield;
thefieldTMP(thefield<=seuil1)=1;
thefieldTMP(thefield>seuil1 & thefield<=seuil2)=2;
thefieldTMP(thefield>seuil2)=0;
disp('min thefield')
min(min(thefield))
disp('max thefield')
max(max(thefield))
%%pause

clear figure
        thefield = flipud(rot90(PixelRAD1));
        figure(30)
        colormap(1-gray(256))
%       imagesc(ir_longitude, ir_latitude, thefield, [0 14])
        imagesc(PixelLon, PixelLat, thefieldTMP, [0 2])
        set(gca, 'ydir', 'normal')
        hold on
        plot(RASTAlon(sample_set(FMT)), RASTAlat(sample_set(FMT)), 'b.', 'linewidth', 1.);

        xlim([lonmin-ddegre lonmax+ddegre])
        ylim([latmin-ddegre latmax+ddegre])
        title({name_input_file_title;['minRAD1 on RASTA track' minRAD1];['maxRAD1 on RASTA track' maxRAD1]});
        ca = colorbar;
        set(get(ca, 'ylabel'), 'string', 'IR1 radiance (W/(m^2 sr micron)');
        axis square
        grid on

%# 20150330 add coastline
        load coast;
        plot(long, lat, 'k-','linewidth', 1.);
%# 20150409 dpng --> depsc
        print('-depsc', '-r2000',['NNET_MTSATmapR1lt9E-1F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype trainingfct Part sprintf('%02i',RADSneighbor) 'km' ])
        clear thefieldTMP


