function [perm] = modellpermutations(inputArg1,inputArg2)
% returns all combinations between the i_Moment. E.g. 
% inputArg1 = [0:10:100]; 
% inputArg2 = 3;
% return all combinations between those numbers in 3 rows
%   0   10  90
%   0   20  80
%   0   30  70
%   ...
%   50  20  30
%   ...
%   80  10  10
%   ...

comb = permn(inputArg1,inputArg2);
row = 1;
for index = 1:length(comb)
    if (comb(index, 1) + comb(index, 2) + comb(index, 3)) == 100
        perm(row,:) = comb(index,:);
        row = row + 1;
    end
end

end