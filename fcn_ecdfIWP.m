%# 20150423 1) calculate empirical cdf of IWP
%2) calculate optimal thresholds for 
%3) overwrte threshvect and thresholds

function IWPthreshs = fcn_ecdfIWP(IWP,NBcla)

     IWPsample = IWP(1:100:end);
     [f, IWPsteps] = ecdf(IWPsample); 
     [f, IWPsteps]
 whos f
 whos IWPsample
%pause
     clear figure
    %figure(2)
     plot(IWPsteps,f)
     print('-dpng','-r1000','ECDFfig')
     %calcul 
     IWPthreshs=1:NBcla;
     IWPthreshs=IWPthreshs.*0;
%    IWPthreshs=linspace(IWPsteps(1),IWPsteps(end),NBcla);
     refSteps = linspace(0,1,NBcla+1)
     NBcla       
     pause
     IWPsample(1)
     IWPsample(end)
     pause
     for NL=1:NBcla
         [A, ind1] = min(abs(f-refSteps(NL)))
         IWPthreshs(NL) = IWPsample(ind1)
         disp('f(ind1)')
         f(ind1)
         disp('IWPsample(ind1)')
         IWPsample(ind1)
         clear A ind1
     end     
%     [A, ind1] = min(abs(f-0.16)) 
%     [B, ind2] = min(abs(f-0.32))
%     disp('fmax')
%     max(max(f))
%     ind1
%     ind2
%     pause
     disp('fcn_ecdfIWP')
     IWPthreshs 
end
