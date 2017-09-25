classdef FromThrustMassRateModel < MassRateModel
    properties
        useAllThrustModels
        associatedThrustSource
    end
    
    methods
        function obj = FromThrustMassRateModel()
            obj@MassRateModel(MassRateModels.fromThrust);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@MassRateModel(obj);
            if ~obj.useAllThrustModels
                mp{end+1} = 'associatedThrustSource';
            end
        end
        
    end
    
end
