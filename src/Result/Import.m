classdef Import < jsonable
    properties
        result
        name
    end
    
    methods
        function obj = Import(name,varargin)
            obj.result = Result(varargin{:});
            obj.name = name;
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {'result','name'};
        end
        
    end
    
end
