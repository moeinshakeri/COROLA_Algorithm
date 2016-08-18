
function [Precision,Recall,F_measure] = Pre_Rec(Mask, GT_Mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    This function computes precision , recall, and F_measure    %%%
%%%        written by Moein Shakeri, Updated June 2016             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GT_mask1 = GT_Mask(:,:,1);
GT_mask1 = GT_mask1>100;

Mask = uint8(Mask);
total_pixels = sum(sum(GT_mask1));
% total_pixels1 = sum(sum(Mask));
FN = sum(sum(uint8(GT_mask1) - uint8(Mask)));
TP = (total_pixels - FN);
FP = sum(sum(uint8(Mask) - uint8(GT_mask1)));
Precision = TP/(TP+FP);
Recall = TP/(TP+FN);
F_measure = (2*(Precision*Recall))/(Precision+Recall);
end

