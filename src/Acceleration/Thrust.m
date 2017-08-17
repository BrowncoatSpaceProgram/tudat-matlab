classdef Thrust < Acceleration
    properties
        direction
        magnitude
        dataInterpolation
        specificImpulse
        frame
        centralBody
    end
    
    methods
        function obj = Thrust()
            obj@Acceleration(Accelerations.thrust);
        end
        
        function s = struct(obj)
            s = struct@Acceleration(obj);
            if ~isempty(obj.dataInterpolation)
                s = json.update(s,obj,'dataInterpolation');
                s = json.update(s,obj,'specificImpulse');
                s = json.update(s,obj,'frame');
                s = json.update(s,obj,'centralBody',false);
            else
                s = json.update(s,obj,'direction');
                s = json.update(s,obj,'magnitude');
            end
        end
        
    end
    
end
