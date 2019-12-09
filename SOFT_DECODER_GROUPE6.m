function c_cor = SOFT_DECODER_GROUPE_6(c, H, p, MAX_ITER)
%% SOFT_DECODER_GROUPE_6
%   c [N, 1] : le mot � coder
%   H [M, N] : matrice g�n�ratrice
%   p [N, 1] : vecteur probabilit� que c(i) == 1
%   MAX_ITER : limite sur les it�rations

%% 1 - D�finition des param�tres
    [M, N] = size(H);

    
%% 2 - Codage
    c_cor = H*c;
    
end