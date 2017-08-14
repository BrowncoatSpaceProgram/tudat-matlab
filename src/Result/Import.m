classdef Import < handle
    properties
        result
        name
    end
    
    methods
        function obj = Import(name,varargin)
            obj.result = Result(varargin{:});
            obj.name = name;
        end
        
    end
    
end
