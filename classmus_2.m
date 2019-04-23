%for this assignment we were asked to create a classifier to correctly
%classify music files to their artist and genre from 5 second clips.
%Here I read in the music, create the files from the spectrogram of the
%songs and then use various classifiers to test the different effects on
%the different classifiers used

%Here we are just reading in the music files. 
[p1,Fs1]=audioread('schubert.wav'); %read the audiorecording
p1=p1'; %take the transpose
p1=mean(p1);
tr=length(p1)/Fs1;

[p2,Fs2]=audioread('liszt.wav');
p2=p2';
p2=mean(p2);
tr2=length(p2)/Fs2;

[p3, Fs3]=audioread('chopin.wav');
p3=p3';
p3=mean(p3);
tr3=length(p3)/Fs3;
%%
%created a function that takes in the song and splits it into 5 seconds
%clips. See splitsong function to get better understanding of what it does
%Instead of using tr I hard code a value because the actual files is hours
%long and takes wayyyyyyy tooooo long to run so I truncate the files to
%only give me a smaller chunk of time. 
song1=splitsong(400,p1,Fs1);
song2=splitsong(400,p2,Fs2);
song3=splitsong(400,p3,Fs3);

%%
%finding the spectograms of each song and coverting it to a vector. To find
%more information on this function look at spectransform function.
specsong1=spectransform(song1);
specsong2=spectransform(song2);
specsong3=spectransform(song3);


%this does the same thing as above. IT creates an array with the actual
%bands that play each five second clip. 
band1=size(song1,1);
band2=size(song2,1);
band3=size(song3,1);
actvals_train=string(zeros(1,band1+band2+band3));
for j=1:length(actvals_train)
    if j<band1+1
        actvals_train(j)='schubert';
    elseif j<band1+band2+1
        actvals_train(j)='liszt';
    else
        actvals_train(j)='chopin';
    end
end


%%
%combining the songs into one matrix
allsongs=[specsong1 specsong2 specsong3];

%%
%In this section I simply split my data into training and test data
everything=[allsongs; actvals_train];
ind=randperm(size(everything,2));
everythingmixed=everything(:,ind);
%%
split=fix(.7*size(everything,2));
allsongs_almost=everything(:,1:split);
testsongs_almost=everything(:,split+1:end);
actual_values=testsongs_almost(end,:);
actvals_train=allsongs_almost(end,:);
allsongs=double(allsongs_almost(1:end-1,:));
testsongs=double(testsongs_almost(1:end-1,:));



%%
%finding the mean across rows and then computing the SVD
allsongs=allsongs-mean(allsongs,2);
[u, sigma, v]=svd(allsongs, 'econ');
%%
%here we create an array for the actual classes for each 5 second clip and
%for loop that simply labels the song with the correct band
% actual_values=string(zeros(1, size(testsongs,2)));
% predicted_values=zeros(1, size(testsongs,2));
% for j=1:length(actual_values)
%    if j<size(testsong1,1)+1
%        actual_values(j)='schubert';
%    elseif j<size(testsong1,1)+size(testsong2,1)+1
%        actual_values(j)='liszt';
%    else
%        actual_values(j)='chopin';
%    end
% end

%%
%finding the signature of the songs from the training dataset
%and then finding the signature of the test songs on the same basis
%as the training dataset.
vprime_train=v';
vprime_test=inv(sigma)*u'*testsongs;

%%
%projection of test songs onto the basis for the training songs
%found this as well becuase I wanted to see if it had 
%any significant impact on the accuracy on the different models
Y=u'*testsongs;
input=u'*allsongs;
Y=Y';
input=input';


