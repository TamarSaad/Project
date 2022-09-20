function [mat3, mat97] = GetConfidenceInterval(overlap,dissimilarity, num_of_samples, T)
%the vector of all the curves
confidence_interval_y=[];
confidence_interval_x=[];
%doing T iterations
for t = 1:T
    %create matrices for overlap and dissimilarity, instead of vectors
    upper_overlap_mat = zeros(num_of_samples, num_of_samples);
    upper_dissimilarity_mat = zeros(num_of_samples, num_of_samples);
    loc = 1;
    for line = 1:num_of_samples
        %fill the matrix in a tringular way
        upper_overlap_mat(line, (line+1):end) = overlap(loc:(loc+num_of_samples-line-1));
        upper_dissimilarity_mat(line, (line+1):end) = dissimilarity(loc:(loc+num_of_samples-line-1));
        loc = loc + num_of_samples - line;
    end
    lower_overlap_mat=transpose(upper_overlap_mat);
    lower_dissimilarity_mat=transpose(upper_dissimilarity_mat);
    overlap_mat = upper_overlap_mat + lower_overlap_mat;
    dissimilarity_mat = upper_dissimilarity_mat + lower_dissimilarity_mat;
    %sample n observations with repeats
    samples = datasample(1:num_of_samples, num_of_samples);
    %create the vectors of overlap and dissimilarity for these samples
    s_overlap = zeros(1,length(overlap));
    s_dissimilarity = zeros(1,length(dissimilarity));
    loc = 1;
    for i = 1:num_of_samples
        for j = (i+1):num_of_samples
            s_overlap(loc)=overlap_mat(samples(i),samples(j));
            s_dissimilarity(loc)=dissimilarity_mat(samples(i),samples(j));
            loc = loc + 1;
        end
    end
    %create the doc 
    t_conf_y = malowess(s_overlap, s_dissimilarity, 'Robust', true, 'Span', 0.2);
    confidence_interval_x = [confidence_interval_x; s_overlap];
    confidence_interval_y = [confidence_interval_y; t_conf_y];
end
%sort the avarage height of each T doc
sorted_means = mean(confidence_interval_y,2);
%choose the 3rd and 97nd percentiles of the data
[sortedX, sortedInds] = sort(sorted_means(:),'descend');
loc_d = round(0.03*T);
loc_u = round(0.97*T);
if loc_d == 0
    loc_d = 1;
end
if loc_u > length(sorted_means)
    loc_u = length(sorted_means);
end
per3 = sortedInds(loc_d);
per97 = sortedInds(loc_u);
mat97 = [confidence_interval_x(per97,:); confidence_interval_y(per97,:)];
mat3 = [confidence_interval_x(per3,:); confidence_interval_y(per3,:)];
end
