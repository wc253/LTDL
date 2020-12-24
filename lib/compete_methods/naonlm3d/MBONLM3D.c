/* Pierrick Coupe - pierrick.coupe@gmail.com                               */
/* Jose V. Manjon - jmanjon@fis.upv.es                                     */
/* Brain Imaging Center, Montreal Neurological Institute.                  */
/* Mc Gill University                                                      */
/*                                                                         */
/* Copyright (C) 2008 Pierrick Coupe and Jose V. Manjon                    */

/***************************************************************************
*              3D Adaptive Multiresolution Non-Local Means Filter          *
* Pierrick Coupe a, Jose V. Manjon, Montserrat Robles , D. Louis Collins   *
***************************************************************************/


/*                          Details on ONLM filter                        */
/***************************************************************************
 *  The ONLM filter is described in:                                       *
 *                                                                         *
 *  P. Coupé, P. Yger, S. Prima, P. Hellier, C. Kervrann, C. Barillot.     *
 *  An Optimized Blockwise Non Local Means Denoising Filter for 3D Magnetic*
 *  Resonance Images. IEEE Transactions on Medical Imaging, 27(4):425-441, * 
 *  Avril 2008                                                             *
 ***************************************************************************/


#include "math.h"
#include "mex.h"
#include <stdlib.h>
#include "matrix.h"
// undef needed for LCC compiler
#undef EXTERN_C
#include <windows.h>
#include <process.h>  

typedef struct{
    int rows;
    int cols;
    int slices;
    double * in_image;   
    double * means_image;
    double * var_image;    
    double * estimate;    
    double * label;    
    int ini;
    int fin;
    int radioB;
    int radioS;
    double sigma; 
}myargument;

bool rician=false;

/* Function which compute the weighted average for one block */
void Average_block(double *ima,int x,int y,int z,int neighborhoodsize,double *average, double weight, int sx,int sy,int sz)
{
int x_pos,y_pos,z_pos;
bool is_outside; 
int a,b,c,ns,sxy,count;

ns=2*neighborhoodsize+1;
sxy=sx*sy;

count = 0;

	for (c = 0; c<ns;c++)
	{
       z_pos = z+c-neighborhoodsize;
       for (b = 0; b<ns;b++)
	   {
            y_pos = y+b-neighborhoodsize;
			for (a = 0; a<ns;a++)
			{				
				x_pos = x+a-neighborhoodsize;											

                is_outside = false;
				if ((x_pos < 0) || (x_pos > sx-1)) is_outside = true;
			    if ((y_pos < 0) || (y_pos > sy-1)) is_outside = true;
		        if ((z_pos < 0) || (z_pos > sz-1)) is_outside = true;
		
				if(rician)
                {
				    if (is_outside)
					  average[count] = average[count] + ima[z*(sxy)+(y*sx)+x]*ima[z*(sxy)+(y*sx)+x]*weight;
				    else	
					  average[count] = average[count] + ima[z_pos*(sxy)+(y_pos*sx)+x_pos]*ima[z_pos*(sxy)+(y_pos*sx)+x_pos]*weight;
                }
                else
                {
                    if (is_outside)
					  average[count] = average[count] + ima[z*(sxy)+(y*sx)+x]*weight;
				    else	
					  average[count] = average[count] + ima[z_pos*(sxy)+(y_pos*sx)+x_pos]*weight;
                }                
				count++;                
			}
		}
	}
}

/* Function which computes the value assigned to each voxel */
void Value_block(double *Estimate, double *Label,int x,int y,int z,int neighborhoodsize,double *average, double global_sum, int sx,int sy,int sz,double bias)
{
int x_pos,y_pos,z_pos;
int ret;
bool is_outside;
double value = 0.0;
double label = 0.0;
double denoised_value =0.0;
int count=0 ;
int a,b,c,ns,sxy;

extern bool rician;

ns=2*neighborhoodsize+1;
sxy=sx*sy;

	for (c = 0; c<ns;c++)
	{
        z_pos = z+c-neighborhoodsize;        
		for (b = 0; b<ns;b++)
		{
            y_pos = y+b-neighborhoodsize;			
			for (a = 0; a<ns;a++)
			{		
				x_pos = x+a-neighborhoodsize;								
				
                is_outside = false;		
                if ((x_pos < 0) || (x_pos > sx-1)) is_outside = true;
                if ((y_pos < 0) || (y_pos > sy-1)) is_outside = true;
                if ((z_pos < 0) || (z_pos > sz-1)) is_outside = true;
                
				if (!is_outside)
				{		
					value = Estimate[z_pos*(sxy)+(y_pos*sx)+x_pos];      
                    
                    if(rician)
                    {
                      denoised_value  = (average[count]/global_sum) - bias;                    
                      if (denoised_value > 0)
						denoised_value = sqrt(denoised_value);
					  else denoised_value = 0.0;
                      value = value + denoised_value;
                    }
                    else value = value + (average[count]/global_sum);                    
                    
					label = Label[(x_pos + y_pos*sx + z_pos*sxy)];
					Estimate[z_pos*(sxy)+(y_pos*sx)+x_pos] = value;
					Label[(x_pos + y_pos*sx + z_pos *sxy)] = label +1;		
				}
				count++;                
			}
		}
	}
}

