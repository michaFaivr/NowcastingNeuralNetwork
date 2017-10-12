    %20141121 use plotting module
left= 0.15;
bottom0=0.76;
bottom1=0.58;
bottom2=0.40;
bottom3=0.22;
bottom4=0.04;
width=0.8;
height=bottom0-bottom1-0.09; % which is also bottom1-bottom2

    clear figure
    figure(3)
    %plot(training_set,data_sample,'go',training_set,data_sample,'k');
    %# 20150409 add | nbRADS==5
    if nbRADS == 4 | nbRADS==5
         %20141203 replace training by sample_set
         xl=1:numel(PixelRADS(:,1));
         plot(xl,PixelRADS(:,1),'k',xl,PixelRADS(:,2),'b',...
              xl,PixelRADS(:,3),'g',xl,PixelRADS(:,4),'r');
    elseif nbRADS == 1
         plot(PixelRADS(:,1),'k');
    end
    xlim([xl(1) xl(end)]);
    print('-dpng', '-r1000','Rads_Checking20141119b')

