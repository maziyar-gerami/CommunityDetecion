j=1;
for i=100:100:1000
    acc(j) = Proposed(i);
    j=j+1
end
bar(acc)