double distance(double* ima,int x,int y,int z,int nx,int ny,int nz,int f,int sx,int sy,int sz)
{
double d,acu,distancetotal;
int i,j,k,ni1,nj1,ni2,nj2,nk1,nk2;

distancetotal=0;

for(k=-f;k<=f;k++)
{
 nk1=z+k;
 nk2=nz+k;  
 if(nk1<0) nk1=-nk1;
 if(nk2<0) nk2=-nk2;
 if(nk1>=sz) nk1=2*sz-nk1-1;    
 if(nk2>=sz) nk2=2*sz-nk2-1;

 for(j=-f;j<=f;j++)
 {
  nj1=y+j;
  nj2=ny+j;    
  if(nj1<0) nj1=-nj1;    
  if(nj2<0) nj2=-nj2;
  if(nj1>=sy) nj1=2*sy-nj1-1;
  if(nj2>=sy) nj2=2*sy-nj2-1;

  for(i=-f;i<=f;i++)
  {
    ni1=x+i;
    ni2=nx+i;    
    if(ni1<0) ni1=-ni1;
    if(ni2<0) ni2=-ni2;    
	if(ni1>=sx) ni1=2*sx-ni1-1;
    if(ni2>=sx) ni2=2*sx-ni2-1;
                
    distancetotal = distancetotal + ((ima[nk1*(sx*sy)+(nj1*sx)+ni1]-ima[nk2*(sx*sy)+(nj2*sx)+ni2])*(ima[nk1*(sx*sy)+(nj1*sx)+ni1]-ima[nk2*(sx*sy)+(nj2*sx)+ni2]));   
  }
 }
}

acu=(2*f+1)*(2*f+1)*(2*f+1);
d=distancetotal/acu;

return d;

}

