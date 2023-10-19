clc;
clear;
close all;
%% Parameters and Initialization
t= cputime;
N = 1000;                  % Number of Population
d=1;
K=3;

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

[idx,C] = kmeanspp(uniquePersons, K);
target = xlsread('community.xlsx');
acc = (length(find(idx==target(1:numberOfpopulation)')))/numberOfpopulation*100