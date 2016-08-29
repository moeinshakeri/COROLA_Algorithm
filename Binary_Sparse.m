
function [S,Omega,energy_cut] = Binary_Sparse(E_hat,Rank,Init_mrf,Sigma,AdjMatrix,W_store,Weight,scale)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function solves Eq.15 in the following paper:                %%%
%%% Moein Shakeri and Hong Zhang,"COROLA: A sequential solution       %%%
%%% to moving object detection using low-rank approximation",         %%%
%%% CVIU journal, Volume 146, May 2016, Pages 27–39                   %%%
%%% Written by Moein Shakeri, updated June 2016                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

norm_E            = E_hat; % ((max_lowrank-min_lowrank)/(max(lowrank(:))-min(lowrank(:))))*(lowrank-min(lowrank(:)))+min_lowrank;
data_2D(:,1:Rank) = repmat(norm_E(:),[1 Rank]);
Omega             = true(size(data_2D)); % background support

%%--------------graph cuts initialization-------------------------
% GCO toolbox is called
hMRF              = GCO_Create(prod(Init_mrf.sizeImg),2);
GCO_SetSmoothCost( hMRF, [0 1;1 0] );
GCO_SetNeighbors( hMRF, Init_mrf.amplify * AdjMatrix );

%--------------------run MRF----------------------------
S_norm            = mat2gray(Sigma);
Weight            = (1-mat2gray(mat2gray(W_store)+ mat2gray(Weight)));
connectivity_mrf  = mat2gray(S_norm+Weight)+0.3;
connectivity_mrf_temp = connectivity_mrf;
connectivity_mrf1 = connectivity_mrf;
i = Rank;

GCO_SetDataCost( hMRF, (Init_mrf.amplify/Init_mrf.gamma)*[ 0.5*(data_2D(:,i)).^2 , scale*Init_mrf.beta*(ones(prod(Init_mrf.sizeImg),1))]');%, ~OmegaOut(:,i)*beta + OmegaOut(:,i)*0.5*max(E(:)).^2]' );
%                 GCO_SetDataCost( hMRF, (amplify/gamma)*[ 0.5*(data_2D(:,i)).^2 , (coeff*Learning_Rate1)*((connectivity_mrf(:))-abs(data_2D(:,i))/max(abs(data_2D(:,i))))]');%, ~OmegaOut(:,i)*beta + OmegaOut(:,i)*0.5*max(E(:)).^2]' );
GCO_Expansion(hMRF);
Omega1(:,i)       = ( GCO_GetLabeling(hMRF) == 1 )';
Omega2            = reshape(Omega1(1:prod(Init_mrf.sizeImg),i),[Init_mrf.sizeImg(1) Init_mrf.sizeImg(2)]);
Omega(:,Rank)     = Omega2(:);
S                 = ~Omega(:,Rank); 
energy_cut        = (Init_mrf.gamma/Init_mrf.amplify)*double(GCO_ComputeEnergy(hMRF));
GCO_Delete(hMRF);