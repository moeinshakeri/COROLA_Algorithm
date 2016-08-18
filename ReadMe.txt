//Implementation of the COROLA method for a stationary camera from:
//
//"COROLA: A sequential solution to moving object detection using low-rank approximation"
//Moein Shakeri, Hong Zhang
//CVIU journal, Volume 146, May 2016, Pages 27–39.
//http://www.sciencedirect.com/science/article/pii/S1077314216000540
//http://webdocs.cs.ualberta.ca/~shakeri
//

Compiling mex files:
This work is pre-built for windows 64 bit. For other platforms you need to read readme files of gmm and gco folders for compiling those files on your platforms.

Running:
Main_Script_static.m shows 17 different examples similar to table.2 or table.3 in the paper as demo. Since we did not use any training data for gmm and low-rank approximation in this demo, COROLA needs some frames to become stable, Especially for moving backgrounds.

For each example:
-datalist : shows the name of dataset in data folder
-Learning_rate: initializes the learning rate of gmm.
-Dist: initializes distance threshold of gmm.
-First_frame and End_frame: initializes those frames that we want to process. For the End_frame in all examples we used a ground truth to show Precision, recall, and F_meature of the method for that dataset.

After initilizing, COROLA_Static can process the datalist and shows input and extracted foreground objects for each frame.

COROLA_Static:
This script is the main script of COROLA method. In this script we initilized Rank=3 for all examples. It can be tuned to obtain better results for other datasets.

data:
Since all datasets need a huge space, we cropped each dataset and use some part of them for the demo.

This work may not be copied or reproduced in whole or in part for any commercial purpose. 
Permission to copy in whole or in part without payment of fee is granted for nonprofit educational and research purposes.

