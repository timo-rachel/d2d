% Generated by ADiMat 0.6.0-4867
% © 2001-2008 Andre Vehreschild <vehreschild@sc.rwth-aachen.de>
% © 2009-2013 Johannes Willkomm <johannes.willkomm@sc.tu-darmstadt.de>
% RWTH Aachen University, 52056 Aachen, Germany
% TU Darmstadt, 64289 Darmstadt, Germany
% Visit us on the web at http://www.adimat.de/
% Report bugs to adimat-users@lists.sc.informatik.tu-darmstadt.de
%
%                             DISCLAIMER
% 
% ADiMat was prepared as part of an employment at the Institute for Scientific Computing,
% RWTH Aachen University, Germany and at the Institute for Scientific Computing,
% TU Darmstadt, Germany and is provided AS IS. 
% NEITHER THE AUTHOR(S), THE GOVERNMENT OF THE FEDERAL REPUBLIC OF GERMANY
% NOR ANY AGENCY THEREOF, NOR THE RWTH AACHEN UNIVERSITY, NOT THE TU DARMSTADT,
% INCLUDING ANY OF THEIR EMPLOYEES OR OFFICERS, MAKES ANY WARRANTY, EXPRESS OR IMPLIED,
% OR ASSUMES ANY LEGAL LIABILITY OR RESPONSIBILITY FOR THE ACCURACY, COMPLETENESS,
% OR USEFULNESS OF ANY INFORMATION OR PROCESS DISCLOSED, OR REPRESENTS THAT ITS USE
% WOULD NOT INFRINGE PRIVATELY OWNED RIGHTS.
%
% Flags: BACKWARDMODE,  NOOPEROPTIM,
%   NOLOCALCSE,  NOGLOBALCSE,  NOPRESCALARFOLDING,
%   NOPOSTSCALARFOLDING,  NOCONSTFOLDMULT0,  FUNCMODE,
%   NOTMPCLEAR,  DUMP_XML,  PARSE_ONLY,
%   UNBOUND_ERROR
%
% Parameters:
%  - dependents=U
%  - independents=A
%  - inputEncoding=ISO-8859-1
%  - output-mode: plain
%  - output-file: ad_out/a_adimat_chol.m
%  - output-file-prefix: 
%  - output-directory: ad_out
% Generated by ADiMat 0.6.0-4867
% © 2001-2008 Andre Vehreschild <vehreschild@sc.rwth-aachen.de>
% © 2009-2013 Johannes Willkomm <johannes.willkomm@sc.tu-darmstadt.de>
% RWTH Aachen University, 52056 Aachen, Germany
% TU Darmstadt, 64289 Darmstadt, Germany
% Visit us on the web at http://www.adimat.de/
% Report bugs to adimat-users@lists.sc.informatik.tu-darmstadt.de
%
%                             DISCLAIMER
% 
% ADiMat was prepared as part of an employment at the Institute for Scientific Computing,
% RWTH Aachen University, Germany and at the Institute for Scientific Computing,
% TU Darmstadt, Germany and is provided AS IS. 
% NEITHER THE AUTHOR(S), THE GOVERNMENT OF THE FEDERAL REPUBLIC OF GERMANY
% NOR ANY AGENCY THEREOF, NOR THE RWTH AACHEN UNIVERSITY, NOT THE TU DARMSTADT,
% INCLUDING ANY OF THEIR EMPLOYEES OR OFFICERS, MAKES ANY WARRANTY, EXPRESS OR IMPLIED,
% OR ASSUMES ANY LEGAL LIABILITY OR RESPONSIBILITY FOR THE ACCURACY, COMPLETENESS,
% OR USEFULNESS OF ANY INFORMATION OR PROCESS DISCLOSED, OR REPRESENTS THAT ITS USE
% WOULD NOT INFRINGE PRIVATELY OWNED RIGHTS.
%
% Flags: BACKWARDMODE,  NOOPEROPTIM,
%   NOLOCALCSE,  NOGLOBALCSE,  NOPRESCALARFOLDING,
%   NOPOSTSCALARFOLDING,  NOCONSTFOLDMULT0,  FUNCMODE,
%   NOTMPCLEAR,  DUMP_XML,  PARSE_ONLY,
%   UNBOUND_ERROR
%
% Parameters:
%  - dependents=U
%  - independents=A
%  - inputEncoding=ISO-8859-1
%  - output-mode: plain
%  - output-file: ad_out/a_adimat_chol.m
%  - output-file-prefix: 
%  - output-directory: ad_out
%
% Functions in this file: a_adimat_chol, rec_adimat_chol,
%  ret_adimat_chol
%

