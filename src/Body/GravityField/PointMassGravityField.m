classdef PointMassGravityField < GravityField
    properties
        gravitationalParameter
    end
    
    methods
        function obj = PointMassGravityField(gravitationalParameter)
            obj@GravityField(GravityFields.pointMass);
            if nargin >= 1
                obj.gravitationalParameter = gravitationalParameter;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@GravityField(obj);
            mp = horzcat(mp,{'gravitationalParameter'});
        end
        
    end
    
end
