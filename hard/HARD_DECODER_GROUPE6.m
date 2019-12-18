close all;
clear variables;

%% Initialisation


H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ]; 

c = [1 1 0 1 0 1 0 1 ];
MAX_ITER = 20;

correct = HARD_DECODER_GROUPE_6(c, H, MAX_ITER);
function c_cor = HARD_DECODER_GROUPE_6(c, H, MAX_ITER)
    dim = size(H);
    nbCNodes=dim(1);
    nbVNodes=dim(2);
    for i=1:nbVNodes
        v_nodesTEST(i)= v_nodeV(c(i),sum(H(i)));
    end

    for i=1:nbCNodes
        c_nodesTEST(i)=c_nodeC();
    end


    pariteRespectee=1;

    nbBoucles = 0; 

    %% Main loop
    while pariteRespectee > 0 && nbBoucles < MAX_ITER      % Si il y a eu une correction dans la dernière boucle, on continue

        pariteRespectee = 0;        %Remise à zéro de la variable
        nbBoucles = nbBoucles + 1;  

       %% Envoi des bits aux c_nodes

       for ct = 1:nbCNodes
            for v= 1:nbVNodes
                if H(ct,v)
                    if v_nodesTEST(v).Bit
                        c_nodesTEST(ct) = flipC(c_nodesTEST(ct));
                    end
                end
            end
       end


       %% Réponse des c_nodes
       for ct = 1:nbCNodes
            if c_nodesTEST(ct).Parity                        % test de parité échoué
                pariteRespectee = pariteRespectee + 1;  % on execute la boucle une fois de plus la prochaine fois
                for v = 1:nbVNodes
                    if H(ct,v)
                        v_nodesTEST(v) = voteV(v_nodesTEST(v), ~v_nodesTEST(v).Bit);
                    end
                end
            else
                for v = 1:nbVNodes
                    if H(ct,v)
                        v_nodesTEST(v) = voteV(v_nodesTEST(v), v_nodesTEST(v).Bit);
                    end
                end
            end
       end

       %% Mise à jour des v_nodes et remise à zéro des c_nodes
       for v = 1:nbVNodes
          v_nodesTEST(v) =updateV(v_nodesTEST(v)); 
       end

       for ct = 1:nbCNodes
           c_nodesTEST(ct) = razC(c_nodesTEST(ct));
       end
    end


    %% Affichage final

    decodage = [];

    for i=1:nbVNodes
        decodage = [decodage v_nodesTEST(i).Bit];
    end

    disp(['Nb boucles = ' num2str(nbBoucles)])
    disp(['Message envoyé : ' num2str(c)])
    disp(['Message décodé : ' num2str(decodage)])
    c_cor = decodage;
end
function obj=v_nodeV(bit,nbVNodes)
    obj.Bit = bit;
    obj.Votes = zeros(1,nbVNodes);
    obj.Index = 1;
end

function r = flipV(obj)
    obj.Bit = mod(obj.Bit + 1,2);

    r = obj;
end

function r = voteV(obj,vote)
    obj.Votes(obj.Index) = vote;
    obj.Index = obj.Index + 1;
    r = obj;
end

function r = updateV(obj)
    if mean(obj.Votes) < 0.5
        obj.Bit = 0;
    elseif mean(obj.Votes) == 0.5
        obj.Bit = obj.Bit;
    else
        obj.Bit = 1;
    end
    obj.Index = 1;
    r = obj;
end

function obj = c_nodeC()
    obj.Parity = 0;
end

function r = flipC(obj)
    obj.Parity = mod(obj.Parity + 1,2);
    r = obj;
end

function r = razC(obj)
    obj.Parity = 0;
    r=obj;
end
