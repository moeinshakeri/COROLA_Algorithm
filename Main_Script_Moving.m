%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  This script is a demo that shows moving object detection using    %%%
%%%  COROLA for moving cameras. Here is 4 examples compatible with     %%%
%%%  Table 6 in the following paper.                                   %%%
%%%                                                                    %%%
%%%  Moein Shakeri and Hong Zhang,"COROLA: A sequential solution       %%%
%%%  to moving object detection using low-rank approximation",         %%%
%%%  CVIU journal, Volume 146, May 2016, Pages 27–39.                  %%%
%%% http://www.sciencedirect.com/science/article/pii/S1077314216000540 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 1: cars6 sequence
dataList = {'cars6'};
Learning_Rate = 0.05; Dist = 20; First_frame = 1; End_frame = 30;
offset = 27;  scale =0.5;
COROLA_Moving;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 2: cars7 sequence
% dataList = {'cars7'};
% Learning_Rate = 0.05; Dist = 10; First_frame = 1; End_frame = 24;
% offset = 22;  scale =2;
% COROLA_Moving;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 3: people1 sequence
% dataList = {'people1'};
% Learning_Rate = 0.002; Dist = 10; First_frame = 1; End_frame = 40;
% offset = 15;  scale = 1;
% COROLA_Moving;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example 4: tennis sequence
% dataList = {'tennis'};
% Learning_Rate = 0.002; Dist = 10; First_frame = 1; End_frame = 50;
% offset = 1;  scale = 1.5;
% COROLA_Moving;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
