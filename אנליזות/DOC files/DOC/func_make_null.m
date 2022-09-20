function A_null=func_make_null(A,N_null)

if nargin==1
    N_null=1;
end

[NumSpecies, NumSamples]=size(A);

NumSamples_null=N_null*NumSamples;

A_null=zeros(NumSpecies, NumSamples_null);

for j=1:NumSamples_null
    j_real=mod(j-1,NumSamples)+1;
    for i=1:NumSpecies
        % shuffle the abundance of the non-zero species
        if A(i,j_real)>0
            Inonzeros=find(A(i,:)>0);
            RAND=randi(length(Inonzeros));
            A_null(i,j)=A(i,Inonzeros(RAND));
        else
            A_null(i,j)=0;
        end
    end
end

% normalizes the shuffled data 
A_null=A_null./repmat(sum(A_null),NumSpecies,1);






