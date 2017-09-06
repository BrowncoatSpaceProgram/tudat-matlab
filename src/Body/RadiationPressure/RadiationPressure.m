classdef RadiationPressure < jsonable
    properties
        type
        sourceBody
        occultingBodies
    end
    
    methods
        function obj = RadiationPressure(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'RadiationPressureTypes')
                value = RadiationPressureTypes(value);
            end
            obj.type = value;
        end
        
        function bodyNames = get.occultingBodies(obj)
            if iscell(obj.occultingBodies)
                bodyNames = obj.occultingBodies;
            else
                bodyNames = { obj.occultingBodies };
            end
            for i = 1:length(bodyNames)
                if isa(bodyNames{i},'Body')
                    bodyNames{i} = bodyNames{i}.name;
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end
