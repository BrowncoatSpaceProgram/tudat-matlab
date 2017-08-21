classdef jsonable < handle
    methods
        function props = getProperties(obj)
            mc = metaclass(obj);
            p = { mc.PropertyList.Name };
            t = { mc.PropertyList.Transient };
            props = {};
            for i = 1:length(p)
                if ~t{i}
                    props{end+1} = p{i};
                end
            end
        end
        
        function mandatory = isMandatory(obj,property)
            mandatory = any(strcmp(property,getMandatoryProperties(obj)));
        end
        
        function empty = isempty(obj)
            props = getProperties(obj);
            for i = 1:length(props)
                if ~isempty(obj.(props{i}))
                    empty = false;
                    return;
                end
            end
            empty = true;
        end
        
        function s = struct(obj)
            s = [];
            propertyNames = getProperties(obj);
            for i = 1:length(propertyNames)
                propertyName = propertyNames{i};
                s = json.update(s,obj,propertyName,isMandatory(obj,propertyName));
            end
        end
        
    end
    
end
