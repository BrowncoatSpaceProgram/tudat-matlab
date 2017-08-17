classdef Options < handle
    properties
        notifyOnPropagationStart
        notifyOnPropagationTermination
        printInterval
        defaultValueUsedForMissingKey
        unusedKey
        unidimensionalArrayInference
        populatedFile
    end
    
    methods
        function obj = Options(varargin)
            N = length(varargin);
            if mod(N,2) ~= 0
                error('You must provide an even number of arguments: name1, value1, name2, value2...');
            end
            for i = 1:N/2
                obj.(varargin{2*i-1}) = varargin{2*i};
            end
        end
        
        function set.defaultValueUsedForMissingKey(obj,value)
            if ~isa(value,'ExceptionResponses')
                value = ExceptionResponses(value);
            end
            obj.defaultValueUsedForMissingKey = char(value);
        end
        
        function set.unusedKey(obj,value)
            if ~isa(value,'ExceptionResponses')
                value = ExceptionResponses(value);
            end
            obj.unusedKey = char(value);
        end
        
        function set.unidimensionalArrayInference(obj,value)
            if ~isa(value,'ExceptionResponses')
                value = ExceptionResponses(value);
            end
            obj.unidimensionalArrayInference = char(value);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'notifyOnPropagationStart',false);
            s = json.update(s,obj,'notifyOnPropagationTermination',false);
            s = json.update(s,obj,'printInterval',false);
            s = json.update(s,obj,'defaultValueUsedForMissingKey',false);
            s = json.update(s,obj,'unusedKey',false);
            s = json.update(s,obj,'unidimensionalArrayInference',false);
            s = json.update(s,obj,'populatedFile',false);
        end
        
    end
    
end
