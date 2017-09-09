function [epochs,cartesianStates] = epochsCartesianStates(varargin)

cartesianStatesHistory = support.optionalArgument(varargin,'CartesianStatesHistory',[]);
if isempty(cartesianStatesHistory)
    epochs = support.optionalArgument(varargin,'Epochs',[]);
    cartesianStates = support.optionalArgument(varargin,'CartesianStates',[]);
else
    if iscell(cartesianStatesHistory)
        epochs = cell(size(cartesianStatesHistory));
        cartesianStates = cell(size(cartesianStatesHistory));
        for i = 1:length(cartesianStatesHistory)
            epochs{i} = cartesianStatesHistory{i}(:,1);
            cartesianStates{i} = cartesianStatesHistory{i}(:,2:7);
        end
    else
        epochs = cartesianStatesHistory(:,1);
        cartesianStates = cartesianStatesHistory(:,2:7);
    end
end

end