unsigned __stdcall ThreadFunc( void* pArguments )
{
    double bias,*Estimate,*Label,*ima,*means,*variances,*average,sigma,epsilon,mu1,var1,totalweight,wmax,t1,t2,d,w,h,hh;
    int rows,cols,slices,ini,fin,v,f,init,i,j,k,rc,ii,jj,kk,ni,nj,nk,Ndims;
    
    myargument arg;
    arg=*(myargument *) pArguments;

    rows=arg.rows;    
    cols=arg.cols;
    slices=arg.slices;
    ini=arg.ini;    
    fin=arg.fin;
    ima=arg.in_image;    
    means=arg.means_image;  
    variances=arg.var_image;     
    Estimate=arg.estimate;
    Label=arg.label;    
    v=arg.radioB;
    f=arg.radioS;
    sigma=arg.sigma;
               
    h=sigma;
    hh=h*h;
    bias=2*sigma*sigma;
    
//filter
epsilon = 0.00001;
mu1 = 0.95;
var1 = 0.5;
init = 0;
rc=rows*cols;

Ndims = (2*f+1)*(2*f+1)*(2*f+1);

average=(double*)malloc(Ndims*sizeof(double));

for(k=ini;k<fin;k+=2)
for(j=0;j<rows;j+=2)
for(i=0;i<cols;i+=2)
{
  for (init=0 ; init < Ndims; init++) average[init]=0.0;
			
  //average=0;

  totalweight=0.0;					
		
  if ((means[k*rc+(j*cols)+i])>epsilon && (variances[k*rc+(j*cols)+i]>epsilon))
  {
				wmax=0.0;
				
				for(kk=-v;kk<=v;kk++)
				{
					for(jj=-v;jj<=v;jj++)
					{
						for(ii=-v;ii<=v;ii++)
						{
							ni=i+ii;
							nj=j+jj;
							nk=k+kk;

							if(ii==0 && jj==0 && kk==0) continue; 
				
							if(ni>=0 && nj>=0 && nk>=0 && ni<cols && nj<rows && nk<slices)
							{					
				
								if ((means[nk*(rc)+(nj*cols)+ni])> epsilon && (variances[nk*rc+(nj*cols)+ni]>epsilon))
								{
				
									t1 = (means[k*rc+(j*cols)+i])/(means[nk*rc+(nj*cols)+ni]);  
									t2 = (variances[k*rc+(j*cols)+i])/(variances[nk*rc+(nj*cols)+ni]);
	
									if(t1>mu1 && t1<(1/mu1) && t2>var1 && t2<(1/var1))
									{                 
										
										d=distance(ima,i,j,k,ni,nj,nk,f,cols,rows,slices);
	
										w = exp(-d/(hh));
	
										if(w>wmax) wmax = w;
										
										Average_block(ima,ni,nj,nk,f,average,w,cols,rows,slices);
										
									
										totalweight = totalweight + w;
									}
								}
			
			
			
							}
						}
					}
							
				}
				
				if(wmax==0.0) wmax=1.0;
						
				Average_block(ima,i,j,k,f,average,wmax,cols,rows,slices);
					
				totalweight = totalweight + wmax;
					
					 
				if(totalweight != 0.0)
				Value_block(Estimate,Label,i,j,k,f,average,totalweight,cols,rows,slices,bias);
				
			}
            else 
            {           
              wmax=1.0;  
		  	  Average_block(ima,i,j,k,f,average,wmax,cols,rows,slices);	
              totalweight = totalweight + wmax;
 			  Value_block(Estimate,Label,i,j,k,f,average,totalweight,cols,rows,slices,bias);
            }
            
			//Average_block(ima,i,j,k,f,average,wmax,cols,rows,slices);		
}
     _endthreadex( 0 );
    return 0;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
/*Declarations*/
mxArray *xData;
double *ima, *fima,*average;
mxArray *Mxmeans, *Mxvariances, *MxEstimate, *MxLabel;
double *means, *variances, *Estimate, *Label;
mxArray *pv;
double h,w,totalweight,wmax,d,mean,var,t1,t2,hh,epsilon,mu1,var1,label,estimate;
int Ndims,i,j,k,ii,jj,kk,ni,nj,nk,v,f,ndim,indice,init,Nthreads,ini,fin,r;
const int  *dims;

myargument *ThreadArgs;  
HANDLE *ThreadList; // Handles to the worker threads  

/*Copy input pointer x*/
xData = prhs[0];

/*Get matrix x*/
ima = mxGetPr(xData);

ndim = mxGetNumberOfDimensions(prhs[0]);
dims= mxGetDimensions(prhs[0]);

/*Copy input parameters*/
pv = prhs[1];
/*Get the Integer*/
v = (int)(mxGetScalar(pv));

pv = prhs[2];
f = (int)(mxGetScalar(pv));

pv = prhs[3];
h = (double)(mxGetScalar(pv));

pv = prhs[4];
r = (int)(mxGetScalar(pv));
if(r>0) rician=true;

Ndims = pow((2*f+1),ndim);

/*Allocate memory and assign output pointer*/

plhs[0] = mxCreateNumericArray(ndim,dims,mxDOUBLE_CLASS, mxREAL);
Mxmeans = mxCreateNumericArray(ndim,dims,mxDOUBLE_CLASS, mxREAL); 
Mxvariances = mxCreateNumericArray(ndim,dims,mxDOUBLE_CLASS, mxREAL); 
MxEstimate = mxCreateNumericArray(ndim,dims,mxDOUBLE_CLASS, mxREAL); 
MxLabel = mxCreateNumericArray(ndim,dims,mxDOUBLE_CLASS, mxREAL);

average=(double*)malloc(Ndims*sizeof(double));

/*Get a pointer to the data space in our newly allocated memory*/
fima = mxGetPr(plhs[0]);
means = mxGetPr(Mxmeans);
variances = mxGetPr(Mxvariances);
Estimate = mxGetPr(MxEstimate);
Label = mxGetPr(MxLabel);


for (i = 0; i < dims[2] *dims[1] * dims[0];i++)
{
	Estimate[i] = 0.0;
	Label[i] = 0.0;
	fima[i] = 0.0;
}


for(k=0;k<dims[2];k++)
{
	for(i=0;i<dims[1];i++)
	{
		for(j=0;j<dims[0];j++)
		{
			mean=0;
			indice=0;
			for(ii=-1;ii<=1;ii++)
			{
				for(jj=-1;jj<=1;jj++)
				{
					for(kk=-1;kk<=1;kk++)
					{
						ni=i+ii;
							nj=j+jj;		   		  
						nk=k+kk;
						
						if(ni<0) ni=-ni;
						if(nj<0) nj=-nj;
						if(nk<0) nk=-nk;
						if(ni>=dims[1]) ni=2*dims[1]-ni-1;
						if(nj>=dims[0]) nj=2*dims[0]-nj-1;
						if(nk>=dims[2]) nk=2*dims[2]-nk-1;
						
								
						mean = mean + ima[nk*(dims[0]*dims[1])+(ni*dims[0])+nj];
						indice=indice+1;                
					
					}
				}
			}
			mean=mean/indice;
			means[k*(dims[0]*dims[1])+(i*dims[0])+j]=mean;
		}
	}
}

for(k=0;k<dims[2];k++)
{
	for(i=0;i<dims[1];i++)
	{
		for(j=0;j<dims[0];j++)
		{
			var=0;
			indice=0;
			for(ii=-1;ii<=1;ii++)
			{
				for(jj=-1;jj<=1;jj++)
				{
					for(kk=-1;kk<=1;kk++)
					{
						ni=i+ii;
						nj=j+jj;		   		  
						nk=k+kk;		   		  
							if(ni>=0 && nj>=0 && nk>0 && ni<dims[1] && nj<dims[0] && nk<dims[2])
							{
							var = var + (ima[nk*(dims[0]*dims[1])+(ni*dims[0])+nj]-means[k*(dims[0]*dims[1])+(i*dims[0])+j])*(ima[nk*(dims[0]*dims[1])+(ni*dims[0])+nj]-means[k*(dims[0]*dims[1])+(i*dims[0])+j]);
							indice=indice+1;
							}
					}
				}
			}
			var=var/(indice-1);
			variances[k*(dims[0]*dims[1])+(i*dims[0])+j]=var;
		}
	}
}

Nthreads=dims[2]<8?dims[2]:8;

// Reserve room for handles of threads in ThreadList
ThreadList = (HANDLE*)malloc(Nthreads* sizeof( HANDLE ));
ThreadArgs = (myargument*) malloc( Nthreads*sizeof(myargument));

for (i=0; i<Nthreads; i++)
{         
	// Make Thread Structure   
    ini=(i*dims[2])/Nthreads;
    fin=((i+1)*dims[2])/Nthreads;            
   	ThreadArgs[i].cols=dims[0];
    ThreadArgs[i].rows=dims[1];
   	ThreadArgs[i].slices=dims[2];
    ThreadArgs[i].in_image=ima;	
  	ThreadArgs[i].var_image=variances;
    ThreadArgs[i].means_image=means;  
    ThreadArgs[i].estimate=Estimate;
    ThreadArgs[i].label=Label;    
    ThreadArgs[i].ini=ini;
    ThreadArgs[i].fin=fin;
    ThreadArgs[i].radioB=v;
    ThreadArgs[i].radioS=f;
    ThreadArgs[i].sigma=h;    
    	
    ThreadList[i] = (HANDLE)_beginthreadex( NULL, 0, &ThreadFunc, &ThreadArgs[i] , 0, NULL );
        
}
    
for (i=0; i<Nthreads; i++) { WaitForSingleObject(ThreadList[i], INFINITE); }
for (i=0; i<Nthreads; i++) { CloseHandle( ThreadList[i] ); }
    
free(ThreadArgs); 
free(ThreadList);


label = 0.0;
estimate = 0.0;
/* Aggregation of the estimators (i.e. means computation) */
for (k = 0; k < dims[2]; k++ )
{
	for (i = 0; i < dims[1]; i++ )
	{
		for (j = 0; j < dims[0]; j++ )
		{
			label = Label[k*(dims[0]*dims[1])+(i*dims[0])+j];
			if (label == 0.0)
			{
				fima[k*(dims[0]*dims[1])+(i*dims[1])+j] = ima[k*(dims[0]*dims[1])+(i*dims[0])+j];
	
			}
			else
			{
				estimate = Estimate[k*(dims[0]*dims[1])+(i*dims[0])+j];
				estimate = (estimate/label);
				fima[k*(dims[0]*dims[1])+(i*dims[0])+j]=estimate;
	
			}
		}
	}
}
 



return;

}

