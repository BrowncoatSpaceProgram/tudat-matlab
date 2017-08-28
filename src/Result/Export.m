classdef Export < Result
    properties
        file
    end
    
    methods
        function obj = Export(file,varargin)
            obj@Result(varargin{:});
            obj.file = file;
        end
        
    end
    
    methods (Hidden)
        function p = isPath(obj,property)
            p = strcmp(property,'file');
        end
        
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Result(obj);
            mp = horzcat(mp,{'file'});
        end
        
   end
    
end
