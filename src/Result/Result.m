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
                obj = varargin{1};
            else
                for i = 1:length(varargin)
                    obj.variables{i} = Variable(varargin{i});
                end
            end
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {'variables'};
        end
        
    end
    
end
