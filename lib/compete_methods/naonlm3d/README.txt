/* Jose V. Manjon - jmanjon@fis.upv.es                                     */
/* Unicersidad Politecinca de Valencia, Spain                              */ 
/* Pierrick Coupe - pierrick.coupe@gmail.com                               */
/* Brain Imaging Center, Montreal Neurological Institute.                  */
/* Mc Gill University                                                      */
/*                                                                         */
/* Copyright (C) 2010 Jose V. Manjon and Pierrick Coupe                    */

%**************************************************************************
%                                                                         *
%              Adaptive Non-Local Means Denoising of MR Images            *             
%              With Spatially Varying Noise Levels                        *
%                                                                         * 
%              Jose V. Manjon, Pierrick Coupe, Luis Marti-Bonmati,        *
%              D. Louis Collins and Montserrat Robles                     *
%                                                                         *
%**************************************************************************


/*                          Details on MBONLM filter                      */
/***************************************************************************
 *  The ONLM filter is described in:                                       *
 *                                                                         *
 *  P. Coup?, P. Yger, S. Prima, P. Hellier, C. Kervrann, C. Barillot.     *
 *  An Optimized Blockwise Non Local Means Denoising Filter for 3D Magnetic*
 *  Resonance Images. IEEE Transactions on Medical Imaging, 27(4):425-441, * 
 *  Avril 2008                                                             *
 ***************************************************************************/

/*                          Details on Wavelet mixing                     */
/***************************************************************************
 *  The hard wavelet subbands mixing is described in:                      *
 *                                                                         *
 *  P. Coup?, S. Prima, P. Hellier, C. Kervrann, C. Barillot.              *
 *  3D Wavelet Sub-Bands Mixing for Image Denoising                        *
 *  International Journal of Biomedical Imaging, 2008                      * 
 ***************************************************************************/

/*                      Details on Rician adaptation                      */
/***************************************************************************
 *  The adaptation to Rician noise is described in:                        *
 *                                                                         *
 *  N. Wiest-Daessl?, S. Prima, P. Coup?, S.P. Morrissey, C. Barillot.     *
 *  Rician noise removal by non-local means filtering for low              *
 *  signal-to-noise ratio MRI: Applications to DT-MRI. In 11th             *
 *  International Conference on Medical Image Computing and                *
 *  Computer-Assisted Intervention, MICCAI'2008,                           *
 *  Pages 171-179, New York, ?tats-Unis, Septembre 2008                    *
 ***************************************************************************/


Matlab code for the experiments of paper:

"Adaptive Non-Local Means Denoising of MR Images With Spatially Varying Noise Levels"


1) Select the directory where the files have been extracted 
as work directory in matlab.

2) run the scripts:

test3D_Gaussian_homo_T1.m     (This script compares wavelet mixing filter and the proposed filter on T1 data with homogeneus Gaussian noise)     
test3D_Rician_variable_T1.m   (This script compares wavelet mixing filter and the proposed filter on T1 data with variable Rician noise) 
test3D_Gaussian_variable_T1.m (This script compares wavelet mixing filter and the proposed filter on T1 data with variable Gaussian noise) 
test3D_Rician_homo_T1.m       (This script compares wavelet mixing filter and the proposed filter on T1 data with homogeneus Rician noise)

3) Go to take a coffee :)



Usage of MBONLM3D:
  
fima=MBONLM3D(nima,w,f,h,r)

nima: noisy volume
w: radius of the 3D search area (typical value, w=3)
f: radius of the 3D patch used to compute similarity (typical value, f=1)
h: noise standard deviation 
r: flag to use Gaussian or Rician adapted filtering (0:Gaussian,1:Rician)
fima: filtered volume

Usage of MABONLM3D:
  
fima=MABONLM3D(nima,w,f,r)

nima: noisy volume
w: radius of the 3D search area (typical value, w=3)
f: radius of the 3D patch used to compute similarity (typical value, f=1)
r: flag to use Gaussian or Rician adapted filtering (0:Gaussian,1:Rician)
fima: filtered volume


Note: the mex code is a multithreaded version for windows.
  