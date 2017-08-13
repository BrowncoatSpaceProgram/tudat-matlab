classdef Variable
    properties
        type
        body
        dependentVariableType
        relativeToBody
        accelerationType
        torqueType
        bodyExertingAcceleration
        bodyExertingTorque
    end
    
    methods
        function obj = Variable(var)
            if isa(var,'Variable')
                obj = var;
            elseif isa(var,'Variables')
                obj.type = var;
            elseif isa(var,'DependentVariables')
                obj.dependentVariableType = var;
            else
                parts = split(var,'.');
                if length(parts) == 1
                    obj.type = var;
                else
                    obj.body = parts{1};
                    subparts = split(parts{2},'-');
                    secondaryBody = [];
                    if length(subparts) > 1
                        secondaryBody = subparts{end};
                    end
                    subparts = split(subparts{1},'@');
                    obj.dependentVariableType = subparts{1};
                    if any(strcmp(obj.dependentVariableType,...
                            {char(DependentVariables.acceleration),char(DependentVariables.accelerationNorm)}))
                        obj.bodyExertingAcceleration = secondaryBody;
                        obj.accelerationType = Accelerations(subparts{2});
                    elseif any(strcmp(obj.dependentVariableType,...
                            {char(DependentVariables.torque),char(DependentVariables.torqueNorm)}))
                        obj.bodyExertingTorque = secondaryBody;
                        obj.torqueType = Torques(subparts{2});
                    else
                        obj.relativeToBody = secondaryBody;
                    end
                end
            end
        end
        
        function obj = set.type(obj,value)
            if ~isa(value,'Variables')
                value = Variables(value);
            end
            obj.type = char(value);
        end
        
        function obj = set.dependentVariableType(obj,value)
            if ~isa(value,'DependentVariables')
                value = DependentVariables(value);
            end
            obj.dependentVariableType = char(value);
        end
        
        function obj = set.accelerationType(obj,value)
            if ~isa(value,'Accelerations')
                value = Accelerations(value);
            end
            obj.accelerationType = char(value);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type',false);
            s = json.update(s,obj,'body',false);
            s = json.update(s,obj,'dependentVariableType',false);
            s = json.update(s,obj,'relativeToBody',false);
            s = json.update(s,obj,'bodyExertingAcceleration',false);
            s = json.update(s,obj,'accelerationType',false);
            s = json.update(s,obj,'bodyExertingTorque',false);
            s = json.update(s,obj,'torqueType',false);
        end
        
    end
end
