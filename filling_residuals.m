function U_HAT_2d = filling_residuals(U_HAT_2d,current_img,cropRatio1)

temp = current_img;
temp(round(cropRatio1*size(current_img,1)):round((1-cropRatio1)*size(current_img,1)),...
    round(cropRatio1*size(current_img,2)):round((1-cropRatio1)*size(current_img,2))) = ...
    U_HAT_2d(round(cropRatio1*size(current_img,1)):round((1-cropRatio1)*size(current_img,1)),...
    round(cropRatio1*size(current_img,2)):round((1-cropRatio1)*size(current_img,2)));

U_HAT_2d = temp;

