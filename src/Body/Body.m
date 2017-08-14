classdef Body < handle
    properties
        name
        useDefaultSettings
        mass
        referenceArea
        aerodynamics
        ephemeris
        radiationPressure
    end
    properties (Dependent)
        dragCoefficient
        radiationPressureCoefficient
    end
    
    methods
        function obj = Body(name)
            obj.name = name;
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
            obj.radiationPressure.Sun.radiationPressureCoefficient = value;
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'useDefaultSettings',false);
            s = json.update(s,obj,'mass',false);
            s = json.update(s,obj,'referenceArea',false);
            s = json.update(s,obj,'aerodynamics',false);
            s = json.update(s,obj,'ephemeris',false);
            s = json.update(s,obj,'radiationPressure',false);
            s = json.update(s,obj,'useDefaultSettings',false);
        end
    end
    
end
