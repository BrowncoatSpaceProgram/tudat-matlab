classdef SimpleRotationModel < RotationModel
    properties
        initialOrientation
        initialTime
        rotationRate
    end
    
    methods
        function obj = SimpleRotationModel()
            obj@RotationModel(RotationModels.simple);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@RotationModel(obj);
            mp = horzcat(mp,{'initialOrientation','initialTime','rotationRate'});
        end
        
    end
    
end
