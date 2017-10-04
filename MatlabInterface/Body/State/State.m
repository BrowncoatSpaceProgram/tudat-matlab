classdef State < jsonable
    properties
        %%% Cartesian
        x
        y
        z
        vx
        vy
        vz
        
        %%% Keplerian
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
        
        %%% Spherical
        % centralBodyAverageRadius
        epoch
        % radius
        % altitude
        latitude
        longitude
        speed
        flightPathAngle
        headingAngle
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
            % Get all possible properties (except type)
            properties = getProperties(obj);
            properties = properties(~strcmp(properties,'type'));
            
            % Determine whether all the defined properties are all
            % Cartesian, all Keplerian or all Spherical
            somethingDefined = false;
            allCartesian = true;
            allKeplerian = true;
            allSpherical = true;
            for i = 1:length(properties)
                property = properties{i};
                if ~isempty(obj.(property))
                    somethingDefined = true;
                    if ~State.isCartesianProperty(property)
                        allCartesian = false;
                    end
                    if ~State.isKeplerianProperty(property)
                        allKeplerian = false;
                    end
                    if ~State.isSphericalProperty(property)
                        allSpherical = false;
                    end
                end
            end
            
            if ~somethingDefined
                type = [];
                return;
            end
            
            if allCartesian && ~allKeplerian && ~allSpherical
                type = States.cartesian;
            elseif ~allCartesian && allKeplerian && ~allSpherical
                type = States.keplerian;
            elseif ~allCartesian && ~allKeplerian && allSpherical
                type = States.spherical;
            else
                error('Impossible to infer state type. Please define more properties.');
            end
            
        end
        
    end
    
    methods (Static,Hidden)
        function icp = isCartesianProperty(property)
            icp = any(strcmp(property,{'x','y','z','vx','vy','vz'}));
        end
        
        function ikp = isKeplerianProperty(property)
            ikp = any(strcmp(property,{'centralBodyGravitationalParameter','centralBodyAverageRadius',...
                'semiMajorAxis','eccentricity','inclination','argumentOfPeriapsis',...
                'longitudeOfAscendingNode','trueAnomaly','meanAnomaly','eccentricAnomaly','semiLatusRectum',...
                'meanMotion','period','radius','altitude','periapsisDistance','apoapsisDistance',...
                'periapsisAltitude','apoapsisAltitude'}));
        end
        
        function isp = isSphericalProperty(property)
            isp = any(strcmp(property,{'centralBodyAverageRadius','radius','altitude','epoch','latitude',...
                'longitude','speed','flightPathAngle','headingAngle'}));
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {''};
        end
        
    end
    
end
