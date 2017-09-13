# tudat-matlab
MATLAB interface for Tudat

## Installation

Successfully tested on macOS Sierra. **Not tested on Windows or Linux yet.**

1. Clone this repository and its submodules recursively: 
    ```
    git clone --recursive https://github.com/aleixpinardell/tudat-matlab
    ```

2. Install [CMake](https://cmake.org).

3. After choosing a definitive location (and name) for your tudat-matlab folder, run the script [`setup.m`](setup.m).

During the set-up process, the required targets will be compiled using CMake, which will take several minutes. If you want to use MATLAB while this process runs, open an additional isntance of MATLAB before running the script.

If the installation is successful, the units tests will start running. If any of the tests fails, open an issue for each.

If you want to move, rename or delete your tudat-matlab directory, remove it first from MATLAB's path by using `pathtool`.


## Usage

In this section, the steps to simulate the unperturbed motion of a satellite about the Earth will be described.

The first step is to include the paths to tudat-matlab source code in the current MATLAB session so that you can use all the classes needed to set up the simulation. You do this by writing in a new script:
```
tudat.load();
```

Now, you can create a `Simulation` object and specify the initial (and final) epoch:
```
simulation = Simulation();
simulation.initialEpoch = convert.dateToEpoch('1992-02-14 06:00');
simulation.finalEpoch = convert.dateToEpoch('1992-02-14 12:00');
```

If you want to load automatically the ephemeris and properties of bodies such as the Sun, Earth, the Moon and other planets, you will need to use Spice. For a simple propagation, you do this by specifying the following Spice kernels:
```
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
```

Next, you need to create the bodies. For an unperturbed orbit, the mass of the satellite is irrelevant, so we create a body named 'satellite' with the following initial state:
```
satellite = Body('satellite');
satellite.initialState.semiMajorAxis = 7500e3;
satellite.initialState.eccentricity = 0.1;
satellite.initialState.inclination = deg2rad(5);
```

Note that some of the Keplerian components have been omitted, and thus they are assumed to be zero.

Now, you add the bodies to the simulation by calling the method `addBodies` of your `simulation` object. There exist predefined objects for celestial bodies (namely the Sun, the Moon and the eight planets), so these objects can be added directly without the need to specify their properties:
```
simulation.addBodies(Earth,satellite);
```

Then, you will create the settings for the propagation. We are going to propagate the translational state of the body `satellite` about `Earth`. Thus, we will use a `TranslationalPropagator`:
```
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = satellite;
```

Now we need to specify the accelerations acting on `satellite`. The only accelerations are those caused by `Earth`, so we need to specify the property `propagator.accelerations.satellite.Earth`, which can be read as "accelerations on satellite caused by Earth". In the case of an unperturbed orbit, the only acceleration is the point-mass gravitational attraction of the central body:
```
propagator.accelerations.satellite.Earth = PointMassGravity();
```

Finally, we add the `propagator` to the `simulation` object and define the integrator settings:
```
simulation.propagator = propagator;
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 20;
```
In this case we use a Runge-Kutta 4 integrator with a fixed step-size of 20 seconds.

Now, the simulation is set up and you can proceed in two different ways.


### Usage modes

* **SL mode** (seamless mode). You use tudat-matlab to set up simulations that will be run directly from your MATLAB script. Temporary input and output files will be genereated and deleted by tudat-matlab in the background. When the simulation completes, you will be able to access the results directly in the property `results` of your `Simulation` object. You can use this data to generate plots and eventually consolidate (parts of) it in a text file.
* **IO mode** (input-output mode). You use tudat-matlab to set up simulations and to generate JSON input files that will then be provided to the `tudat` binary manually, i.e. from the command line. You must specify the output files to generate by using the `addResultsToExport` of your `Simulation` object. Then, the generated output files can be opened with your favorite text editor and/or loaded into MATLAB for post-processing and plotting.

These modes are not mutually exclusive, i.e. you can run your simulations from MATLAB and still get to keep the input and output files in your directory. In the following two sub-sections, the two modes are briefly described.


#### SL mode

After setting up your simulation by following the steps described in [Usage](#usage), the only thing you have to do is write:
```
simulation.run();
```

After running the simulation, you can access the full settings (including the default values) that have been used by Tudat as JSON-formatted text:
```
simulation.fullSettings
```

Now, you are able to access the requested results at the `results` property of your `simulation` object. In addition to the requested results (in this case no results were requested), you are always able to access the property `results.numericalSolution`, which is a matrix in which each row corresponds to an integration step. The first column contains the value of the independent variable (the epoch in this case) and the other columns contain the state (the Cartesian components of `satellite`). You can decompose this matrix into epoch and position by writing:
```
t = simulation.results.numericalSolution(:,1);
r = simulation.results.numericalSolution(:,2:4);
```

Finally, you can run MATLAB commands on your results as usual:
```
plot(convert.epochToDate(t),r/1e3);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;
```


#### IO mode

After setting up your simulation by following the steps described in [Usage](#usage), you have to specify the output files that you want to generate. Otherwise, when running `tudat`, the simulation will be completed but no output will be generated. You do this by writing:
```
simulation.addResultsToExport(fullfile('..','OUTPUT','results.txt'),{'independent','state'});
```
Note that the paths are relative to the input file.

In this case, after the simulation is completed, a text file will be generated, containing a matrix in which each row will correspond to an integration step. The first column will contain the value of the independent variable (the epoch in this case) and the other columns will contain the state (the Cartesian components of `satellite`).

Optionally, you can specify to generate an input file containing all the data loaded from Spice and all the default values used for keys that have not been specified (note that this file will be generated when you run `tudat`). You do this by writing:

```
simulation.options.fullSettingsFile = 'fullSettings.json';
```

Now, you need to generate the JSON input file that will be provided to the `tudat` binary as command-line argument. You do this by using the `json` package of tudat-matlab:
```
json.export(simulation,fullfile('INPUT','main.json'));
```

At this point, after running your script, you can run `tudat` with the file 'INPUT/main.json' generated in your working directory, by writing in the command line:
```
tudatBinaryPath inputFilePath
```

The files 'fullSettings.json' and 'results.txt' will be generated in the 'INPUT' and 'OUTPUT' directories, respectively. Now, in MATLAB, you can post-process the results as usual:
```
results = import.results(fullfile('OUTPUT','results.txt'),'warn');
t = results(:,1);
r = results(:,2:4);
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;
```
Note the use of the function `epochToDate` from tudat-matlab's `convert` package, which converts seconds from J2000 to a MATLAB `datetime`; and the function `import.results`, which can return a variable number of arguments. The first one is a matrix containing the data from the specified file. The second one, if requested, is a `bool` indicating whether the propagation failed (when the propagation terminates before reaching the termination condition, in this case the end epoch `'1992-02-14 12:00'`, the output files contain in the header line the word `FAILURE` by default, which is detected by the `import.results` function). If the argument `'warn'` is provided to the function, it will print a warning when reading a results file that contains the word `FAILURE` in the first line.
