function c_cor = HARD_DECODER_GROUPE_6(c, H, MAX_ITER)
%% HARD_DECODER_GROUPE_6
%   c [N, 1] : le mot � coder
%   H [M, N] : matrice g�n�ratrice
%   MAX_ITER : limite sur les it�rations

%% 1 - D�finition des param�tres
    [M, N] = size(H);

    
%% 2 - Codage
    c_cor = H*c;
    
end