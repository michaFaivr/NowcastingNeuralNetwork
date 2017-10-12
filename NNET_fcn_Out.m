%# 20150522 fcn to calculate output fcn with Outshift1,2,(Beta)
function OY = NNET_rout_outfcn(Y, NBcla, threshvect, IWPpivot, Outshift1, Outshift2, Beta)
            YT=round(Y);
            YT(YT<0)=0;
            YT(YT>NBcla-1)=NBcla-1;
            Aset = find(threshvect(YT+1)<IWPpivot);
            
            for ind=1:numel(Aset)
                %# 20150519 formula 1%
                IWPOtmp = threshvect(YT(Aset(ind))+1);
                %% IWPlevel below IWPpivot
                Y(Aset(ind))=round(Y(Aset(ind)) - (IWPpivot-IWPOtmp)*1E-3*Outshift1 );
                %Y(Aset(ind))=round(Y(Aset(ind)) - (Beta+(IWPpivot-IWPOtmp)*1E-3)*Outshift1 );
                %Y(Aset(ind))=round(Y(Aset(ind)) - (Beta+(IWPpivot-IWPOtmp)*0.5*1E-3)*Outshift1 );
                %Y(Aset(ind))=round(Y(Aset(ind)) - (1+(Beta+(IWPpivot-IWPOtmp)*1E-3))*Outshift1 ); %--> all median diffs Boxplot =0
                %% Y(Aset(ind))=round(threshvect(Y(Aset(ind))+1)-(IWPpivot-threshvect(Y(Aset(ind))+1)/1000*Outshift1));
            end
            %Y(Aset)=round(Y(Aset)-Outshift1);
            %
            %%-- b) IWPlevel above IWPpivot
            Bset = find(threshvect(YT+1)>=IWPpivot)
            Y(Bset)=round(Y(Bset)+Outshift2);
            %
            %%-- c) 3rd part of Outfcn
            OY=round(Y);
            OY(OY<0) = 0;
            OY(OY>NBcla-1)=NBcla-1;
end
