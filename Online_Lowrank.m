function [E,A_HAT,B_HAT,U_HAT,V_HAT,control,ImMean] = Online_Lowrank(data_3D,A_HAT,B_HAT,U_HAT,V_HAT,control,Rank)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   This function solves Eq.7 in the following paper:    %%%
%%%   COROLA: A sequential solution to moving object       %%%
%%%   detection using low-rank approximation, CVIU journal %%%
%%%   Volume 146, May 2016, Pages 27–39                    %%%
%%%   Written by Moein Shakeri, updated June 2016          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%--------------------Preparing data--------------------------
%-------------------------------------------------------------
global M_Width;
global M_Height;

data_3D    = mat2gray(data_3D);
ImMean     = mean(data_3D(:));
Diff_mean  = data_3D - ImMean;
NUM        = size(Diff_mean,3);
sizeImg    = [size(Diff_mean,1),size(Diff_mean,2)];

%--building a 2D matrix for previous and current frames--
data_2D    = reshape(Diff_mean,prod(sizeImg),NUM);

%% Extracting Sparse E
rank1 = Rank; tau1 = 1; power = 1; k = Rank; tol = 1e-5;
%%%%%solving subproblems Eq.8, Eq.10, and Eq.12 in the paper %%%%%%
[Background,E0,error,A_HAT,B_HAT,U_HAT,V_HAT,control]=On_GreGoDec(data_2D,rank1,tau1,tol,power,k,A_HAT,B_HAT,U_HAT,V_HAT,control,Rank);
E1         = data_2D - Background;
E          = reshape(E1(:,end), [M_Height M_Width]);

end
