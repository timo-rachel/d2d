function [a_a] = adimat_a_prepad_10(a,b,a_z)
  dim = adimat_first_nonsingleton(a);
  sz = size(a);
  psz = sz;
  psz(dim) = b - sz(dim);
  sel1 = false(psz);
  sel2 = true(sz);
  sel = cat(dim, sel1, sel2);
  a_a = a_z(sel);
  a_a = reshape(a_a, sz);
