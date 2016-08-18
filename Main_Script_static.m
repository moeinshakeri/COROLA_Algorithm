%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  This script is a demo that shows moving object detection using    %%%
%%%  COROLA. Here is 17 examples compatible with Table.2 and 3 in      %%%
%%%  the following paper.                                              %%%
%%%                                                                    %%%
%%%  Moein Shakeri and Hong Zhang,"COROLA: A sequential solution       %%%
%%%  to moving object detection using low-rank approximation",         %%%
%%%  CVIU journal, Volume 146, May 2016, Pages 27–39.                  %%%
%%% http://www.sciencedirect.com/science/article/pii/S1077314216000540 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 1: Watersurface sequence
dataList = {'waterSurface'};
Learning_Rate = 0.0007; Dist = 10; First_frame = 1; End_frame = 24;
COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 2: Fountain
% dataList = {'Fountain'};
% Learning_Rate = 0.0007; Dist = 10; First_frame = 1; End_frame = 253;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 3: Curtain
% dataList = {'Curtain'};
% Learning_Rate = 0.0005; Dist = 6; First_frame = 1; End_frame = 372;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 4: hall
% dataList = {'hall'};
% Learning_Rate = 0.0005; Dist = 8; First_frame = 1; End_frame = 427;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 5: Campus
% dataList = {'Campus'};
% Learning_Rate = 0.002; Dist = 10; First_frame = 1; End_frame = 372;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 6: Escalator
% dataList = {'Escalator'};
% Learning_Rate = 0.002; Dist = 10; First_frame = 1; End_frame = 324;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 7: Lobby
% dataList = {'Lobby'};
% Learning_Rate = 0.0007; Dist = 10; First_frame = 1; End_frame = 288;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 8: ShoppingMall
% dataList = {'ShoppingMall'};
% Learning_Rate = 0.002; Dist = 15; First_frame = 1; End_frame = 233;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 9: Canoe
% dataList = {'Canoe'};
% Learning_Rate = 0.0007; Dist = 10; First_frame = 1; End_frame = 266;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 10: Fall
% dataList = {'Fall'};
% Learning_Rate = 0.002; Dist = 19; First_frame = 1; End_frame = 500;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 11: Fountain02
% dataList = {'Fountain02'};
% Learning_Rate = 0.0007; Dist = 6; First_frame = 1; End_frame = 420;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 12: Overpass
% dataList = {'overpass'};
% Learning_Rate = 0.0007; Dist = 6; First_frame = 1; End_frame = 229;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 13: Waving trees
% dataList = {'W_trees'};
% Learning_Rate = 0.008; Dist = 8; First_frame = 1; End_frame = 247;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 14: bootstrap
% dataList = {'Bootstrap'};
% Learning_Rate = 0.0007; Dist = 10; First_frame = 1; End_frame = 299;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 15: Camouflage
% dataList = {'Camouflage'};
% Learning_Rate = 0.0005; Dist = 17; First_frame = 1; End_frame = 251;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 16: ForegroundAperture
% dataList = {'ForegroundAperture'};
% Learning_Rate = 0.001; Dist = 15; First_frame = 1; End_frame = 289;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 17: TimeOfDay
% dataList = {'TimeOfDay'};
% Learning_Rate = 0.0005; Dist = 4; First_frame = 1; End_frame = 350;
% COROLA_Static;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

