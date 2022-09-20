function [y_Bootstrap,xs,p_lme]=func_cal_rlowess_bootstrap(Overlap,RootJSD,NumBootstraps,change_point)

NumSamples=length(Overlap);

span=0.2;
NumPointsInGrid=100;

% Define a grid for all the bootstrap realizations
xs=Overlap(:);
xs(isnan(xs))=[];
xs=linspace(min(xs),max(xs),NumPointsInGrid);

% make a symmetric Overlap matrix
OverlapSym=Overlap;
OverlapSym(isnan(OverlapSym))=0;
OverlapSym=OverlapSym+OverlapSym';
OverlapSym(1:NumSamples+1:end)=nan;

% make a symmetric Dissimilarity matrix
RootJSDSym=RootJSD;
RootJSDSym(isnan(RootJSDSym))=0;
RootJSDSym=RootJSDSym+RootJSDSym';
RootJSDSym(1:NumSamples+1:end)=nan;

% make a matrix with the index of subjects 1 and 2
Subj1=repmat((1:NumSamples)',1,NumSamples);
Subj2=repmat(1:NumSamples,NumSamples,1);


y_Bootstrap=nan(NumBootstraps, length(xs));
p_lme=nan(NumBootstraps,1);

parfor i=1:NumBootstraps

    % resample NumSamples samples
    k=randi(NumSamples,NumSamples,1);
    ChosenOverlap=OverlapSym(k,k); %#ok<*PFBNS>
    ChosenRJSD=RootJSDSym(k,k);
    ChosenSubj1=Subj1(k,k); 
    ChosenSubj2=Subj2(k,k);
    
    % make vectors from the uper triangle matrices
    Overlap_Vec=nan(NumSamples*(NumSamples-1)/2,1);
    RootJSD_Vec=nan(NumSamples*(NumSamples-1)/2,1);
    Subj1_Vec=nan(NumSamples*(NumSamples-1)/2,1);
    Subj2_Vec=nan(NumSamples*(NumSamples-1)/2,1);
    counter=1;
    for m=1:NumSamples
        for n=m+1:NumSamples
            Overlap_Vec(counter)=ChosenOverlap(m,n);
            RootJSD_Vec(counter)=ChosenRJSD(m,n);
            Subj1_Vec(counter)=ChosenSubj1(m,n);
            Subj2_Vec(counter)=ChosenSubj2(m,n);
            counter=counter+1;
        end
    end
    
    % remove nans
    elements_to_remove=isnan(Overlap_Vec);
    Overlap_Vec(elements_to_remove)=[];
    RootJSD_Vec(elements_to_remove)=[];
    Subj1_Vec(elements_to_remove)=[];
    Subj2_Vec(elements_to_remove)=[];
       
    ys=myrlowess([Overlap_Vec  RootJSD_Vec],xs,span);

    y_Bootstrap(i,:)=ys(:)';


    % fit lme for each bootstrap realization
    ind_LowOverlap=find(Overlap_Vec<change_point | isnan(Overlap_Vec));
    
    Overlap_Vec(ind_LowOverlap)=[];
    RootJSD_Vec(ind_LowOverlap)=[];
    Subj1_Vec(ind_LowOverlap)=[];
    Subj2_Vec(ind_LowOverlap)=[];
    
    
    tbl=table(Subj1_Vec,Subj2_Vec,Overlap_Vec,RootJSD_Vec);
    
    lme=fitlme(tbl,'RootJSD_Vec ~ 1 + Overlap_Vec +(1|Subj1_Vec)');

    p_lme(i)=lme.Coefficients.Estimate(2);
    
    
end % for i



