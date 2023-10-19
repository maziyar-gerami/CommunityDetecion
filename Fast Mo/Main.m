clc;
clear;
close all;
%% Parameters and Initialization
t= cputime;
N = 10000;                  % Number of Population
EoT = 10;                   % Effect of time
index = 10;                 % Index of Target Person
nSelcted = 10;

% Getting Raw Dataset from Input
socDataset = xlsread ('socEpinions.xlsx');
socDataset = socDataset(1:N,:);
trustDataset = xlsread ('edgeEpinion.xlsx');

% Trancate Trust Dataset
uniquePersons = unique(socDataset(:));
trustDataset = trustDataset(ismember( trustDataset(:,1), uniquePersons ),: );
trustDataset = trustDataset(ismember( trustDataset(:,2), uniquePersons ),: );

%Calculating Number of Population
numberOfpopulation = length(uniquePersons);
numberOfrows = length(socDataset);

% Normalize The Time Column
trustDataset(:,4) = EoT*(1- (trustDataset(:,4)- min(trustDataset(:,4)))/(max(trustDataset(:,4))- min(trustDataset(:,4))));

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

%% Create a Trust Matrix of people

% Create an empty Trust Matrix of people relations
trustMatrix =zeros(numberOfpopulation,numberOfpopulation);

for i=1:length(trustDataset)

    v = ismember (uniquePersons, trustDataset(i,1));
    index1 = find(v);
    
    v = ismember (uniquePersons, trustDataset(i,2));
    index2 = find(v);
    
    trustMatrix(index1,index2) = ...
        trustMatrix(index1, index2)+ trustDataset(i,3)*trustDataset(i,4);
   
end
trustPersons = sum(trustMatrix);
trustPersons = (trustPersons-min (trustPersons))/(max (trustPersons)-min (trustPersons));

%% Find Potential Friends

%community Detection
[communities , Q] = fast_mo(Adjancency);
in = linspace(1,1000,1000);
community = communities(index);
potentialFriends = find (communities == community);

% Find potential Friends' Trustworthy 
for i=1:length(potentialFriends)
   
    v = ismember (uniquePersons, potentialFriends(i));
    idx = find(v);
    if (~isempty(idx))
        potentialFriends(i,2) =  trustPersons(idx);
    end
    
end

similarPerson = sortrows(potentialFriends, 2);
similarPerson = flip(similarPerson);

propose = similarPerson(1:nSelcted, 1)


[~, ind] = ismember(propose, similarPerson);
    
average = mean (similarPerson(ind,2))

sumation = sum(similarPerson(ind,2))

time = cputime-t
