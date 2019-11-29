function c_cor = SOFT_DECODER_GROUPE_6(c, H, p, MAX_ITER)
%% SOFT_DECODER_GROUPE_6
%   c [N, 1] : le mot à coder
%   H [M, N] : matrice génératrice
%   p [N, 1] : vecteur probabilité que c(i) == 1
%   MAX_ITER : limite sur les itérations

%% 1 - Définition des paramètres
    [M, N] = size(H);

    
%% 2 - Codage
    c_cor = H*c;
    
end