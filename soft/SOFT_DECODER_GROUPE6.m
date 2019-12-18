close all;
clear variables;

%% Initialisation
%H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ];
%p = [0.9 0.1 0.1 0.4 0.1 0.9 0.6 0.9];
%c = [1 0 0 1 0 1 0 1];
%MAX_ITER = 20;

function c_cor = SOFT_DECODER_GROUPE_6(c, H, p, MAX_ITER)
    
    dim = size(H);
    nbCNodes=dim(1); %M
    nbVNodes=dim(2); %N

    for i=1:nbVNodes   
        v_nodesTEST(i) = v_nodeV(p(i), nbCNodes);
    end

    for i=1:nbCNodes
        c_nodesTEST(i)=c_nodeC(nbVNodes);
    end


    pariteEchouee=1;

    nbBoucles = 0; 

    %% Main loop
    while pariteEchouee > 0 && nbBoucles < MAX_ITER      %Tant que la parité n'est pas bonne, avec une condition d'arrêt pour éviter une boucle infinie


        nbBoucles = nbBoucles + 1;  

       %% Envoi des probabilités aux c_nodes

       for c = 1:nbCNodes
            for v= 1:nbVNodes
                if H(c,v)
                    c_nodesTEST(c) = voteC(c_nodesTEST(c), v_nodesTEST(v).Reponses(c),v);
                end
            end
            c_nodesTEST(c) = updateC(c_nodesTEST(c));
       end


       %% Réponse des c_nodes
        for v = 1:nbVNodes
            for c = 1:nbCNodes
                if H(c,v)
                    v_nodesTEST(v) = voteV(v_nodesTEST(v), c_nodesTEST(c).Reponses(v),c);
                end
            end
            v_nodesTEST(v) = updateV(v_nodesTEST(v));
        end


        %% Test de la parité

        decodage = [];
        for i=1:nbVNodes
          decodage = [decodage v_nodesTEST(i).Bit];
        end

        pariteEchouee = sum(mod(decodage * H' , 2));

    end


    %% Affichage final

    decodage = [];

    for i=1:nbVNodes
        decodage = [decodage v_nodesTEST(i).Bit];
    end

    disp(['Nb boucles = ' num2str(nbBoucles)])
    disp(['Message envoyé : ' num2str(c)])
    disp(['Message décodé : ' num2str(decodage)])

    if ~pariteEchouee
        disp('Message valide reconstruit !')
        if decodage == c
            disp('Bon message reçu !')
        else
            disp('Message erroné reçu')
        end
    else
        disp('Reconstruction échouée')
    end
    c_cor = decodage;
end
function obj=v_nodeV(p,nbCNodes)
    obj.P = p; 

    if p > 0.5          %initialisation du bit
        obj.Bit = 1;
    else
        obj.Bit = 0;
    end

    obj.Votes = nan(1,nbCNodes);                %inititialisation du tableau à NaN pour ne prendre en compte que les c_nodes connectées
    obj.Reponses = obj.P * ones(1,nbCNodes);    %initialisation des probabilités transmises à Pi pour la première itération
end

function r = voteV(obj,value,index)
            obj.Votes(index) = value;
            r = obj;
end
        
function r = updateV(obj)
    for i=1:length(obj.Reponses)

        q1 = obj.P;                                 %calcul correspondant à q1
        q0 = (1 - obj.P);                           %calcul correspondant à q0

        for j=setdiff(1:length(obj.Votes),i)        %toutes les cases sauf i
            if ~isnan(obj.Votes(j))                 %si la node n'est pas connectée elle n'a rien envoyé, la valeur est donc restée NaN
                q1 = q1 * obj.Votes(j);
                q0 = q0 * (1 - obj.Votes(j));
            end
        end

        K = 1 / ( q1 + q0);             %calcul du coefficient de normalisation des probabilités

        obj.Reponses(i) = K * q1;       %inscription de la réponse à renvoyer dans le tableau
    end

    Q1 = obj.P;     %calcul de Q1
    Q0 = 1 - Q1;    %calcul de Q0

    for i=1:length(obj.Votes)
        if ~isnan(obj.Votes(i))         %idem que précedemment
            Q1 = Q1 * obj.Votes(i);
            Q0 = Q0 * ( 1 - obj.Votes(i));
        end
    end

    if Q1>Q0            %mise à jour du bit en foncion des probabilités calculées
        obj.Bit = 1;
    else
        obj.Bit = 0;
    end

    r = obj;
end

function obj = c_nodeC(nbVNodes)
    obj.Votes = nan(1,nbVNodes);        %initialisation des Votes à NaN pour ne prendre en compte que les v_nodes connectées
    obj.Reponses = zeros(1,nbVNodes);
end

function r = voteC(obj,value,index)
    obj.Votes(index) = value;
    r = obj;
end

function r = updateC(obj)
    for i=1:length(obj.Reponses)

        prod = 0.5;

        for j=setdiff(1:length(obj.Votes),i)      %toutes les cases sauf i

            if ~isnan(obj.Votes(j))
                prod = prod * (1 - 2 * obj.Votes(j));
            end

        end

        obj.Reponses(i) = 1 - ( 0.5 + prod );       %à renvoyer: rij(1)
    end
    r = obj;
end