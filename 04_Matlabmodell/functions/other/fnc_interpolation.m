function interpolate = fnc_interpolation(WORKING_VARIABLE_ONE, WORKING_VARIABLE_TWO, Y_VALUE_TO_CROSS)

% Interpolation um die maximale befahrbare Steigung zu bestimmen
interpolate.pointer = 1;
if isstruct(WORKING_VARIABLE_ONE) 
    num = numel(fieldnames(WORKING_VARIABLE_ONE));
else
    num = 1;
end
for index = 1 : num
    if isstruct(WORKING_VARIABLE_ONE)
        interpolate.c = struct2cell(WORKING_VARIABLE_ONE);
        interpolate.val = cell2mat(interpolate.c(index));
    else
        interpolate.val = WORKING_VARIABLE_ONE;
    end
    if isempty(find(interpolate.val == Y_VALUE_TO_CROSS, 1))
        zci = @(v) find((v(:)-Y_VALUE_TO_CROSS).*circshift((v(:)-Y_VALUE_TO_CROSS), [-1 0]) <= 0);      % Returns Zero-Crossing Indices Of Argument Vector
        interpolate.var = zci(interpolate.val);                                                         % Approximate Zero-Crossing Indices
        if ~isempty(interpolate.var)
            for index_1 = 1:length(interpolate.var)
                if interpolate.var(index_1) >= length(interpolate.val)
                    continue;
                else
                    interpolate.ans(1,interpolate.pointer) = WORKING_VARIABLE_TWO(interpolate.var(index_1) +1) - ...
                        (WORKING_VARIABLE_TWO(interpolate.var(index_1) +1)-WORKING_VARIABLE_TWO(interpolate.var(index_1))) / ...
                        (interpolate.val(interpolate.var(index_1) +1)-interpolate.val(interpolate.var(index_1)))* ...
                        (interpolate.val(interpolate.var(index_1) +1)-Y_VALUE_TO_CROSS);
                    interpolate.pointer = interpolate.pointer + 1;
                end
            end
        else
            continue;
        end
    else
        interpolate.ans(1,interpolate.pointer) = WORKING_VARIABLE_TWO(find(interpolate.val == Y_VALUE_TO_CROSS, 1));
        interpolate.pointer = interpolate.pointer + 1;
    end
end
end

