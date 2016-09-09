function [aacc,wacc] = CRFAcurracy(testdata,theta,modelParams)
%CRFACURRACy Summary of this function goes here
%   Detailed explanation goes here
N=length(testdata);
curword=0;
totalchar=0;
curchar=0;
for i=1:N
    ypre=CRFPredict(testdata(i).X,theta,modelParams);
    totalchar=totalchar+length(testdata(i).y);
    curchar=curchar+sum(ypre==testdata(i).y);
    if(all(ypre==testdata(i).y)) 
        curword=curword+1;
    end
end
aacc=curchar/totalchar;
wacc=curword/N;
end

