%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This script is written for the following paper:                    %%%
%%% Moein Shakeri and Hong Zhang,"COROLA: A sequential solution        %%%
%%% to moving object detection using low-rank approximation",          %%%
%%% CVIU journal, Volume 146, May 2016, Pages 27–39                    %%%
%%% http://www.sciencedirect.com/science/article/pii/S1077314216000540 %%%
%%% Written by Moein Shakeri, updated August 2016                      %%%
%%% All rights reserved.                                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global M_Width; global M_Height;
%%%%%%%%%%%%-------Adding folders-------%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('gmm');addpath(genpath('gco-v3.0'));addpath(genpath('data'));addpath('On_LRA');addpath('PROPACK');addpath('internal');

%%%%%%%%%%%%------Loading data path-----%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataName           = dataList{1}; load(['data\real_data\MovingCam\' dataName],'ImData');
temp_GT            = strcat('data\real_data\GroundTruth\GT_',dataName,num2str(End_frame),'.bmp'); GT_Img = imread(temp_GT);
%%%%%%%%%%%%------data for first frames-----%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rank               = 1;
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
U_HAT              = zeros(M_Height*M_Width,Rank); %[];
V_HAT              = zeros(Rank,Rank); %[];
U_HAT_offset       = U_HAT;
V_HAT_offset       = V_HAT;
A_HAT_offset       = A_HAT;
B_HAT_offset       = B_HAT;
control            = 1;
alpha2             = 0.1;  % learning parameter for E_hat.
Termination_Error  = 1e-7;
Training_Num       = First_frame + offset;
%%%%%%%%%-----Initializing GMM Parameters-----%%%%%%%%%%
BG_3D              = repmat(ImData1(:,:,end),[1 1 3]);
h                  = mexCvBSLib(BG_3D);%Initialize
pause(0.5);
Distance           =(Dist*ones(size(BG_3D)));  % this amount goes to set_Distance function.
W_store            = zeros(M_Height,M_Width);
Sigma              = 12*ones(M_Height,M_Width);
Weight             = ones(M_Height,M_Width);
mexCvBSLib(BG_3D,h,[0.01 12*12 0 0.5],uint8(Distance));  %set parameters
if Learning_Rate < 0.0005, Learning_Rate1 = Learning_Rate/2; else  Learning_Rate1 = Learning_Rate; end
%%%%%%%%%%%%----Initializing MRF parameters------%%%%%%%%%%%%%
Init_mrf           = MRF_initialization(M_Height,M_Width);
AdjMatrix          = getAdj(Init_mrf.sizeImg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ImData_count       = 1;
BG                 = ImData1(:,:,1);
low_3              = mat2gray(BG);
Mask_BG            = 0*(ImData1(:,:,1));
cropRatio          = 0.05;      % This value set a region of interest.
diff_mean_bg       = 0;
for Iteration=First_frame+Rank-1:End_frame
    
    S              = ones(M_Height*M_Width,1);      %---forground support
    ImData_count   = ImData_count +1;
    %%%%%%%-----Initializing input frame parameters-----%%%%%%
    ImData_temp = ImData(:,:,Iteration);
    ImData_temp = imresize(ImData_temp,[M_Height M_Width]);
    ImData_temp = imfilter(ImData_temp,SE);
    if ImData_count>2,  ImData1(:,:,1:end-1) = ImData1(:,:,2:end); end
    if Rank ==1, ImData1(:,:,2) = ImData_temp; else ImData1(:,:,end) = ImData_temp; end
    old_Mask       = ones(M_Height, M_Width);
    old_energy     = inf; % total energy
    energy_old     = inf; % total energy
    local_opt      = 0;
    %%%%%%%%%------Iteration over each frame------%%%%%%%%%%%%
    for inner_iter = 1:min(4*Rank,20)
        %%%%%%%-------Section 3.2 in the paper--------%%%%%%%%
        if inner_iter == 1
            [E, tau, A_HAT, B_HAT,U_HAT,V_HAT,control,ImMean, ImData_iter] = On_LowRank_Moving(ImData1,A_HAT,B_HAT,U_HAT,V_HAT,control,Iteration,Rank);  %Solving Eq.7 for the first iteration using moving camera--%
            UNorm = 0.5*norm(U_HAT(:),'fro');
            if Iteration < Training_Num
                [E_offset, tau_offset, A_HAT_offset, B_HAT_offset,U_HAT_offset,V_HAT_offset,control,ImMean_offset] = On_LowRank_Moving(ImData1,A_HAT_offset,B_HAT_offset,U_HAT_offset,V_HAT_offset,control,Iteration,1);
            end
            %--------update position of GMM parameters---------------------
            [GMM_input, Updated_BG, replace_param] = update_gmm_pos(BG, tau, ImData1(:,:,end));
            [F, Red, Green, Blue, Sigma, Weight, dist_new] = mexCvBSLib(GMM_input,h,[Learning_Rate 10*10 0 0.5],uint8(Distance),uint8(replace_param));%set parameters
            if Iteration > First_frame+offset, mexCvBSLib(GMM_input,h,[Learning_Rate 10*10 0 0.5],uint8(Distance)); end
            %-------- update GMM model for current frame-------------
            [F, Red, Green, Blue, Sigma, Weight, dist_new]=mexCvBSLib(GMM_input,h);   %--applying GMM to seperate periodic noise from moving object
            %--------------------------------------------------------
            if Iteration < Training_Num
                E_hat = alpha2*E + (1-alpha2)*E.*mat2gray(F);    %%%%---Eq.14 in the paper,
                E_hat_offset = alpha2*E_offset + (1-alpha2)*E_offset.*mat2gray(F);
            else
                E_hat = alpha2*E + (1-alpha2)*E.*mat2gray(F);    %%%%---Eq.14 in the paper,
            end
        elseif sum(S)>2*Rank
            Reduced_E = Update_Lowrank_Moving(ImData_iter,S,U_HAT,V_HAT,Rank,ImMean);   %--Solving Eq.7 for further iterations--%
            E_hat = 0.8*E_hat + 0.2*Reduced_E;
        end
        %%%%%%%%------Extracting Mask S using MRF for the first iteration of each frame--------%%%%%%%%%%%
        %%%%%%%%-----------------------------Section 3.3 in the paper--------------------------%%%%%%%%%%
        if Iteration <= Training_Num
            [S,Omega,energy_cut] = Binary_Sparse(E_hat_offset,Rank,Init_mrf,Sigma,AdjMatrix,W_store,Weight,0.5*scale);    %--Solving Eq.15 in the paper--%
        else
            [S,Omega,energy_cut] = Binary_Sparse(E_hat,Rank,Init_mrf,Sigma,AdjMatrix,W_store,Weight,scale);    %--Solving Eq.15 in the paper--%
        end
        if energy_cut <= old_energy,
            old_energy = energy_cut;
            old_Mask   = S;
        end
        ObjArea = sum(S);
        Mask    = reshape(S,[M_Height M_Width]); 
        Mask    = cropRatio_ROI(Mask,zeros(M_Height,M_Width));
        if inner_iter == 1
            %-----update the previous BG_model---------
            if Iteration > First_frame, diff_mean_bg = mean(mean(double(Updated_BG(Mask==0))))-mean(mean(double(ImData_temp(Mask==0)))); end
            [BG, Mask_BG, mask1] = update_prev_BG_model(Updated_BG, ImData1, tau, Mask, Mask_BG, diff_mean_bg);
            L   = (U_HAT*V_HAT);
            L_j = reshape(L(:,end), [M_Height M_Width]);          %---L_j is low-rank of the current frame
            %-----Matching the range of U_HAT and B_HAT------%
            [A_HAT, B_HAT, U_HAT, A_HAT_offset, U_HAT_offset, B_HAT_offset] = Matching_ranges(L_j, mask1, Mask, ImData_temp, U_HAT, V_HAT, A_HAT, B_HAT, U_HAT_offset, B_HAT_offset, A_HAT_offset, V_HAT_offset, ImMean, ImMean_offset, Training_Num, First_frame, Iteration);
        end
        energy_cut = 0.5*norm(mat2gray(ImData_temp(:)-ImMean)-(L(:,end)),'fro')^2 + Init_mrf.beta*ObjArea;
        energy     = energy_cut + Init_mrf.alpha*UNorm;
        %%----check termination condition----------------------
        if abs(energy_old-energy)/energy < Termination_Error; break; end
        energy_old = energy;
    end
    if Iteration >= Training_Num
        [S,Omega,energy_cut] = Binary_Sparse(E_hat,Rank,Init_mrf,Sigma,AdjMatrix,W_store,Weight,scale);    %--Solving Eq.15 in the paper--%
        Mask = reshape(S,[M_Height M_Width]); 
    end
    %---------------------------------------------------------
    %%%%%%%%-----Showing results for each frame-----%%%%%%%%%%
    final_foreground        = ImData1(:,:,end).*uint8(Mask);
    final_foreground(:,:,2) = ImData1(:,:,end).*uint8((1-Mask));
    final_foreground(:,:,3) = ImData1(:,:,end).*uint8((1-Mask));
    if 1 %dataID==1
        figure(1), %subplot(1,2,2),
        imshow(final_foreground);
        figure(1), %subplot(1,2,2),
        line([round(cropRatio*M_Width) round((1-cropRatio)*M_Width)],[round(cropRatio*M_Height) round(cropRatio*M_Height)],'Color','r');
        figure(1), %subplot(1,2,2),
        line([round(cropRatio*M_Width) round((1-cropRatio)*M_Width)],[round((1-cropRatio)*M_Height) round((1-cropRatio)*M_Height)],'Color','r');
        figure(1), %subplot(1,2,2),
        line([round(cropRatio*M_Width) round(cropRatio*M_Width)],[round(cropRatio*M_Height) round((1-cropRatio)*M_Height)],'Color','r');
        figure(1), %subplot(1,2,2)
        line([round((1-cropRatio)*M_Width) round((1-cropRatio)*M_Width)],[round(cropRatio*M_Height) round((1-cropRatio)*M_Height)],'Color','r');
        title('Foreground Object','fontsize',12);
    end
    disp(['Frame_number = ', num2str(Iteration), '    Number of Iterations = ', num2str(inner_iter)]);
    figure(2),subplot(1,3,1), imshow(mat2gray(L_j)); title('Input Frame');
    subplot(1,3,2), imshow(mat2gray(E_hat)); title('E hat (outliers)');
    subplot(1,3,3), imshow(mat2gray(Mask)); title('Foreground Mask');
end
mexCvBSLib(h);%Release memory
%%%%%%%------Computing accuracy of COROLA------%%%%%%%%
[Precision,Recall,F_measure] = Pre_Rec(Mask, GT_Img);
disp(['Precision = ', num2str(Precision), ' **** Recall = ',num2str(Recall), ' **** F_measure = ',num2str(F_measure)]);

