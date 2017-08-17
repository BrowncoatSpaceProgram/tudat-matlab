classdef Termination < handle
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
                    combinedConditions = horzcat(obj1.conditions,obj2.conditions);
                else
                    combinedConditions = { obj1, obj2 };
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
                    combinedConditions = { tobj, cobj };
                end
            end
            termination = Termination(true,combinedConditions{:});
        end
        
        function termination = or(obj1,obj2)
            if isa(obj1,'Termination') && isa(obj2,'Termination')
                if ~obj1.meetAll && ~obj2.meetAll
                    combinedConditions = horzcat(obj1.conditions,obj2.conditions);
                else
                    combinedConditions = { obj1, obj2 };
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
                    combinedConditions = { tobj, cobj };
                end
            end
            termination = Termination(false,combinedConditions{:});
        end
        
        function s = struct(obj)
            c = json.struct(obj.conditions);
            if obj.meetAll
                s.allOf = c;
            else
                s.anyOf = c;
            end
        end
        
    end
    
end
