classdef SecondOrderGravitationalTorque < Torque
    methods
        function obj = SecondOrderGravitationalTorque()
            obj@Torque(Torques.secondOrderGravitational);
        end
        
    end
    
end
