#include "ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42.h"
#include <cvodes/cvodes.h>
#include <cvodes/cvodes_dense.h>
#include <cvodes/cvodes_sparse.h>
#include <nvector/nvector_serial.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sundials/sundials_sparse.h>
#include <cvodes/cvodes_klu.h>
#include <udata.h>
#include <math.h>
#include <mex.h>
#include <arInputFunctionsC.h>





 void fy_ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42(double t, int nt, int it, int ntlink, int itlink, int ny, int nx, int nz, int iruns, double *y, double *p, double *u, double *x, double *z){
  y[ny*nt*iruns+it+nt*0] = p[6]-((exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))-1.0)*p[3])/(pow(p[0],p[7])+1.0);

  return;
}


 void fystd_ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42(double t, int nt, int it, int ntlink, int itlink, double *ystd, double *y, double *p, double *u, double *x, double *z){
  ystd[it+nt*0] = p[10];

  return;
}


 void fsy_ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42(double t, int nt, int it, int ntlink, int itlink, double *sy, double *p, double *u, double *x, double *z, double *su, double *sx, double *sz){
  sy[it+nt*0] = 1.0/pow(pow(p[0],p[7])+1.0,2.0)*(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))-1.0)*pow(p[0],p[7]-1.0)*p[3]*p[7];
  sy[it+nt*1] = (exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*1.0/pow(pow(p[1],p[8])+1.0,2.0)*pow(p[1],p[8]-1.0)*p[3]*p[4]*p[8]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[0],p[7])+1.0);
  sy[it+nt*2] = -(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*p[3]*p[4]*((pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*1.0/pow(pow(p[2],p[9])+1.0,2.0)*pow(p[2],p[9]-1.0)*p[5]*p[9])/(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)-(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*1.0/pow(pow(p[2],p[9])+1.0,2.0)*pow(p[2],p[9]-1.0)*p[5]*p[9])/(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))))/((pow(p[0],p[7])+1.0)*(pow(p[1],p[8])+1.0));
  sy[it+nt*3] = -(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))-1.0)/(pow(p[0],p[7])+1.0);
  sy[it+nt*4] = -(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*p[3]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/((pow(p[0],p[7])+1.0)*(pow(p[1],p[8])+1.0));
  sy[it+nt*5] = (exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*((pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*(1.0/(pow(p[2],p[9])+1.0)-1.0))/(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)-(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*(1.0/(pow(p[2],p[9])+1.0)-1.0))/(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])))*p[3]*p[4])/((pow(p[0],p[7])+1.0)*(pow(p[1],p[8])+1.0));
  sy[it+nt*6] = 1.0;
  sy[it+nt*7] = log(p[0])*1.0/pow(pow(p[0],p[7])+1.0,2.0)*(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))-1.0)*pow(p[0],p[7])*p[3];
  sy[it+nt*8] = (log(p[1])*exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*1.0/pow(pow(p[1],p[8])+1.0,2.0)*pow(p[1],p[8])*p[3]*p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[0],p[7])+1.0);
  sy[it+nt*9] = -(exp((p[4]*(log(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)/log(1.0E+1)-log(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5]))/log(1.0E+1)))/(pow(p[1],p[8])+1.0))*((pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*log(p[2])*1.0/pow(pow(p[2],p[9])+1.0,2.0)*pow(p[2],p[9])*p[5])/(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])+1.0)-(pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])*log(p[2])*1.0/pow(pow(p[2],p[9])+1.0,2.0)*pow(p[2],p[9])*p[5])/(pow(1.0E+1,t*(5.0/3.0))+pow(1.0E+1,-(1.0/(pow(p[2],p[9])+1.0)-1.0)*p[5])))*p[3]*p[4])/((pow(p[0],p[7])+1.0)*(pow(p[1],p[8])+1.0));
  sy[it+nt*10] = 0.0;

  return;
}


 void fsystd_ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42(double t, int nt, int it, int ntlink, int itlink, double *systd, double *p, double *y, double *u, double *x, double *z, double *sy, double *su, double *sx, double *sz){
  systd[it+nt*0] = 0.0;
  systd[it+nt*1] = 0.0;
  systd[it+nt*2] = 0.0;
  systd[it+nt*3] = 0.0;
  systd[it+nt*4] = 0.0;
  systd[it+nt*5] = 0.0;
  systd[it+nt*6] = 0.0;
  systd[it+nt*7] = 0.0;
  systd[it+nt*8] = 0.0;
  systd[it+nt*9] = 0.0;
  systd[it+nt*10] = 1.0;

  return;
}


 void fy_scale_ELISA_Nigericin_formatted_7AFB33375DA02A1827FE1688310F1D42(double t, int nt, int it, int ntlink, int itlink, int ny, int nx, int nz, int iruns, double *y_scale, double *p, double *u, double *x, double *z, double *dfzdx){


  return;
}


