classdef FromFileDataMap < DataMap
    properties
        file
    end
    
    methods
        function obj = FromFileDataMap(file)
            if nargin >= 1
                obj.file = file;
            end
        end
        
    end
    
    methods (Hidden)
        function p = isPath(obj,property)
            p = strcmp(property,'file');
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {'file'};
        end
        
    end
    
end
