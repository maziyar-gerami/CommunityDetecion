clc;
clear;
close all;
%% Parameters and Initialization
t= cputime;
N = 1000;                  % Number of Population
d=1;
k = 4;

% Getting Raw Dataset from Input
socDataset = xlsread ('socEpinions.xlsx');
socDataset = socDataset(1:N,:);

uniquePersons = unique(socDataset(:));

%Calculating Number of Population
numberOfpopulation = length(uniquePersons);
numberOfrows = length(socDataset);

% Create an empty Adjanceny Matrix of people relations
Adjancency =zeros(numberOfpopulation,numberOfpopulation);

%% Main
% Create an Adjanceny Matrix of people relations
for i=1:numberOfrows
    
        Adjancency(socDataset(i,1) ,socDataset(i,2)) = 1;
        Adjancency(socDataset(i,2) ,socDataset(i,1)) = 1;
         
end

Adjancency(all(Adjancency==0,2),:)=[];
Adjancency(:, all(Adjancency==0,1))=[];

% Creating a Graph of Friends
G = graph(Adjancency~=0);

%Show the Graph
plot(G)

sparseMatrix = sparse (Adjancency);

%% Network Transformation (E.q 1)
eta =3;
I = ones( numberOfpopulation, numberOfpopulation);
S = (Adjancency+I)^eta;
for i=1:numberOfpopulation
   
    S_Hat(i,:) = S(i,:)/ sqrt(sum((S(i,:)).^2));
    
end

%% Calculate value of each node (E.q 4 to 5)

%(E.q 4)
for i=1:numberOfpopulation
   
    P(i,:) = Adjancency(i,:)/ sum(Adjancency(i,:));
    
end

%(E.q 5)
for i=1:numberOfpopulation
    temp =0;
    for j=1:numberOfpopulation
       
        temp = temp+exp(-(-pdist2(Adjancency(i,:), Adjancency(j,:))));
        
    end
   
P(i,:)=P(i,:)+temp;
    
end

P_Hat = PageRank( P, d );

%% minimum Distance
sigma = zeros(1,numberOfpopulation);

for i=1:numberOfpopulation-1
    
    temp = zeros(1,numberOfpopulation-i);
    k=1;
    for j=i+1:numberOfpopulation
        
        temp(k) = pdist2(P(i,:), P(j,:));
        k = k+1;
    end
    
    sigma(i) = min(temp);
    
end
scatter(P_Hat,sigma);
%%% Eq. 8
%CV = (P_Hat.*sigma)/(max(P_Hat)*max(sigma));
temp = sqrt (P_Hat.^2+sigma.^2);
[~,I] = sort (temp, 'descend');
centers = I(1:k);
%% Kmeans

dist = zeros(length(centers) , numberOfpopulation);
   
for j=1:length(centers)
        
  [dist(j,:),path,pred] = graphshortestpath(sparseMatrix,centers(j));
       
end    
[~,I] = min (dist);
cluster = centers(I); 
com = centers;
target = xlsread('community.xlsx');
acc = (length(find(cluster==target(1:numberOfpopulation)')))/numberOfpopulation*100



    
    
