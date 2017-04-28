function [initNum,endNum,file_numbers,name,fullList] = inputParams(dir_name)
% 
% [initNum,endNum,file_numbers,name,fullList] = inputParams(dir_name)



% A GUI helper function to load initial information about the data.
% 
% 
% input:
%     dir_name - the directory name which contaun the datasets.
% output:
%     initNum -the number of the initial frame in the seqence.
%     endNum - the number of the final frame in the sequnce.
%     file_numbers - the numbers of the frames in the sequnce.
%     name - template file name in the directory.
%     fullList - variable which says if the sequnce ids full.
%     
%     


    
 filelist = ls([dir_name '\phase']);
 first_file = filelist(3,:);
 filelist = int16(filelist(3:end,:));
 filelist_diff = filelist - repmat(filelist(1,:), size(filelist, 1), 1);
 mask = (sum(abs(filelist_diff)) ~= 0);
 
 index = find(mask ~= 0);
 name = [first_file(1:(index(1)-1)) '%.' num2str(length(index)) 'd' first_file((index(end)+1):end) ];
 file_numbers = sort(str2num(char(filelist(:, index))));
 initNum = min(file_numbers);
 endNum = max(file_numbers);
 if (endNum - initNum + 1 == size(filelist, 1))
     fullList = 1;
 else 
      fullList = 0;
 end 
end

