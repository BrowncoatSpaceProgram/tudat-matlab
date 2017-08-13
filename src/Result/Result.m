classdef Result
    properties
        variables
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
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'variables');
            s = json.update(s,obj,'epochsInFirstColumn',false);
            s = json.update(s,obj,'precision',false);
            s = json.update(s,obj,'onlyInitialStep',false);
            s = json.update(s,obj,'onlyFinalStep',false);
        end
        
    end
    
end
