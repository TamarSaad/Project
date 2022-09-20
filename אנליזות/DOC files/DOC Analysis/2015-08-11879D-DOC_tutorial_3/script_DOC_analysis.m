

%% Load OTU table
A=load('cleanOTU.txt');

%% normalize to relative abundances
[NumSpecies,NumSamples]=size(A);
A=A./repmat(sum(A),NumSpecies,1);

%% make null model
A_null=func_make_null(A,1);

%% get Overlap and Dissimilarity for the real samples
[Overlap,RootJSD]=func_Cal_Overlap_rJSD_from_relative_abundance(A);

%% get Overlap and Dissimilarity for the null model
[Overlap_null,RootJSD_null]=func_Cal_Overlap_rJSD_from_relative_abundance(A_null);

%% make vectors of the overlap and dissimilarity matrices
Overlap_Vec=Overlap(:);
Overlap_Vec(isnan(Overlap_Vec))=[];

RootJSD_Vec=RootJSD(:);
RootJSD_Vec(isnan(RootJSD_Vec))=[];

Overlap_Vec_null=Overlap_null(:);
Overlap_Vec_null(isnan(Overlap_Vec_null))=[];

RootJSD_Vec_null=RootJSD_null(:);
RootJSD_Vec_null(isnan(RootJSD_Vec_null))=[];

%% make Bootstrap for the real samples
N_times=10;
change_point=median(Overlap_Vec);

[BS, xs, slope_lme]=func_cal_rlowess_bootstrap(Overlap,RootJSD,N_times,change_point);

%% make Bootstrap for the null model
change_point_null=median(Overlap_Vec_null);

[BS_null, xs_null ,slope_lme_null]=func_cal_rlowess_bootstrap...
    (Overlap_null,RootJSD_null,N_times,change_point_null);

%% DOCs 
span=0.2;

ys=myrlowess([Overlap_Vec  RootJSD_Vec],xs,span);


ys_null=myrlowess([Overlap_Vec_null  RootJSD_Vec_null],xs_null,span);

%% plot figure

figure('position',[138         156        1032         480])

subplot(1,2,1)
hold on

% real
Prctile_BS = prctile(BS,[3  97],1)'; 

plot(Overlap_Vec,RootJSD_Vec,'.','color','k','MarkerSize',0.7);

plot(xs,ys,'linewidth',3,'color','b')
plot(xs,Prctile_BS(:,1),'linewidth',1,'color','c')
plot(xs,Prctile_BS(:,2),'linewidth',1,'color','c')

xc=detect_negative_slope(xs,ys);
plot(xc*[1 1],get(gca,'ylim'),'-g')

box on
axis square

xlabel('Overlap','fontsize',22)
ylabel('Dissimilarity','fontsize',22)
shade(xs,Prctile_BS(:,2),'c', xs,Prctile_BS(:,1),'c', 'FillType',[1 2;2 1], 'FillColor', 'cyan')

subplot(1,2,2)
hold on

% null
Prctile_BS_null = prctile(BS_null,[3  97],1)'; 

plot(Overlap_Vec_null,RootJSD_Vec_null,'.','color','k','MarkerSize',0.7);

plot(xs_null,ys_null,'linewidth',3,'color','r')
plot(xs_null,Prctile_BS_null(:,1),'linewidth',1,'color','y')
plot(xs_null,Prctile_BS_null(:,2),'linewidth',1,'color','y')

box on
axis square

xlabel('Overlap','fontsize',22)
ylabel('Dissimilarity','fontsize',22)
shade(xs_null,Prctile_BS_null(:,2),'y', xs_null,Prctile_BS_null(:,1),'y', 'FillType',[1 2;2 1], 'FillColor', 'yellow')


%%
% Fraction of data with negative slope
Fns=sum(Overlap_Vec>xc)/length(Overlap_Vec);

% Fraction of times p_lme is non-negative
P_real=sum(slope_lme>=0)/length(slope_lme);
P_null=sum(slope_lme_null>=0)/length(slope_lme_null);

% Display the universality scores
disp(['Fraction of data with negative slope=' num2str(Fns)])
disp(['Fraction of times p_lme is non-negative- real data=' num2str(P_real)])
disp(['Fraction of times p_lme is non-negative- null data=' num2str(P_null)])



