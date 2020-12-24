%% polt ROC curves of the detection result y
% input: 
%   groundtruth: should be a vector where 1 represents the targets and 0 
%                represents the backgrounds.
%   y: should be a vector where each of its element should be normalized 
%                to [0,1].
% output:
%   FPR: a vector where each of its element represents the false positive 
%        rate on diffenet thresholds.
%   TPR: a vector where each of its element represents the true positive 
%        rate on diffenet thresholds.
%

function [FPR, TPR] = myPlotROC(groundtruth, y)

    TPR = zeros(1,1001);
    FPR = zeros(1,1001);
    a = min(y);
    b = max(y);
    n = 1000;
    h = (b-a)/n;
    
    for threshold = a-h:h:b+h        
        TP = 0;
        FN = 0;
        FP = 0;
        TN = 0;
        N = length(y);
        v = zeros(1,N);
        
        for i = 1:N
            if y(i) > threshold
                v(i) = 1;
            end
        end
        
        for i = 1:N
            if v(i)==1 && groundtruth(i)==1
                TP = TP+1;
            end
            if v(i)==0 && groundtruth(i)==1
                FN = FN+1;
            end
            if v(i)==1 && groundtruth(i)==0
                FP = FP+1;
            end
            if v(i)==0 && groundtruth(i)==0
                TN = TN+1;
            end

        end
        
        j = round((threshold-a)/h+2);
        TPR(j) = TP/(TP+FN);
        FPR(j) = FP/(FP+TN);
    end

end

