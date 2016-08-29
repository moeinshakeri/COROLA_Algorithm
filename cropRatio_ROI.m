function update_img = cropRatio_ROI(update_img,img)

global M_Height; global M_Width;

cropRatio = 0.05;

if size(img,3)>1
    update_img([1:round(cropRatio*M_Height),round((1-cropRatio)*M_Height):end],:) = img([1:round(cropRatio*M_Height),round((1-cropRatio)*M_Height):end],:,end);
    update_img(:,[1:round(cropRatio*M_Width),round((1-cropRatio)*M_Width):end]) = img(:,[1:round(cropRatio*M_Width),round((1-cropRatio)*M_Width):end],end);
else
    update_img([1:round(cropRatio*M_Height),round((1-cropRatio)*M_Height):end],:) = img([1:round(cropRatio*M_Height),round((1-cropRatio)*M_Height):end],:);
    update_img(:,[1:round(cropRatio*M_Width),round((1-cropRatio)*M_Width):end]) = img(:,[1:round(cropRatio*M_Width),round((1-cropRatio)*M_Width):end]);
end
           
