classdef Simulation < handle
    properties
        startEpoch
        endEpoch = '2016-12-31 23:59:59'
        globalFrameOrigin = 'SSB'
        globalFrameOrientation = 'ECLIPJ2000'
        spice
        bodies
        propagation
        integrator
        export
        options
    end
    properties (Access = protected)
        import
    end
    properties (SetAccess = protected)
        populatedjson
        % numericalSolution
        results
    end
    properties (Constant, Hidden)
        defaultInputFileName = '.temp.json';
        defaultPopulatedInputFileName = '.temp.populated.json';
        % defaultNumericalSolutionFileName = '.numericalSolution.txt';
    end
    
    methods
        function obj = Simulation(startEpoch,endEpoch,globalFrameOrigin,globalFrameOrientation)
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
        
        function obj = addResultsToExport(obj,varargin)
            N = length(varargin);
            if mod(N,2) ~= 0
                error('You must provide an even number of arguments: file1, output1, file2, output2...');
            end
            for i = 1:N/2
                [file,result] = getIDresult(i,varargin);
                obj.export{end+1} = Export(file,result);
            end
        end
        
        function obj = addResultsToImport(obj,varargin)
            N = length(varargin);
            if mod(N,2) ~= 0
                error('You must provide an even number of arguments: name1, output1, name2, output2...');
            end
            for i = 1:N/2
                [name,result] = getIDresult(i,varargin);
                obj.import{end+1} = Import(name,result);
                obj.export{end+1} = Export(['.' name '.txt'],result);
            end
        end
        
        function obj = run(obj)
            result = Result('state');
            result.epochsInFirstColumn = true;
            obj.addResultsToImport('numericalSolution',result);
            mainInputFile = Simulation.defaultInputFileName;
            obj.options.populatedFile = Simulation.defaultPopulatedInputFileName;
            json.export(obj,mainInputFile);
            if system([tudat.bin ' ' mainInputFile],'-echo') == 0
                obj.loadAuxiliaryFiles();
                obj.deleteAuxiliaryFiles();
            else
                error('Error while running Tudat.');
            end
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'startEpoch');
            s = json.update(s,obj,'endEpoch');
            s = json.update(s,obj,'globalFrameOrigin');
            s = json.update(s,obj,'globalFrameOrientation');
            s = json.update(s,obj,'spice',false);
            s = json.update(s,obj,'bodies');
            s = json.update(s,obj,'propagation');
            s = json.update(s,obj,'integrator');
            s = json.update(s,obj,'export',false);
            s = json.update(s,obj,'options',false);
        end
        
    end
    
    methods (Access = protected)
        function obj = loadAuxiliaryFiles(obj)
            obj.populatedjson = fileread(Simulation.defaultPopulatedInputFileName);
            % obj.numericalSolution = fileread(Simulation.defaultNumericalSolutionFileName);
            for i = 1:length(obj.import)
                importSettings = obj.import{i};
                name = importSettings.name;
                file = ['.' name '.txt'];
                eval(sprintf('obj.results.%s = load(file);',name));
            end
        end
        
        function obj = deleteAuxiliaryFiles(obj)
            delete(Simulation.defaultInputFileName);
            delete(Simulation.defaultPopulatedInputFileName);
            % delete(Simulation.defaultNumericalSolutionFileName);
            for i = 1:length(obj.import)
                delete(['.' obj.import{i}.name '.txt']);
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

