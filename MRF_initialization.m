function Init_mrf = MRF_initialization(M_Height,M_Width)
% This function initializes parameters of mrf for extracting binary mask S
% written by Moein Shakeri, June 2016
Init_mrf.beta  = 0.0005;
Init_mrf.lambda= 5;
Init_mrf.gamma = Init_mrf.beta*Init_mrf.lambda;
Init_mrf.alpha = 0.01;
Init_mrf.sizeImg = [M_Height,M_Width];
Init_mrf.amplify = 10*Init_mrf.lambda;