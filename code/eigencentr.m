function [ X, I ] = eigencentr( adjac )
%eigencentr: eigencentrality of nodes in network

 [V,D] = eig(adjac);
 [max_eig,ind]= max(diag(D));
 x = V(:,ind);
 
 [X,I] = sort(x,'descend');
    
end

