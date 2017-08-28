classdef HermiteData < DataMap
    properties
        dependentVariableFirstDerivativeValues
    end
    
    methods
        function obj = HermiteData(varargin)
            obj@DataMap(varargin{1},varargin{2});
            if length(varargin) >= 3
                obj.dependentVariableFirstDerivativeValues = varargin{3};
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@DataMap(obj);
            mp = horzcat(mp,{'dependentVariableFirstDerivativeValues'});
        end
        
    end
    
end
