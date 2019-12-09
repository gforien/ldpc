function c_cor = HARD_DECODER_GROUPE_6(c, H, MAX_ITER)
%% HARD_DECODER_GROUPE_6
%   c [N, 1] : le mot à coder
%   H [M, N] : matrice génératrice
%   MAX_ITER : limite sur les itérations

%% 1 - Définition des paramètres
    [M, N] = size(H);

    
%% 2 - Codage
    c_cor = H*c;
    
end