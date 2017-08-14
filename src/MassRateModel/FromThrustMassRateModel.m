classdef FromThrustMassRateModel < MassRateModel
    properties
        useAllThrustModels
        associatedThroustSource
    end
    
    methods
        function obj = FromThrustMassRateModel()
            obj@MassRateModel(MassRateModels.fromThrust);
        end
        
        function s = struct(obj)
            s = struct@MassRateModel(obj);
            s = json.update(s,obj,'useAllThrustModels',false);
            s = json.update(s,obj,'associatedThroustSource',~obj.useAllThrustModels);
        end
        
    end
    
end
