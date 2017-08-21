classdef FromThrustMassRateModel < MassRateModel
    properties
        useAllThrustModels
        associatedThroustSource
    end
    
    methods
        function obj = FromThrustMassRateModel()
            obj@MassRateModel(MassRateModels.fromThrust);
        end
        
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@MassRateModel(obj);
            if ~obj.useAllThrustModels
                mp{end+1} = 'associatedThroustSource';
            end
        end
        
    end
    
end
