
### Citation
If you find HSI-DeNet useful in your research, please consider citing:

	@article{2018ChangHSI,
	  title={HSI-DeNet: Hyperspectral Image Restoration via Deep Convolutional Nerual Network},
	  author={Yi Chang, Luxin Yan, Houzhang Fang, Sheng Zhong, and Wenshan Liao},
      journal={IEEE Trans. Geosci. Remote Sens.},
	  volume={57},
      number={2},
      pages={667 - 682},
      month={Feb.},
      year={2019},
      publisher={IEEE}
	}

### Main Contents

main_start_ms.m:  training demo.

get_test_ms.m:  testing demo

get_train_initial_HSI.m: setting the CNN structure 

We have provided an example HSIs sub-image for testing in \Testdata folder. And also we have released several pre-trained models for various noise cases. 

To run the training and testing demos, you should first download [MatConvNet](http://www.vlfeat.org/matconvnet/). The detailed installing procedure for Windows OS can be found (https://www.youtube.com/watch?v=DWNyp1xZ-ks).

After you have installed the MatconvNet, you should place the vllab_dag_loss.m and Tanh.m into the matconvnet-1.0-beta25\matlab\+dagnn folder, and backward.m and forward.m into matconvnet-1.0-beta25\matlab\+dagnn\@DagNN folder.

### Training dataset generating

We generate the training dataset from the ICVL HSI dataset. The generating function is GenerateData.m. You can also generate the training dataset on your own.

If you have any questions about the codes, please contact yichang@hust.edu.cn for further information.

