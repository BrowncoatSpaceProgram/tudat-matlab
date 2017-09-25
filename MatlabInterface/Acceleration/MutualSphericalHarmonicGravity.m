classdef MutualSphericalHarmonicGravity < Acceleration
    properties
        maximumDegreeOfBodyExertingAcceleration
        maximumOrderOfBodyExertingAcceleration
        maximumDegreeOfBodyUndergoingAcceleration
        maximumOrderOfBodyUndergoingAcceleration
        maximumDegreeOfCentralBody
        maximumOrderOfCentralBody
    end
    
    methods
        function obj = MutualSphericalHarmonicGravity()
            obj@Acceleration(Accelerations.mutualSphericalHarmonicGravity);
        end

    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Acceleration(obj);
            mp = horzcat(mp,{'maximumDegreeOfBodyExertingAcceleration','maximumOrderOfBodyExertingAcceleration',...
                'maximumDegreeOfBodyUndergoingAcceleration','maximumOrderOfBodyUndergoingAcceleration'});
        end
        
    end
    
end
