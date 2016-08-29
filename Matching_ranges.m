function [A_HAT, B_HAT, U_HAT, A_HAT_offset, U_HAT_offset, B_HAT_offset] = Matching_ranges(L_j, mask1, Mask, ImData_temp, U_HAT, V_HAT, A_HAT, B_HAT, U_HAT_offset, B_HAT_offset, A_HAT_offset, V_HAT_offset, ImMean, ImMean_offset, Training_Num, First_frame, Iteration)

global M_Height; global M_Width;

cropRatio1 = 0.05;

low_1_reduce = L_j(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width));
mask2 = mask1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width));
low_1_reduce = mat2gray(low_1_reduce);
low_1_temp = low_1_reduce(mask2==0);
low_1_temp = mat2gray(low_1_temp(:));
low_2 = mat2gray(ImData_temp);
low_2_reduce = low_2(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width));
low_2_temp = low_2_reduce(mask2==0);
low_2_temp = mat2gray(low_2_temp(:));
low_2(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width))=low_1_reduce;
low_1 = low_2;
diff_final = mean(low_1_temp - low_2_temp);

if Iteration < Training_Num
    low_1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width))= ...
        low_1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width))-diff_final;
    low_1_offset = mat2gray(ImData_temp);
    U_HAT_offset = (low_1_offset(:)-ImMean_offset)/V_HAT_offset(1,2);
    U_HAT = (low_1(:)-ImMean)/V_HAT(1,2);
    B_HAT_offset(:,:) = 0;
    A_HAT_offset(:,:) = 0;
end
if Iteration <= First_frame
    A_HAT(:,:) = 0; B_HAT(:,:) = 0;
else
    low_1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width))= ...
        low_1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width))-diff_final;
    U_HAT = (low_1(:)-ImMean)/V_HAT(1,2);
    term2_B = U_HAT*V_HAT*(V_HAT)';
    low_3 = mat2gray(reshape(term2_B,[M_Height M_Width]));
    max_bobgs = max(B_HAT);
    min_bobgs = min(B_HAT);
    B_HAT_2d = reshape(B_HAT, [M_Height M_Width]);
    B_1 = mat2gray(B_HAT_2d);  
    temp_B_1 = mat2gray(B_1(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width)));
    temp_low_3 = mat2gray(low_3(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width)));
    temp_Mask = Mask(round(cropRatio1*M_Height):round((1-cropRatio1)*M_Height),round(cropRatio1*M_Width):round((1-cropRatio1)*M_Width));
    diff_mean_BHAT = mean(mean(double(temp_B_1(temp_Mask==0))))-mean(mean(double(temp_low_3(temp_Mask==0))));
    B_1 = B_1 - diff_mean_BHAT;
    B_1([1:round(cropRatio1*M_Height),round((1-cropRatio1)*M_Height):end],:) = low_3([1:round(cropRatio1*M_Height),round((1-cropRatio1)*M_Height):end],:);
    B_1(:,[1:round(cropRatio1*M_Width),round((1-cropRatio1)*M_Width):end]) = low_3(:,[1:round(cropRatio1*M_Width),round((1-cropRatio1)*M_Width):end]);
    B_1 = ((max_bobgs-min_bobgs)/(max(B_1(:))-min(B_1(:))))*(B_1-min(B_1(:)))+min_bobgs;
    B_HAT = B_1(:);
end