function [a_A nr_U] = a_adimat_chol(A, a_U)
% CHOLESKY_FACTOR computes the Cholesky factor of a matrix.
%
% Given a symmetric positive definite matrix A, this function computes the
% upper triangular matrix U such that U'*U = A. Since we are trying to
% mimic a Fortran program, this Matlab implementation works on a scalar
% level, avoiding all vector-like operations.
%
% From an algorithmic point of view, this function produces the output U
% from using the upper triangular part of the input A. The lower tringular
% part of A is never used. That is, using automatic or numerical
% differentiation, the derivatives wrt all entries of the lower triangular
% part will be zero. 
% Author: D. Fabregat Traver, RWTH Aachen University
% Date: 03/08/12
% History: 
% 1) Comment added by Martin Buecker, 03/19/12
% 2) Re-vectorized, second parameter added by Johannes Willkomm, 06/17/12
   tmplia1 = 0;
   tmpda2 = 0;
   tmpda1 = 0;
   tmpca1 = 0;
   j = 0;
   k = 0;
   n = size(A, 1);
   tmpfra1_2 = n;
   for i=1 : tmpfra1_2
      adimat_push1(tmplia1);
      tmplia1 = sqrt(A(i, i));
      adimat_push_index2(A, i, i);
      A(i, i) = tmplia1;
      adimat_push1(tmpda2);
      tmpda2 = i + 1;
      adimat_push1(tmpda1);
      tmpda1 = i + 1;
      adimat_push1(tmplia1);
      tmplia1 = A(i, tmpda2 : n) ./ A(i, i);
      adimat_push_index2(A, i, tmpda1 : n);
      A(i, tmpda1 : n) = tmplia1;
      tmpfra2_1 = i + 1;
      tmpfra2_2 = n;
      adimat_push1(j);
      for j=tmpfra2_1 : tmpfra2_2
         adimat_push1(k);
         k = i+1 : j;
         adimat_push1(tmpca1);
         tmpca1 = A(i, k) .* A(i, j);
         adimat_push1(tmplia1);
         tmplia1 = A(k, j).' - tmpca1;
         adimat_push_index2(A, k, j);
         A(k, j) = tmplia1;
      end
      adimat_push(tmpfra2_1, tmpfra2_2);
   end
   adimat_push1(tmpfra1_2);
   U = triu(A);
   nr_U = U;
   [a_tmplia1 a_tmpca1 a_A] = a_zeros(tmplia1, tmpca1, A);
   if nargin < 2
      a_U = a_zeros1(U);
   end
   a_A = adimat_adjsum(a_A, call(@triu, a_U));
   tmpfra1_2 = adimat_pop1;
   for i=fliplr(1 : tmpfra1_2)
      [tmpfra2_2 tmpfra2_1] = adimat_pop;
      for j=fliplr(tmpfra2_1 : tmpfra2_2)
         A = adimat_pop_index2(A, k, j);
         a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(k, j))));
         a_A = a_zeros_index2(a_A, A, k, j);
         tmplia1 = adimat_pop1;
         a_A(k, j) = adimat_adjsum(a_A(k, j), adimat_adjred(A(k, j).', a_tmplia1).');
         a_tmpca1 = adimat_adjsum(a_tmpca1, adimat_adjred(tmpca1, -a_tmplia1));
         a_tmplia1 = a_zeros1(tmplia1);
         tmpca1 = adimat_pop1;
         a_A(i, k) = adimat_adjsum(a_A(i, k), adimat_adjred(A(i, k), a_tmpca1 .* A(i, j)));
         a_A(i, j) = adimat_adjsum(a_A(i, j), adimat_adjred(A(i, j), A(i, k) .* a_tmpca1));
         a_tmpca1 = a_zeros1(tmpca1);
         k = adimat_pop1;
      end
      j = adimat_pop1;
      A = adimat_pop_index2(A, i, tmpda1 : n);
      a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(i, tmpda1 : n))));
      a_A = a_zeros_index2(a_A, A, i, tmpda1 : n);
      tmplia1 = adimat_pop1;
      a_A(i, tmpda2 : n) = adimat_adjsum(a_A(i, tmpda2 : n), adimat_adjred(A(i, tmpda2 : n), a_tmplia1 ./ A(i, i)));
      a_A(i, i) = adimat_adjsum(a_A(i, i), adimat_adjred(A(i, i), -((A(i, tmpda2 : n)./A(i, i) .* a_tmplia1) ./ A(i, i))));
      a_tmplia1 = a_zeros1(tmplia1);
      [tmpda1 tmpda2] = adimat_pop;
      A = adimat_pop_index2(A, i, i);
      a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(i, i))));
      a_A = a_zeros_index2(a_A, A, i, i);
      tmplia1 = adimat_pop1;
      a_A(i, i) = adimat_adjsum(a_A(i, i), 0.5 .* a_tmplia1./sqrt(A(i, i)));
      a_tmplia1 = a_zeros1(tmplia1);
   end
