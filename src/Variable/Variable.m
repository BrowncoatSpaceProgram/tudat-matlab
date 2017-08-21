classdef Variable < jsonable
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
        
        function set.type(obj,value)
            if ~isa(value,'Variables')
                value = Variables(value);
            end
            obj.type = char(value);
        end
        
        function set.dependentVariableType(obj,value)
            if ~isa(value,'DependentVariables')
                value = DependentVariables(value);
            end
            obj.dependentVariableType = char(value);
        end
        
        function set.accelerationType(obj,value)
            if ~isa(value,'Accelerations')
                value = Accelerations(value);
            end
            obj.accelerationType = char(value);
        end
        
        function set.torqueType(obj,value)
            if ~isa(value,'Torques')
                value = Torques(value);
            end
            obj.torqueType = char(value);
        end
        
        function condition = lt(obj1,obj2)
            condition = Condition();
            if isa(obj1,'Variable')
                condition.variable = obj1;
                condition.lowerLimit = obj2;
            else
                condition.variable = obj2;
                condition.upperLimit = obj1;
            end
        end
        
        function condition = gt(obj1,obj2)
            condition = obj2 < obj1;
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
end
