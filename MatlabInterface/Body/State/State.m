classdef State < jsonable
    properties
        % Cartesian
        x
        y
        z
        vx
        vy
        vz
        
        % Keplerian
        centralBodyGravitationalParameter
        centralBodyAverageRadius
        semiMajorAxis
        eccentricity
        inclination
        argumentOfPeriapsis
        longitudeOfAscendingNode
        trueAnomaly
        meanAnomaly
        eccentricAnomaly
        semiLatusRectum
        meanMotion
        period
        radius
        altitude
        periapsisDistance
        apoapsisDistance
        periapsisAltitude
        apoapsisAltitude
    end
    properties (Dependent)
        type
    end
    
    methods
        function obj = State(varargin)
            N = length(varargin);
            if N == 1
                obj.components = varargin{1};
            else
                assert(mod(N,2) == 0,'Must provide a single argument, or an even number of arguments.');
                for i = 1:N/2
                    obj.(varargin{i*2-1}) = varargin{i*2};
                end
            end
        end
        
        function type = get.type(obj)
            cartesianProperties = obj.cartesianProperties();
            for i = 1:length(cartesianProperties)
                if ~isempty(obj.(cartesianProperties{i}))
                    type = States.cartesian;
                    return;
                end
            end
            
            keplerianProperties = obj.keplerianProperties();
            for i = 1:length(keplerianProperties)
                if ~isempty(obj.(keplerianProperties{i}))
                    type = States.keplerian;
                    return;
                end
            end
            
            type = [];
        end
        
    end
    
    methods (Hidden)
        function p = cartesianProperties(obj)
            p = {'x','y','z','vx','vy','vz'};
        end
        
        function p = keplerianProperties(obj)
            p = {'centralBodyGravitationalParameter','centralBodyAverageRadius','semiMajorAxis',...
                'eccentricity','inclination','argumentOfPeriapsis','longitudeOfAscendingNode','trueAnomaly',...
                'meanAnomaly','eccentricAnomaly','semiLatusRectum','meanMotion','period','radius','altitude',...
                'periapsisDistance','apoapsisDistance','periapsisAltitude','apoapsisAltitude'};
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {''};
        end
        
    end
    
end
