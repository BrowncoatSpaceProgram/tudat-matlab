classdef Simulation < handle
    properties
        startEpoch
        endEpoch
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
    properties (Dependent)
        propagators
    end
    properties (Access = protected)
        import
    end
    properties (SetAccess = protected)
        populatedjson
        results
    end
    properties (Constant, Hidden)
        defaultInputFileName = 'temp.json';
        defaultPopulatedInputFileName = 'temp.populated.json';
        defaultResultFileName = 'temp.results.%s.txt';
    end
    
    methods
        function obj = Simulation(startEpoch,endEpoch,globalFrameOrigin,globalFrameOrientation)
            if nargin >= 1
                obj.startEpoch = startEpoch;
                if nargin >= 2
                    obj.endEpoch = endEpoch;
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
                elseif ischar(body)
                    newBody = Body(body);
                    newBody.useDefaultSettings = true;
                    obj.bodies.(body) = newBody;
                else
                    error('Could not add body to simulation.');
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
        
        function obj = addResultsToImport(obj,varargin)
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
            obj.addResultsToImport('numericalSolution',result);
            mainInputFile = Simulation.defaultInputFileName;
            if isempty(obj.options)
                obj.options = Options();
            end
            obj.options.populatedFile = Simulation.defaultPopulatedInputFileName;
            json.export(obj,mainInputFile);
            
            exitSuccess = system([tudat.bin ' ' mainInputFile],'-echo') == 0;
            if exitSuccess
                obj.loadAuxiliaryFiles();
            end
            obj.deleteAuxiliaryFiles();
            if ~exitSuccess
                error('Error while running Tudat.');
            end
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'startEpoch',false);
            s = json.update(s,obj,'endEpoch',false);
            s = json.update(s,obj,'globalFrameOrigin',false);
            s = json.update(s,obj,'globalFrameOrientation',false);
            s = json.update(s,obj,'spice',false);
            s = json.update(s,obj,'bodies');
            s = json.update(s,obj,'propagator');
            s = json.update(s,obj,'termination',false);
            s = json.update(s,obj,'integrator');
            s = json.update(s,obj,'export',false);
            s = json.update(s,obj,'options',false);
        end
        
    end
    
    methods (Access = protected)
        function obj = loadAuxiliaryFiles(obj)
            obj.populatedjson = fileread(obj.options.populatedFile);
            for i = 1:length(obj.import)
                importSettings = obj.import{i};
                name = importSettings.name;
                file = sprintf(Simulation.defaultResultFileName,name);
                eval(sprintf('obj.results.%s = load(file);',name));
            end
        end
        
        function obj = deleteAuxiliaryFiles(obj)
            filesystem.deleteFile(Simulation.defaultInputFileName);
            filesystem.deleteFile(Simulation.defaultPopulatedInputFileName);
            for i = 1:length(obj.import)
                filesystem.deleteFile(sprintf(Simulation.defaultResultFileName,obj.import{i}.name));
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

