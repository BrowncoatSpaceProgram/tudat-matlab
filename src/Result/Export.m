classdef Export < handle
    properties
        result
        file
    end
    
    methods
        function obj = Export(file,varargin)
            obj.result = Result(varargin{:});
            obj.file = file;
        end
        
        function s = struct(obj)
            s = struct(obj.result);
            s = json.update(s,obj,'file',true,'@path(%s)');
        end
        
    end
    
end
