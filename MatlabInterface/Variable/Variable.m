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
        baseFrame
        targetFrame
        angle
        componentIndex
    end
    
    methods
        function obj = Variable(var)
            if nargin >= 1
                if isa(var,'Variable')
                    obj = var;
                elseif isa(var,'Variables')
                    obj.type = var;
                elseif isa(var,'DependentVariables')
                    obj.dependentVariableType = var;
                else
                    [~,tok] = regexp(var,'(.+?)\((\d+)\)','match','tokens');
                    if ~isempty(tok)
                        var = tok{1}{1};
                        obj.componentIndex = str2double(tok{1}{2}) - 1;
                    else
                        [~,tok] = regexp(var,'(.+?)\[(\d+)\]','match','tokens');
                        if ~isempty(tok)
                            var = tok{1}{1};
                            obj.componentIndex = str2double(tok{1}{2});
                        end
                    end
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
                        if obj.dependentVariableType == DependentVariables.acceleration ...
                                || obj.dependentVariableType == DependentVariables.accelerationNorm
                            obj.bodyExertingAcceleration = secondaryBody;
                            obj.accelerationType = subparts{2};
                        elseif obj.dependentVariableType == DependentVariables.torque ...
                                || obj.dependentVariableType == DependentVariables.torqueNorm
                            obj.bodyExertingTorque = secondaryBody;
                            obj.torqueType = subparts{2};
                        else
                            obj.relativeToBody = secondaryBody;
                        end
                    end
                end
            end
            
        end
        
        function set.type(obj,value)
            if ~isa(value,'Variables')
                value = Variables(value);
            end
            obj.type = value;
        end
        
        function set.dependentVariableType(obj,value)
            if ~isa(value,'DependentVariables')
                value = DependentVariables(value);
            end
            obj.dependentVariableType = value;
        end
        
        function set.accelerationType(obj,value)
            if ~isa(value,'Accelerations')
                value = Accelerations(value);
            end
            obj.accelerationType = value;
        end
        
        function set.torqueType(obj,value)
            if ~isa(value,'Torques')
                value = Torques(value);
            end
            obj.torqueType = value;
        end
        
        function bodyName = get.body(obj)
            if isa(obj.body,'Body')
                bodyName = obj.body.name;
            else
                bodyName = obj.body;
            end
        end
        
        function bodyName = get.relativeToBody(obj)
            if isa(obj.relativeToBody,'Body')
                bodyName = obj.relativeToBody.name;
            else
                bodyName = obj.relativeToBody;
            end
        end
        
        function bodyName = get.bodyExertingAcceleration(obj)
            if isa(obj.bodyExertingAcceleration,'Body')
                bodyName = obj.bodyExertingAcceleration.name;
            else
                bodyName = obj.bodyExertingAcceleration;
            end
        end
        
        function bodyName = get.bodyExertingTorque(obj)
            if isa(obj.bodyExertingTorque,'Body')
                bodyName = obj.bodyExertingTorque.name;
            else
                bodyName = obj.bodyExertingTorque;
            end
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
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
end
