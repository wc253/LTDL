# A Low-rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising
All matlab codes of the paper TSP2020-A Low-rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising.

# Folder structure
```shell
data\                              :
├────HSIDnet_data.mat              :the test ICVL HSI of HSI-DeNet
├────jasperRidge_10band.mat        :
├────watercolors_MSI.mat           :
lib\                              
├───LTDL_utilize\           : functions of the proposed LTDL method
├───hyperspectralToolbox\   : HSI detection toolbox https://github.com/isaacgerg/matlabHyperspectralToolbox
├───tensor_toolbox\         : tensor processing toolbox http://www.sandia.gov/~tgkolda/TensorToolbox/index‐2.5.html
├───tensorlab\              : tensor processing toolbox https://www.tensorlab.net/versions.html#3.0
├───quality_assess\         : functions of quality assessment indices http://gr.xjtu.edu.cn/web/dymeng
├───compete_methods\
├───────────────────ksvdbox\     : http://www.cs.technion.ac.il/~ronrubin/software.html
├───────────────────naonlm3d\    : http://personales.upv.es/jmanjon/denoising/arnlm.html
├───────────────────BM3D\        : http://www.cs.tut.fi/~foi/GCF‐BM3D/
├───────────────────BM4D\        : http://www.cs.tut.fi/~foi/GCF‐BM3D/
├───────────────────tensor_dl\   : http://gr.xjtu.edu.cn/web/dymeng
├───────────────────KBRreg\      : http://gr.xjtu.edu.cn/web/dymeng
├───────────────────LLRT\        : http://www.escience.cn/people/changyi/codes.html
├───────────────────HSI-DeNet1\  : http://www.escience.cn/people/changyi/codes.html
├───────────────────MStSVD\      : https://github.com/ZhaomingKong/Hyperspectral_Image_denoising
├───LRTA.m                       : http://gr.xjtu.edu.cn/web/dymeng
├───PARAFAC.m                    : http://gr.xjtu.edu.cn/web/dymeng
├───myPlotROC.m                  : plot ROC curves
├───tight_subplot.m              : create "subplot" axes with adjustable gaps and margins
Demo_DL_syn.m                    : Detect road on the denoised jasperRidge HSIs via different methods (Fig. 7, 8). Please run it where we provide the pre‐computing denoising results and you can get the results in Fig. 7 and Fig. 8.
Demo_denoise_ge.m                : The demo on "watercolors" HSI with generated noise. It needs to take a lot of time so you can test all methods on a cropped HSI. Change noise level by modifying variables "sigma_ratio" in your experiments.
Demo_denoise_v2.m                : Denoise on the test ICVL HSIs and the jasperRidge HSI. Set “exp=0” to compare model driven methods with deep learning method (Table IV) and set 'exp=1' to denoise for target detection. To run the deep learning method in this demo, you should first download and install 'MatConvNet'. Please see 'Readme.txt' in the path 'lib\compete_methods\HSI‐DeNet1'.
Demo_target_detection.m          : Test the proposed LTDL's dictionary learning performance with synthetic data (Fig. 4). You can see the pre‐computed results in the road of 'result\pre_synthetic_data_test_once'.
```
# Datasets
CAVE from [here](http://www.cs.columbia.edu/CAVE/databases/multispectral/)<br>
ICVL from [here](http://icvl.cs.bgu.ac.il/hyperspectral/). We downsample the ICVL datasets by ```python msi=msi(1:2:size(msi,1),1:2:size(msi,2), :)```.<br>
Jasper Ridge from [here](https://rslab.ut.ac.ir/data)<br>
# Citation
X. Gong, W. Chen and J. Chen, "A Low-Rank Tensor Dictionary Learning Method for Hyperspectral Image Denoising," in IEEE Transactions on Signal Processing, vol. 68, pp. 1168-1180, 2020, doi: 10.1109/TSP.2020.2971441.

We would like to thank those researchers for making their codes and datasets publicly available. If you have any question, please feel free to contact me via: xiaogong@bjtu.edu.cn
