classdef Termination < jsonable
    properties
        meetAll
        conditions
    end
    
    methods
        function obj = Termination(meetAll,varargin)
            obj.meetAll = meetAll;
            obj.conditions = varargin;
        end
        
        function termination = and(obj1,obj2)
            if isa(obj1,'Termination') && isa(obj2,'Termination')
                if obj1.meetAll && obj2.meetAll
                    combinedConditions = horzcat(obj1.conditions{:},obj2.conditions{:});
                elseif obj1.meetAll
                    combinedConditions = horzcat(obj1.conditions{:},obj2);
                else
                    combinedConditions = horzcat(obj1,obj2);
                end
            else
                if isa(obj1,'Termination')
                    tobj = obj1;
                    cobj = obj2;
                else
                    tobj = obj2;
                    cobj = obj1;
                end
                if tobj.meetAll
                    combinedConditions = tobj.conditions;
                    combinedConditions{end+1} = cobj;
                else
                    combinedConditions = horzcat(tobj,cobj);
                end
            end
            termination = Termination(true,combinedConditions{:});
        end
        
        function termination = or(obj1,obj2)
            if isa(obj1,'Termination') && isa(obj2,'Termination')
                if ~obj1.meetAll && ~obj2.meetAll
                    combinedConditions = horzcat(obj1.conditions{:},obj2.conditions{:});
                elseif ~obj1.meetAll
                    combinedConditions = horzcat(obj1.conditions{:},obj2);
                else
                    combinedConditions = horzcat(obj1,obj2);
                end
            else
                if isa(obj1,'Termination')
                    tobj = obj1;
                    cobj = obj2;
                else
                    tobj = obj2;
                    cobj = obj1;
                end
                if ~tobj.meetAll
                    combinedConditions = tobj.conditions;
                    combinedConditions{end+1} = cobj;
                else
                    combinedConditions = horzcat(tobj,cobj);
                end
            end
            termination = Termination(false,combinedConditions{:});
        end
        
    end
    
    methods (Hidden)
        function j = jsonize(obj)
            c = json.jsonize(obj.conditions);
            if obj.meetAll
                j.allOf = c;
            else
                j.anyOf = c;
            end
        end
        
    end
    
end
