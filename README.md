# A Low-rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising
All matlab codes of all experiments from the paper TSP2020-A Low-rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising.

# Folder structure
-data\: <br>
--HSIDnet_data.mat        :the test ICVL HSI of HSI-DeNet<br>
--jasperRidge_10band.mat  :<br>
--watercolors_MSI.mat     :<br>
-lib:<br>
--LTDL_utilize\           : functions of the LTDL method<br>
--hyperspectralToolbox\   : HSI detection toolbox https://github.com/isaacgerg/matlabHyperspectralToolbox<br>
--tensor_toolbox\         : tensor processing toolbox http://www.sandia.gov/~tgkolda/TensorToolbox/index‐2.5.html<br>
--tensorlab\              : tensor processing toolbox https://www.tensorlab.net/versions.html#3.0<br>
--quality_assess\         : functions of quality assessment indices http://gr.xjtu.edu.cn/web/dymeng<br>
--compete_methods\: <br>
---ksvdbox\                : http://www.cs.technion.ac.il/~ronrubin/software.html<br>
---naonlm3d\               : http://personales.upv.es/jmanjon/denoising/arnlm.html<br>
---BM3D\                   : http://www.cs.tut.fi/~foi/GCF‐BM3D/<br>
---BM4D\                   : http://www.cs.tut.fi/~foi/GCF‐BM3D/<br>
---tensor_dl\              : http://gr.xjtu.edu.cn/web/dymeng<br>
---KBRreg\                 : http://gr.xjtu.edu.cn/web/dymeng<br>
---LLRT\                   : http://www.escience.cn/people/changyi/codes.html<br>
---HSI-DeNet1\             : http://www.escience.cn/people/changyi/codes.html<br>
---MStSVD\                 : https://github.com/ZhaomingKong/Hyperspectral_Image_denoising<br>
---LRTA.m                  : http://gr.xjtu.edu.cn/web/dymeng<br>
---PARAFAC.m               : http://gr.xjtu.edu.cn/web/dymeng<br>
--findFMeasure.m         : function for getting GIF result<br>
--myPlotROC.m            : plotting ROC curves<br>
--tight_subplot.m        : creating "subplot" axes with adjustable gaps and margins<br>
-Demo_DL_syn.m             : Detect road on the denoised jasperRidge HSIs via different methods (Fig. 7, 8). Please run it where we provide the pre‐computing denoising results                               and you can get the results in Fig. 7 and Fig. 8.<br>
-Demo_denoise_ge.m         : The demo on "watercolors" HSI with generated noise. It needs to take a lot of time so you can test all methods on a cropped HSI. Change noise level                               by modifying variables "sigma_ratio" in your experiments.<br>
-Demo_denoise_v2.m         : Denoise on the test ICVL HSIs and the jasperRidge HSI. Set “exp=0” to compare model driven methods with deep learning method (Table IV) and set                                   “exp=1” to denoise for target detection. To run the deep learning method in this demo, you should first download and install “MatConvNet”. Please see                             'Readme.txt' in the path 'lib\compete_methods\HSI‐DeNet1'.<br>
-Demo_target_detection.m   : Test the proposed LTDL's dictionary learning performance with synthetic data (Fig. 4). You can see the pre‐computed results in the road of                                       'result\pre_synthetic_data_test_once'.<br>

# Citation
X. Gong, W. Chen and J. Chen, "A Low-Rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising," in IEEE Transactions on Signal Processing, vol. 68, pp. 1168-1180, 2020, doi: 10.1109/TSP.2020.2971441.
