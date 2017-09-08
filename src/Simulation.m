classdef Simulation < jsonable
    properties
        initialEpoch
        finalEpoch
        globalFrameOrigin
        globalFrameOrientation
        spice
        bodies
        propagator
        termination
        integrator
        export
        options
    end
    properties (Transient, Dependent)
        propagators
    end
    properties (Transient, Access = protected)
        import
    end
    properties (Transient, SetAccess = protected)
        fullSettings
        results
    end
    properties (Transient, Constant, Hidden)
        defaultInputFileName = 'temp.json';
        defaultFullSettingsFileName = 'temp_full.json';
        defaultResultFileName = 'temp_results_%s.txt';
    end
    
    methods
        function obj = Simulation(initialEpoch,finalEpoch,globalFrameOrigin,globalFrameOrientation)
            obj.integrator = Integrator();
            obj.spice = Spice();
            obj.options = Options();
            if nargin >= 1
                obj.initialEpoch = initialEpoch;
                if nargin >= 2
                    obj.finalEpoch = finalEpoch;
                    if nargin >= 3
                        obj.globalFrameOrigin = globalFrameOrigin;
                        if nargin >= 4
                            obj.globalFrameOrientation = globalFrameOrientation;
                        end
                    end
                end
            end
        end
        
        function obj = addBodies(obj,varargin)
            for i = 1:length(varargin)
                body = varargin{i};
                if isa(body,'Body')
                    obj.bodies.(body.name) = body;
                else
                    error('Could not add body to simulation because it does not derive from class Body');
                end
            end
        end
        
        function set.propagators(obj,value)
            obj.propagator = value;
        end
        
        function value = get.propagators(obj)
            value = obj.propagator;
        end
        
        function obj = addResultsToExport(obj,varargin)
            N = length(varargin);
            if mod(N,2) ~= 0
                error('You must provide an even number of arguments: file1, output1, file2, output2...');
            end
            for i = 1:N/2
                [file,result] = getIDresult(i,varargin);
                J = length(obj.export) + 1;
                for j = i:length(obj.export)
                    if strcmp(obj.export{j}.file,file)
                        J = j;
                        break;
                    end
                end
                obj.export{J} = Export(file,result);
            end
        end
        
        function obj = addResultsToSave(obj,varargin)
            N = length(varargin);
            if mod(N,2) ~= 0
                error('You must provide an even number of arguments: name1, output1, name2, output2...');
            end
            for i = 1:N/2
                [name,result] = getIDresult(i,varargin);
                J = length(obj.import) + 1;
                for j = i:length(obj.import)
                    if strcmp(obj.import{j}.name,name)
                        J = j;
                        break;
                    end
                end
                obj.import{J} = Import(name,result);
                obj.addResultsToExport(sprintf(Simulation.defaultResultFileName,name),result);
            end
        end
        
        function obj = run(obj)
            result = Result('state');
            result.epochsInFirstColumn = true;
            obj.addResultsToSave('numericalSolution',result);
            mainInputFile = Simulation.defaultInputFileName;
            if isempty(obj.options.fullSettingsFile)
                obj.options.fullSettingsFile = Simulation.defaultFullSettingsFileName;
            end
            json.export(obj,mainInputFile);
            
            exitSuccess = system([tudat.binary ' ' mainInputFile],'-echo') == 0;
            if exitSuccess
                obj.loadAuxiliaryFiles();
            end
            obj.deleteAuxiliaryFiles();
            if ~exitSuccess
                error('Error while running Tudat.');
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'bodies','propagator','integrator'};
        end
        
    end
    
    methods (Access = protected)
        function obj = loadAuxiliaryFiles(obj)
            obj.fullSettings = fileread(obj.options.fullSettingsFile);
            for i = 1:length(obj.import)
                importSettings = obj.import{i};
                name = importSettings.name;
                file = sprintf(Simulation.defaultResultFileName,name);
                eval(sprintf('obj.results.%s = import.results(file);',name));
            end
        end
        
        function obj = deleteAuxiliaryFiles(obj)
            deleteIfExists(Simulation.defaultInputFileName);
            deleteIfExists(Simulation.defaultFullSettingsFileName);
            for i = 1:length(obj.import)
                deleteIfExists(sprintf(Simulation.defaultResultFileName,obj.import{i}.name));
            end
        end
        
    end
    
end


function [ID,result] = getIDresult(i,elements)

ID = elements{2*i-1};
result = elements{2*i};
if ~iscell(result)
    result = { result };
end
result = Result(result{:});

end


function deleteIfExists(file)

if exist(file,'file') == 2
    delete(file);
end

end
