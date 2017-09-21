classdef Options < jsonable
    properties
        notifyOnPropagationStart
        notifyOnPropagationTermination
        printInterval
        defaultValueUsedForMissingKey
        unusedKey
        fullSettingsFile
        tagOutputFilesIfPropagationFails
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
            obj.defaultValueUsedForMissingKey = value;
        end
        
        function set.unusedKey(obj,value)
            if ~isa(value,'ExceptionResponses')
                value = ExceptionResponses(value);
            end
            obj.unusedKey = value;
        end
        
    end
    
    methods (Hidden)
        function p = isPath(obj,property)
            p = strcmp(property,{'fullSettingsFile'});
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end