end

function U = rec_adimat_chol(A)
   tmplia1 = 0;
   tmpda2 = 0;
   tmpda1 = 0;
   tmpca1 = 0;
   j = 0;
   k = 0;
   n = size(A, 1);
   tmpfra1_2 = n;
   for i=1 : tmpfra1_2
      adimat_push1(tmplia1);
      tmplia1 = sqrt(A(i, i));
      adimat_push_index2(A, i, i);
      A(i, i) = tmplia1;
      adimat_push1(tmpda2);
      tmpda2 = i + 1;
      adimat_push1(tmpda1);
      tmpda1 = i + 1;
      adimat_push1(tmplia1);
      tmplia1 = A(i, tmpda2 : n) ./ A(i, i);
      adimat_push_index2(A, i, tmpda1 : n);
      A(i, tmpda1 : n) = tmplia1;
      tmpfra2_1 = i + 1;
      tmpfra2_2 = n;
      adimat_push1(j);
      for j=tmpfra2_1 : tmpfra2_2
         adimat_push1(k);
         k = i+1 : j;
         adimat_push1(tmpca1);
         tmpca1 = A(i, k) .* A(i, j);
         adimat_push1(tmplia1);
         tmplia1 = A(k, j).' - tmpca1;
         adimat_push_index2(A, k, j);
         A(k, j) = tmplia1;
      end
      adimat_push(tmpfra2_1, tmpfra2_2);
   end
   adimat_push1(tmpfra1_2);
   U = triu(A);
   adimat_push(j, k, n, tmplia1, tmpda2, tmpda1, tmpca1, U, A);
end

function a_A = ret_adimat_chol(a_U)
   [A U tmpca1 tmpda1 tmpda2 tmplia1 n k j] = adimat_pop;
   [a_tmplia1 a_tmpca1 a_A] = a_zeros(tmplia1, tmpca1, A);
   if nargin < 1
      a_U = a_zeros1(U);
   end
   a_A = adimat_adjsum(a_A, call(@triu, a_U));
   tmpfra1_2 = adimat_pop1;
   for i=fliplr(1 : tmpfra1_2)
      [tmpfra2_2 tmpfra2_1] = adimat_pop;
      for j=fliplr(tmpfra2_1 : tmpfra2_2)
         A = adimat_pop_index2(A, k, j);
         a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(k, j))));
         a_A = a_zeros_index2(a_A, A, k, j);
         tmplia1 = adimat_pop1;
         a_A(k, j) = adimat_adjsum(a_A(k, j), adimat_adjred(A(k, j).', a_tmplia1).');
         a_tmpca1 = adimat_adjsum(a_tmpca1, adimat_adjred(tmpca1, -a_tmplia1));
         a_tmplia1 = a_zeros1(tmplia1);
         tmpca1 = adimat_pop1;
         a_A(i, k) = adimat_adjsum(a_A(i, k), adimat_adjred(A(i, k), a_tmpca1 .* A(i, j)));
         a_A(i, j) = adimat_adjsum(a_A(i, j), adimat_adjred(A(i, j), A(i, k) .* a_tmpca1));
         a_tmpca1 = a_zeros1(tmpca1);
         k = adimat_pop1;
      end
      j = adimat_pop1;
      A = adimat_pop_index2(A, i, tmpda1 : n);
      a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(i, tmpda1 : n))));
      a_A = a_zeros_index2(a_A, A, i, tmpda1 : n);
      tmplia1 = adimat_pop1;
      a_A(i, tmpda2 : n) = adimat_adjsum(a_A(i, tmpda2 : n), adimat_adjred(A(i, tmpda2 : n), a_tmplia1 ./ A(i, i)));
      a_A(i, i) = adimat_adjsum(a_A(i, i), adimat_adjred(A(i, i), -((A(i, tmpda2 : n)./A(i, i) .* a_tmplia1) ./ A(i, i))));
      a_tmplia1 = a_zeros1(tmplia1);
      [tmpda1 tmpda2] = adimat_pop;
      A = adimat_pop_index2(A, i, i);
      a_tmplia1 = adimat_adjsum(a_tmplia1, adimat_adjred(tmplia1, adimat_adjreshape(tmplia1, a_A(i, i))));
      a_A = a_zeros_index2(a_A, A, i, i);
      tmplia1 = adimat_pop1;
      a_A(i, i) = adimat_adjsum(a_A(i, i), 0.5 .* a_tmplia1./sqrt(A(i, i)));
      a_tmplia1 = a_zeros1(tmplia1);
   end
end
% $Id: adimat_chol.m 3739 2013-06-12 16:49:42Z willkomm $
