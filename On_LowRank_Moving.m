
function [E,tau,A_HAT,B_HAT,U_HAT,V_HAT,control,ImMean, ImData2] = On_LowRank_Moving(data_3D,A_HAT,B_HAT,U_HAT,V_HAT,control,Iteration,Rank)

%%--------------------Preparing the data--------------------------
%-----------------------------------------------------------------
global M_Width;
global M_Height;
cropRatio1 = 0.05;
data_3D = mat2gray(data_3D);
ImMean = mean(data_3D(:));
Diff_mean = data_3D - ImMean;
NUM = size(Diff_mean,3);
sizeImg = [size(Diff_mean,1),size(Diff_mean,2)];

%%---------Image registration and motion compensation--------------
%------------------------------------------------------------------

%--tau is transformation matrix---
% tau = zeros(6,2);
[registered_img,tau] = preAlign(Diff_mean);
tau1 = tau;
if sum(tau(:)) ~= 0 && Iteration > 1
    if Iteration == 2, count = 1; else count = size(data_3D,3)-1; end
    for i = 1 : count %size(data_3D,3)
        U_HAT_2d = reshape(U_HAT(:,i), [M_Height M_Width]);
        B_HAT_2d = reshape(B_HAT(:,i), [M_Height M_Width]);
        U_HAT_2d = warpImg(U_HAT_2d,-tau1(:,end-1),1,0);
        B_HAT_2d = warpImg(B_HAT_2d,-tau1(:,end-1),1,0);
        %--filling the residual parts of previous images after applying transformation
        U_HAT_2d = filling_residuals(U_HAT_2d,Diff_mean(:,:,end),cropRatio1);
        U_HAT(:,i) = U_HAT_2d(:);
        B_HAT(:,i) = B_HAT_2d(:);
    end
    B_HAT = filling_residuals1(U_HAT,B_HAT,V_HAT,Diff_mean(:,:,end),cropRatio1,Rank);
end
%--building a 2D matrix for previous and current frames--
data_2D = reshape(registered_img,prod(sizeImg),NUM);

%% Extracting Sparse E
rank1 = Rank; tau1=1;power = 2; k=Rank; tol = 1e-5;
%%%%%solving subproblems Eq.8, Eq.10, and Eq.12 in the paper %%%%%%
[Background,E0,error,A_HAT,B_HAT,U_HAT,V_HAT,control]=On_GreGoDec_moving(data_2D,rank1,tau1,tol,power,k,A_HAT,B_HAT,U_HAT,V_HAT,control);
% [Background,E0,error,A_HAT,B_HAT,U_HAT,V_HAT,control]=On_GreGoDec(data_2D,rank1,tau1,tol,power,k,A_HAT,B_HAT,U_HAT,V_HAT,control,Rank);
E1 = data_2D - Background;
E          = reshape(E1(:,end), [M_Height M_Width]);

ImData2 = registered_img + ImMean;
end
