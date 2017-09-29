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
        
        function bodyName = get.sourceBody(obj)
            if isa(obj.sourceBody,'Body')
                bodyName = obj.sourceBody.name;
            else
                bodyName = obj.sourceBody;
            end
        end
        
        function bodyNames = get.occultingBodies(obj)
            bodyNames = cell(size(obj.occultingBodies));
            for i = 1:length(obj.occultingBodies)
                if isa(obj.occultingBodies{i},'Body')
                    bodyNames{i} = obj.occultingBodies{i}.name;
                else
                    bodyNames{i} = obj.occultingBodies{i};
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
