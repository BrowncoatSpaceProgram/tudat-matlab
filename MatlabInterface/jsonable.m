classdef jsonable < handle
    methods (Hidden)
        function props = getProperties(obj)
            mc = metaclass(obj);
            p = {mc.PropertyList.Name};
            t = {mc.PropertyList.Transient};
            props = {};
            for i = 1:length(p)
                if ~t{i}
                    props{end+1} = p{i};
                end
            end
        end
        
        function mandatory = isMandatory(obj,property)
            mandatory = any(strcmp(property,getMandatoryProperties(obj)));
        end
        
        function p = isPath(obj,property)
            p = false;
        end
        
        function fs = formatSpec(obj,property)
            if isPath(obj,property)
                fs = '@path(%s)';
            else
                fs = '';
            end
        end
        
        function empty = isempty(obj)
            props = getProperties(obj);
            for i = 1:length(props)
                if ~isempty(obj.(props{i}))
                    empty = false;
                    return;
                end
            end
            empty = true;
        end
        
        function j = jsonize(obj)
            j = [];
            propertyNames = getProperties(obj);
            for i = 1:length(propertyNames)
                propertyName = propertyNames{i};
                j = json.update(j,obj,propertyName,isMandatory(obj,propertyName),formatSpec(obj,propertyName));
            end
        end
        
        % Horizontal concatenation creates cell array
        function cell = horzcat(varargin)
            cell = varargin;
        end

        % Vertical concatenation creates cell array
        function cell = vertcat(varargin)
            cell = varargin;
        end
        
        % Make methods inherited from handle Hidden
        
        function lh = addlistener(varargin)
            lh = addlistener@handle(varargin{:});
        end
        function notify(varargin)
            notify@handle(varargin{:});
        end
        function delete(varargin)
            delete@handle(varargin{:});
        end
        function Hmatch = findobj(varargin)
            Hmatch = findobj@handle(varargin{:});
        end
        function p = findprop(varargin)
            p = findprop@handle(varargin{:});
        end
        function TF = eq(varargin)
            TF = eq@handle(varargin{:});
        end
        function TF = ne(varargin)
            TF = ne@handle(varargin{:});
        end
        function TF = lt(varargin)
            TF = lt@handle(varargin{:});
        end
        function TF = le(varargin)
            TF = le@handle(varargin{:});
        end
        function TF = gt(varargin)
            TF = gt@handle(varargin{:});
        end
        function TF = ge(varargin)
            TF = ge@handle(varargin{:});
        end
        
    end
    
end
