classdef AerodynamicTorque < Torque
    methods
        function obj = AerodynamicTorque()
            obj@Torque(Torques.aerodynamic);
        end
        
    end
    
end
