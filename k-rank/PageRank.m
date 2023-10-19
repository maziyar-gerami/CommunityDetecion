function p = PageRank( P, d )

[m,~]=size(P);
c=sum(P);
L_c=P./ repmat (c,m,1);
k=0; 
while 1 
    k=k+1; 
    for i=1:m 
        p(i)=(1-d)+d*(L_c(i,:)*c'); 
    end
    c=p;
    if sum(sum(p))==m || k>256
        break; 
    end
end


end

