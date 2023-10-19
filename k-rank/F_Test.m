function centers = F_Test( sigma, P_Hat )
%F_TEST Summary of this function goes here
%   Detailed explanation goes here

summ =0;

for i=1:length(sigma)
    
    
    dist(i) = pdist2 ([sigma(i), P_Hat(i)],[0, 0])
       
       
    
    
end

av = sum(dist)/length(sigma);
centers = find (dist>av);

end

