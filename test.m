% LDPC - script de test
% Groupe 6
% Julien Galleron, Chlo� Gouaty, Gabriel Forien
% INSA Lyon - 4TC

%% 1 - D�finition des param�tres

c = [1 ; 0 ; 1 ; 1 ];
H = [ true false false true ; false true false true  ];

c_cor = HARD_DECODER_GROUPE_6(c, H, 100)
c_cor = HARD_DECODER_GROUPE_6(c, H, p 100)