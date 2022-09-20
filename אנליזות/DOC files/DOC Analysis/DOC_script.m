%% 
%load the data
load('Saliva_data.mat')
%%%%%%%%%%   filtering  %%%%%%%%%%%%%%
%cleaning the data by number of reads per feature
read_avg = mean(Saliva_data,2);
%we want features that has 1 read in average minimum
data = Saliva_data(read_avg>=1,:);
%filtering by samples that has significantly less reads
samples_reads = sum(data,1);
sorted_samples_reads = sort(samples_reads);
mean(sorted_samples_reads)
%after looking at the data, filtering the samples that has less than 1000
%reads
clean_data = data(:,samples_reads>1000);
%calculate the percentage of each species from the entire OTU in order to
%remain the species that make 90% of it
sum_all = sum(clean_data);
sum_all = sum(sum_all);
sum_otu = sum(clean_data,2);
relative_otus = sum_otu/sum_all;
indices = transpose(1:length(relative_otus));
relative_otu_mat = [indices relative_otus];
%sort the relative otu values, but we still have their indices for
%later
sorted_otu_abundance = sortrows(relative_otu_mat, 2, 'descend');
%find the indices of the 90% top otus
remain = sorted_otu_abundance((cumsum(sorted_otu_abundance(:,2))<=0.9),1);
%filter out otus so we will have top 90%
clean_data_otu = clean_data(remain, :);
%filter samples that don't have many otus
number_of_otus = sum(clean_data_otu>0,1);
%look at different parameters such as min, max, mean and median, and
%decided not to filter any samples from here
%save the data
writematrix(clean_data_otu, "cleanOTU.txt");
%% 

%% use the ready code instead
%%%%%%%%   DOC   %%%%%%%%%%%%
%[rjsd_ol_vector, rjsd_d_vector] = DOC(clean_data_otu, 'rjsd');
%[e_ol_vector, e_d_vector] = DOC(clean_data_otu, 'e');
%[spearman_ol_vector, spearman_d_vector] = DOC(clean_data_otu, 'spearman');
%using lowess for the curve
% rjsd_y_smooth = malowess(rjsd_ol_vector, rjsd_d_vector, 'Robust', true, 'Span', 0.2);
% e_y_smooth = malowess(e_ol_vector, e_d_vector, 'Robust', true, 'Span', 0.2);
% spearman_y_smooth = malowess(spearman_ol_vector, spearman_d_vector, 'Robust', true, 'Span', 0.2);
% 
% [rownum,colnum] = size(clean_data_otu);
% [rjsd_mat3, rjsd_mat97] = GetConfidenceInterval(rjsd_ol_vector, rjsd_d_vector, colnum, 100);
% [e_mat3, e_mat97] = GetConfidenceInterval(e_ol_vector, e_d_vector, colnum, 100);
% [spearman_mat3, spearman_mat97] = GetConfidenceInterval(spearman_ol_vector, spearman_d_vector, colnum, 100);
%% 

% %% 
% %plot the results
% %rjsd
% fig = figure;
% subplot(3,1,1)
% scatter(rjsd_ol_vector, rjsd_d_vector, 0.5)
% hold on
% plot(rjsd_ol_vector, rjsd_y_smooth, 'rx')
% title("DOC plot using rjsd distance method")
% axis tight
% plot(rjsd_mat3(1,:), rjsd_mat3(2,:))
% %shade(rjsd_ol_vector, rjsd_mat3, rjsd_ol_vector, rjsd_mat97)
% %euclidean
% subplot(3,1,2)
% scatter(e_ol_vector, e_d_vector, 0.5)
% hold on
% plot(e_ol_vector, e_y_smooth, 'rx')
% title("DOC plot using euclidean distance method")
% axis tight
% %spearman
% subplot(3,1,3)
% scatter(spearman_ol_vector, spearman_d_vector, 0.5)
% hold on
% plot(spearman_ol_vector, spearman_y_smooth, 'rx')
% title("DOC plot using spearman distance method")
% axis tight
% %titles
% han=axes(fig,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Overlap', 'FontSize', 15);
% xlabel(han,'Dissimilarity', 'FontSize', 15);
