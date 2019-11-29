% LDPC - script de test
% Groupe 6
% Julien Galleron, Chloé Gouaty, Gabriel Forien
% INSA Lyon - 4TC

%% 1 - Définition des paramètres

c = [1 ; 0 ; 1 ; 1 ];
H = [ true false false true ; false true false true  ];

c_cor = HARD_DECODER_GROUPE_6(c, H, 100)
c_cor = HARD_DECODER_GROUPE_6(c, H, p 100)