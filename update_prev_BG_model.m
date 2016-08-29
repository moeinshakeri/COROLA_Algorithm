function [BG, Mask_BG, mask1] = update_prev_BG_model(Updated_BG, ImData1, tau, Mask, Mask_BG, diff_mean_bg)

global M_Height; global M_Width;

BG = Updated_BG; %warpImg(double(BG),-tau(:,end-1),1,0);
BG = cropRatio_ROI(BG,ImData1);
Mask_BG = warpImg(double(Mask_BG),-tau(:,end-1),1,0);
Mask_BG = double(Mask_BG) + 2*double(Mask);
Mask_BG = Mask_BG/2;
mask1 = zeros(M_Height, M_Width);
mask1(Mask_BG>0.08) = 1;
mask1 = imdilate(mask1,[1 1 ; 1 1]);
BG = uint8(BG-diff_mean_bg).*uint8(mask1)+ImData1(:,:,end).*uint8(1-mask1);