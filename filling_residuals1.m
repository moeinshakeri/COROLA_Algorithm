function B_HAT = filling_residuals1(U_HAT,B_HAT,V_HAT,current_img,cropRatio,Rank)
global M_Width; global M_Height;

term2_B = U_HAT*V_HAT*(V_HAT)';
[Height,Width] = size(current_img);
for i = 1 : Rank-1
    low_3 = mat2gray(reshape(term2_B(:,i),[M_Height M_Width]));
    max_B = max(B_HAT(:,i));  min_B = min(B_HAT(:,i));
    B_HAT_2d = reshape(B_HAT(:,i), [M_Height M_Width]);
    %%-----transfer to the range [0 1] to estimate missing pixels correctly
    B_1 = mat2gray(B_HAT_2d);
    temp_B_1 = mat2gray(B_HAT_2d(round(cropRatio*Height):round((1-cropRatio)*Height),round(cropRatio*Width):round((1-cropRatio)*Width)));
    temp_low_3 = mat2gray(low_3(round(cropRatio*Height):round((1-cropRatio)*Height),round(cropRatio*Width):round((1-cropRatio)*Width)));
    diff_mean_BHAT = mean(double(temp_B_1(:)))-mean(double(temp_low_3(:)));
    B_1 = B_1 - diff_mean_BHAT;
    %%-----replace missing pixels in B_HAT-------
    B_1([1:round(cropRatio*Height),round((1-cropRatio)*Height):end],:) = low_3([1:round(cropRatio*Height),round((1-cropRatio)*Height):end],:);
    B_1(:,[1:round(cropRatio*Width),round((1-cropRatio)*Width):end]) = low_3(:,[1:round(cropRatio*Width),round((1-cropRatio)*Width):end]);
    %%-----transfer to the original range--------
    B_1 = ((max_B-min_B)/(max(B_1(:))-min(B_1(:))))*(B_1-min(B_1(:)))+min_B;
    B_HAT(:,i) = B_1(:);
end

