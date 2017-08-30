classdef SphericalHarmonicGravityField < GravityField
    properties
        model
        
        file
        associatedReferenceFrame
        maximumDegree
        maximumOrder
        gravitationalParameterIndex
        referenceRadiusIndex
        gravitationalParameter
        referenceRadius
        
        cosineCoefficients
        sineCoefficients
    end
    
    methods
        function obj = SphericalHarmonicGravityField(model)
            obj@GravityField(GravityFields.sphericalHarmonic);
            if nargin >= 1
                obj.model = model;
            end
        end
        
        function set.model(obj,value)
            if ~isa(value,'SphericalHarmonicModels')
                value = SphericalHarmonicModels(value);
            end
            obj.model = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@GravityField(obj);
            if ~isempty(obj.model)
                mp = horzcat(mp,{'model'});
            elseif ~isempty(obj.file)
                mp = horzcat(mp,{'file','associatedReferenceFrame','maximumDegree','maximumOrder'});
                if obj.gravitationalParameterIndex < 0
                    mp{end+1} = 'gravitationalParameter';
                end
                if obj.referenceRadiusIndex < 0
                    mp{end+1} = 'referenceRadius';
                end
            else
                mp = horzcat(mp,{'gravitationalParameter','referenceRadius','cosineCoefficients',...
                    'cosineCoefficients','associatedReferenceFrame'});
            end
        end
        
        function p = isPath(obj,property)
            p = strcmp(property,'file');
        end
        
    end
    
end
