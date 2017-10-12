%# 20150320
function IWPlevs = convertClasses_to_IWP(IWPcls,threshvect)
IWPlevs=-99*ones(numel(IWPcls),1);
whos IWPcls
%IWPlevs=IWPcls.*0;
     for nl=1:numel(IWPcls)
         IWPlevs(nl)=threshvect(IWPcls(nl)+1);
     end
end
