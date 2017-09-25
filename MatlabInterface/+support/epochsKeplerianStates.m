function [epochs,keplerianStates] = epochsKeplerianStates(varargin)

keplerianStatesHistory = support.optionalArgument(varargin,'KeplerianStatesHistory',[]);
if isempty(keplerianStatesHistory)
    epochs = support.optionalArgument(varargin,'Epochs',[]);
    keplerianStates = support.optionalArgument(varargin,'KeplerianStates',[]);
else
    if iscell(keplerianStatesHistory)
        epochs = cell(size(keplerianStatesHistory));
        keplerianStates = cell(size(keplerianStatesHistory));
        for i = 1:length(keplerianStatesHistory)
            epochs{i} = keplerianStatesHistory{i}(:,1);
            keplerianStates{i} = keplerianStatesHistory{i}(:,2:7);
        end
    else
        epochs = keplerianStatesHistory(:,1);
        keplerianStates = keplerianStatesHistory(:,2:7);
    end
end

if isempty(keplerianStates)
    [epochs,cartesianStates] = support.epochsCartesianStates(varargin{:});
    centralBody = support.optionalArgument(varargin,'CentralBody',[]);
    if iscell(cartesianStates)
        keplerianStates = cell(size(cartesianStates));
        for i = 1:length(cartesianStates)
            keplerianStates{i} = convert.cartesianToKeplerian(cartesianStates{i},centralBody);
        end
    else
        keplerianStates = convert.cartesianToKeplerian(cartesianStates,centralBody);
    end
end

end

