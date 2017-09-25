classdef PointMassSpiceGravityField < GravityField
    properties
        
    end
    
    methods
        function obj = PointMassSpiceGravityField()
            obj@GravityField(GravityFields.pointMassSpice);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@GravityField(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end
