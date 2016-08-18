
function Reduced_E = Update_Lowrank(ImData1,S,U_HAT,V_HAT,Rank,ImMean0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   This function solves Eq.7 in the following paper:    %%%
%%%   COROLA: A sequential solution to moving object       %%%
%%%   detection using low-rank approximation, CVIU journal %%%
%%%   Volume 146, May 2016, Pages 27–39                    %%%
%%%   Written by Moein Shakeri, updated June 2016          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global M_Width;
global M_Height;

ImData1_3D     = mat2gray(ImData1);
ind1           = find(S>0);
ImData1_2D     = reshape(ImData1_3D, [M_Height*M_Width, size(ImData1_3D,3)]);
LowRank        = U_HAT*V_HAT + ImMean0;
LowRank        = mat2gray(LowRank);
ImData1_reduce = ImData1_2D(ind1(:),end-1:end);
ImData2        = [ImData1_reduce LowRank(ind1(:),end-Rank+1:end)];
ImMean         = mean(ImData2(:));
ImData2        = ImData2 - ImMean; 
Reduced_E      = zeros(M_Height*M_Width,1);
%% Extracting Sparse E
rank1 = 2*Rank; tau1=1; power = 7; k=1; tol = 1e-10;
[Background,E1,error,time]=GreGoDec(ImData2,rank1,tau1,tol,power,k);
% [B,E1,error,A_OBGS,B_OBGS,U_OBGS,V_OBGS,control]=On_GreGoDec_second(ImData2,rank1,tau1,tol,power,k,A_OBGS_reduce,B_OBGS_reduce,U_OBGS_reduce,V_OBGS_reduce,control,Rank);
E                 = ImData2 - Background;
Reduced_E(ind1,1) = E(:,end);
Reduced_E         = reshape(Reduced_E, [M_Height M_Width]);
end

    