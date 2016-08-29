%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This script is written for the following paper:                    %%%
%%% Moein Shakeri and Hong Zhang,"COROLA: A sequential solution        %%%
%%% to moving object detection using low-rank approximation",          %%%
%%% CVIU journal, Volume 146, May 2016, Pages 27–39                    %%%
%%% http://www.sciencedirect.com/science/article/pii/S1077314216000540 %%%
%%% Written by Moein Shakeri, updated June 2016                        %%%
%%% All rights reserved.                                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global M_Width; global M_Height;
%%%%%%%%%%%%-------Adding folders-------%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('gmm');addpath(genpath('gco-v3.0'));addpath(genpath('data'));addpath('On_LRA');addpath('PROPACK');

%%%%%%%%%%%%------Loading data path-----%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataName           = dataList{1}; load(['data\real_data\StaticCam\' dataName],'ImData');
temp_GT            = strcat('data\real_data\GroundTruth\GT_',dataName,num2str(End_frame),'.bmp'); GT_Img = imread(temp_GT);
%%%%%%%%%%%%------data for first frames-----%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rank               = 3;
F_s                = 3;        % filter sise
ImData1            = ImData(:,:,First_frame:First_frame+Rank-1);
[M_Height,M_Width] = size(ImData(:,:,1));
ImData1            = imresize(ImData1,[M_Height M_Width]);
SE                 = fspecial('gaussian', F_s, F_s);
ImData1            = imfilter(ImData1,SE);

%%%%%%%%%%%%%----- low-rank parameters-----%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_HAT              = zeros(Rank,Rank);
B_HAT              = zeros(M_Height*M_Width,Rank);
U_HAT              = [];
V_HAT              = [];
control            = 1;
alpha2             = 0.1;  % learning parameter for E_hat.
Termination_Error  = 1e-4;
%%%%%%%%%-----Initializing GMM Parameters-----%%%%%%%%%%
BG_3D              = repmat(ImData1(:,:,end),[1 1 3]);
h                  = mexCvBSLib(BG_3D);%Initialize
pause(0.5);
Distance           =(Dist*ones(size(BG_3D)));  % this amount goes to set_Distance function.
W_store            = zeros(M_Height,M_Width);
mexCvBSLib(BG_3D,h,[0.02 12*12 0 0.5],uint8(Distance));  %set parameters
if Learning_Rate < 0.0005, Learning_Rate1 = Learning_Rate/2; else  Learning_Rate1 = Learning_Rate; end

%%%%%%%%%%%%----Initializing MRF parameters------%%%%%%%%%%%%%
Init_mrf           = MRF_initialization(M_Height,M_Width);
AdjMatrix          = getAdj(Init_mrf.sizeImg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ImData_count       = 1;

for Iteration=First_frame+Rank-1:End_frame  
    
    S              = ones(M_Height*M_Width,1);      %---forground support
    ImData_count   = ImData_count +1;
    %%%%%%%-----Initializing input frame parameters-----%%%%%%
    ImData_temp    = ImData(:,:,Iteration);
    ImData_temp    = imresize(ImData_temp,[M_Height M_Width]);
    ImData_temp    = imfilter(ImData_temp,SE);
    if ImData_count> 2,  ImData1(:,:,1:end-1) = ImData1(:,:,2:end); end
    if Rank ==1, ImData1(:,:,2) = ImData_temp; else ImData1(:,:,end) = ImData_temp; end
    Final_Mask     = ones(M_Height, M_Width);
    old_Mask       = ones(M_Height, M_Width);
    old_energy     = inf; % total energy
    energy_old     = inf; % total energy
    local_opt      = 0;
    %%%%%%%%%------Iteration over each frame------%%%%%%%%%%%%
    for inner_iter = 1:min(2*Rank,20)
        %%%%%%%-------Section 3.2 in the paper--------%%%%%%%%
        if inner_iter == 1
            [E, A_HAT, B_HAT,U_HAT,V_HAT,control,ImMean] = Online_Lowrank(ImData1,A_HAT,B_HAT,U_HAT,V_HAT,control,Rank);   %Solving Eq.7 for the first iteration--%
            UNorm = 0.5*norm(U_HAT(:),'fro');
            if Iteration ==40+First_frame, mexCvBSLib(BG_3D,h,[Learning_Rate 10*10 0 0.5],uint8(Distance)); end
            GMM_input = repmat(ImData1(:,:,end),[1 1 3]);
            [F, Red, Green, Blue, Sigma, Weight, dist_new]=mexCvBSLib(GMM_input,h);   %--applying GMM to seperate periodic noise from moving object
            W_store = W_store + double(Weight);
            E_hat = alpha2*E + (1-alpha2)*E.*mat2gray(F);   %%%%---Eq.14 in the paper, 
        elseif sum(S)>2*Rank
            Reduced_E = Update_Lowrank(ImData1,S,U_HAT,V_HAT,Rank,ImMean);   %--Solving Eq.7 for further iterations--%
            E_hat = 0.8*E_hat + 0.2*Reduced_E; 
        end
        if (inner_iter==1 || sum(S)>2*Rank)
            %%%%%%%%------Extracting Mask S using MRF --------%%%%%%%%%%%
            %%%%%%%%--------Section 3.3 in the paper-----------%%%%%%%%%%
            [S,Omega,energy_cut] = Binary_Sparse(E_hat,Rank,Init_mrf,Sigma,AdjMatrix,W_store,Weight,1);    %--Solving Eq.15 in the paper--%
            if energy_cut <= old_energy,
                old_energy = energy_cut;
                old_Mask   = S;
            else
                S = old_Mask;
                local_opt = local_opt + 1;
                if local_opt > 5, break; end
            end
            ObjArea = sum(S);
            Final_Mask = Final_Mask.*reshape(S,[M_Height M_Width]);    %---Updating forground mask
            L = U_HAT*V_HAT; 
            L_j = reshape(L(:,end),[M_Height M_Width]);     %---L_j is low-rank of the current frame
            BG_3D = uint8(255*repmat(L_j,[1 1 3]));
            energy_cut = 0.5*norm(mat2gray(ImData_temp(:)-ImMean)-(L(:,end)),'fro')^2 + Init_mrf.beta*ObjArea;
            energy = energy_cut + Init_mrf.alpha*UNorm;
 
            %% check termination condition
            if abs(energy_old-energy)/energy < Termination_Error; break; end
            energy_old = energy;
        end
    end
    %%%%%%%%-----Showing results for each frame-----%%%%%%%%%%
    disp(['Frame_number = ', num2str(Iteration), '    Termination Error = ' num2str(abs(energy_old-energy)/energy)]);
    figure(1),
    subplot(1,2,2),imagesc(Final_Mask); colormap(gray);axis image;axis off, title('Foreground Mask');
    subplot(1,2,1),imagesc(ImData(:,:,Iteration)); colormap(gray);axis image;axis off, title('Input');
end
mexCvBSLib(h);%Release memory
%%%%%%%------Computing accuracy of COROLA------%%%%%%%%
[Precision,Recall,F_measure] = Pre_Rec(Final_Mask, GT_Img);
disp(['Precision = ', num2str(Precision), ' **** Recall = ',num2str(Recall), ' **** F_measure = ',num2str(F_measure)]);
