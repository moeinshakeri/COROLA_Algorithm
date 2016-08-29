function [GMM_input, Updated_BG, replace_param] = update_gmm_pos(BG, tau, ImData)

Updated_BG = warpImg(double(BG),-tau(:,end-1),1,0);
Updated_BG = cropRatio_ROI(Updated_BG,ImData);
GMM_input = repmat(ImData,[1 1 3]);
replace_param = repmat(Updated_BG, [1 1 3]);
replace_param(:,:,4) = 12;
replace_param(:,:,5) = 1; 