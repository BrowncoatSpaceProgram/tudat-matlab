classdef Body < jsonable
    properties
        useDefaultSettings
        mass
        referenceArea
        aerodynamics
        atmosphere
        ephemeris
        gravityField
        gravityFieldVariation
        radiationPressure
        rotationModel
        shapeModel
    end
    properties (Transient)
        name
    end
    properties (Transient, Dependent)
        dragCoefficient
        radiationPressureCoefficient
    end
    
    methods
        function obj = Body(name)
            obj.aerodynamics = ConstantAerodynamics();
            obj.atmosphere = Atmosphere();
            obj.ephemeris = Ephemeris();
            obj.gravityField = GravityField();
            obj.gravityFieldVariation = GravityFieldVariation();
            obj.rotationModel = RotationModel();
            obj.shapeModel = ShapeModel();
            if nargin >= 1
                obj.name = name;
            end
        end
        
        function value = get.dragCoefficient(obj)
            value = obj.aerodynamics.dragCoefficient;
        end
        
        function set.dragCoefficient(obj,value)
            obj.aerodynamics.dragCoefficient = value;
        end
        
        function value = get.radiationPressureCoefficient(obj)
            value = obj.radiationPressure.Sun.radiationPressureCoefficient;
        end
        
        function set.radiationPressureCoefficient(obj,value)
            if ~isfield(obj.radiationPressure,'Sun')
                obj.radiationPressure.Sun = CannonBallRadiationPressure();
            end
            obj.radiationPressure.Sun.radiationPressureCoefficient = value;
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end
