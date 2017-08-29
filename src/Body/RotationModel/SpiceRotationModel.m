classdef SpiceRotationModel < RotationModel
    properties
        
    end
    
    methods
        function obj = SpiceRotationModel()
            obj@RotationModel(RotationModels.spice);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@RotationModel(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end