%%
%KNN: Uses k nearest neighbor to classify the data. First transformed the
%data into rows(where each row is the informaiton on a single 5 second
%clip). Then, ran the model over the first 200 modes and created an array
%that holds the number of correclty label data from the test set based off
%the modes. Then create a plot. A form of validation on the data. 
vprime_train_normal=vprime_train';
vprime_test_normal=vprime_test';
actvalstrain_prime=actvals_train';
corrarray=[];
for modes=1:150
    model=fitcknn(vprime_train_normal(:,1:modes), actvals_train','NumNeighbors',1);
    label=predict(model,vprime_test_normal(:,1:modes));
    correctknn=0;
    for j=1:length(label)
        if label(j)==actual_values(j)
            correctknn=correctknn+1;
        end
    end
    corrarray=[corrarray correctknn];
end
knnperc=corrarray./length(label);
figure
plot(knnperc,'Linewidth',[2])
title('KNN:Accuracy on Test data based off of different modes')
xlabel('Modes: How many prinicipal components used')
ylabel('Percentage of accuracy')
%%
%tried the same thing as above out, but used u'data as the data used
%instead of just the v from the SVD
corrarray2=[];
for modes=1:150
    model=fitcknn(input(:,1:modes), actvals_train','NumNeighbors',1);
    label=predict(model,Y(:,1:modes));
    correctknn=0;
    for j=1:length(label)
        if label(j)==actual_values(j)
            correctknn=correctknn+1;
        end
    end
    corrarray2=[corrarray2 correctknn];
end
figure
plot(corrarray2,'Linewidth',[2])
%% SMV
%SVM: Uses support vector machines to classify the data.Ran the model over
%the first 200 modes and created an array
%that holds the number of correclty label data from the test set based off
%the modes. Then create a plot. A form of validation on the data. 
corrarraysvm=[];
for modes=1:150
    modelsvm=fitcecoc(vprime_train_normal(:,1:modes), actvals_train');
    labelsvm=predict(modelsvm,vprime_test_normal(:,1:modes));
    correctsvm=0;
    for j=1:length(labelsvm)
        if labelsvm(j)==actual_values(j)
            correctsvm=correctsvm+1;
        end
    end
    corrarraysvm=[corrarraysvm correctsvm];
end
%percentage of accuracy based off the modes
svmperc=corrarraysvm./length(labelsvm);
figure
plot(svmperc,'Linewidth',[2])
title('SVM:Accuracy on Test data based off of different modes')
xlabel('Modes: How many prinicipal components used')
ylabel('Percentage of accuracy')
%% Naive Bayes
%NB: Uses Naive Bayes to classify the data.Ran the model over
%the first 200 modes and created an array
%that holds the number of correclty label data from the test set based off
%the modes. Then create a plot. A form of validation on the data. 
corrarraynb=[];
for modes=1:150
    modelnb=fitcnb(vprime_train_normal(:,1:modes), actvals_train');
    labelnb=predict(modelnb,vprime_test_normal(:,1:modes));
    correctnb=0;
    for j=1:length(labelnb)
        if labelnb(j)==actual_values(j)
            correctnb=correctnb+1;
        end
    end
    corrarraynb=[corrarraynb correctnb];
end
%percentage of accuracy based off the modes
tperc=corrarraynb./length(labelnb);
figure
plot(tperc,'Linewidth',[2])
title('NB:Accuracy on Test data based off of different modes')
xlabel('Modes: How many prinicipal components used')
ylabel('Percentage of accuracy')


%%

%plot of the actual data normalized
figure
plot(allsongs(:,200), 'Linewidth',[2])
xlabel('time')
ylabel('y-value')
title('The different points extracted at each frame')
%%
%this looks at the diagonal values. This tells
%me what is going on in what direction. If it is big
%a lot is happening and if it is small then not 
%much is happening.
figure
plot(diag(sigma)/max(diag(sigma)), 'ro', 'Linewidth',[2])
xlabel('mode')
ylabel('normalized value')
title('Diagonal Values for SVD Case 2')

%This tells us how much each mode is contributing in terms of percentage
percentofenergy=(diag(sigma)/max(diag(sigma)))/sum(diag(sigma)/max(diag(sigma)));
%% Plot all plots togehter of the results
figure
hold on
plot(knnperc,'c', 'Linewidth',[2])
plot(svmperc,'y', 'Linewidth',[2])
plot(tperc,'m','Linewidth',[2])
hold off
legend('KNN','SVM','NB')
title('Three different accuracy scores on test set')
xlabel('Modes: How many prinicipal components used')
ylabel('Percentage of accuracy')
    
