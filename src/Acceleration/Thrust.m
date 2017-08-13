classdef Thrust < Acceleration
    properties
        direction
        magnitude
    end
    
    methods
        function obj = Thrust(direction,magnitude)
            obj@Acceleration(Accelerations.thrust);
            obj.direction = direction;
            obj.magnitude = magnitude;
        end
        
        function s = struct(obj)
            s = struct@Acceleration(obj);
            s = json.update(s,obj,'direction');
            s = json.update(s,obj,'magnitude');
        end
        
    end
    
end
