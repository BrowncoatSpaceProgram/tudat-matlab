classdef Result < jsonable
    properties
        variables
        header
        epochsInFirstColumn = false
        precision
        onlyInitialStep
        onlyFinalStep
    end
    
    methods
        function obj = Result(varargin)
            if isempty(varargin)
                error('Please provide at least one variable.');
            end
            if length(varargin) == 1 && isa(varargin{1},'Result')
                obj.variables = varargin{1}.variables;
                obj.header = varargin{1}.header;
                obj.epochsInFirstColumn = varargin{1}.epochsInFirstColumn;
                obj.precision = varargin{1}.precision;
                obj.onlyInitialStep = varargin{1}.onlyInitialStep;
                obj.onlyFinalStep = varargin{1}.onlyFinalStep;
            else
                for i = 1:length(varargin)
                    obj.variables{i} = Variable(varargin{i});
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'variables'};
        end
        
    end
    
end
