# tudat-matlab
MATLAB interface for Tudat

## Installation

1. Clone or download [tudatBundle-json](http://github.com/aleixpinardell/tudatBundle/tree/json) ([see how](http://tudat.tudelft.nl/installation/)).
2. Compile the target `tudat`.
3. Clone or download this repository.
4. Run the MATLAB script `quickinstall.m`.
5. You will be prompted to provide the path to the `tudatBundle` folder you downloaded in step 1. You can skip this step by pressing `return` if you are planning to use tudat-matlab only in IO mode (see [Usage modes](#usage-modes)). You can specify the `tudatBundle` path later by calling `tudat.find('tudatBundlePath')` from MATLAB's Command Window.

## Usage

In this section, the steps to simulate the unperturbed motion of a satellite about the Earth will be described.

The first step is to include the paths to tudat-matlab source code in the current MATLAB session so that you can use all the classes needed to set up the simulation. You do this by writing in a new script:
```
tudat.load();
```

Now, you can create a `Simulation` object by writing:
```
simulation = Simulation('1992-02-14 06:00','1992-02-14 12:00');
```

If you want to load automatically the ephemeris and properties of bodies such as the Sun, Earth, the Moon and other planets, you will need to use Spice. For a simple propagation, you do this by specifying the following Spice kernels:
```
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
```

Next, you need to create the bodies. For an unperturbed orbit, the mass of the satellite is irrelevant, so we create a body named 'satellite' with the following initial state:
```
satellite = Body('satellite');
satellite.initialState.semiMajorAxis = '7500 km';
satellite.initialState.eccentricity = 0.1;
satellite.initialState.inclination = '5 deg';
```

Note that some of the Keplerian components have been omitted, and thus they are assumed to be zero. Also note that it is possible to provide the values is units other than SI units, by providing a string following the structure `'value units'`.

Now, you add the bodies to the simulation by calling the method `addBodies` of your `simulation` object. There exist predefined objects for celestial bodies (namely the Sun, the Moon and the eight planets), so these objects can be added directly without the need to specify their properties:
```
simulation.addBodies(Earth,satelliteBody);
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
* **IO mode** (input-output mode). You use tudat-matlab to set up simulations and to generate JSON input files that will then be provided to the `tudat` binary. Then, the generated output files can be opened with your favorite text editor and/or loaded into MATLAB for post-processing and plotting.

These modes are not mutually exclusive, i.e. you can run your simulations from MATLAB and still get to keep the input and output files in your directory. In the following two sub-sections, the two modes are briefly described.


#### SL mode

After setting up your simulation by following the steps described in [Usage](#usage), the only thing you have to do is write:
```
simulation.run();
```

Now, you are able to access the requested results at the `results` property of your `simulation` object. In addition to the requested results (in this case no results were requested), you are always able to access the property `results.numericalSolution`, which is a matrix in which each row corresponds to an integration step. The first column contains the value of the independent variable (the epoch in this case) and the other columns contain the state (the Cartesian components of `satellite`). You can decompose this matrix into epoch, position and velocity by writing:
```
[t,r,v] = compute.epochPositionVelocity(simulation.results.numericalSolution);
```

Finally, you can run MATLAB command on your results as usual:
```
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;
```


#### IO mode

After setting up your simulation by following the steps described in [Usage](#usage), you have to specify the output files that you want to generate. Otherwise, when running `tudat`, the simulation will be completed but no output will be generated. You do this by writing:
```
simulation.addResultsToExport('results.txt',{'independent','state'});
```

In this case, after the simulation is completed, a text file will be generated, containing a matrix in which each row will correspond to an integration step. The first column will contain the value of the independent variable (the epoch in this case) and the other columns will contain the state (the Cartesian components of `satellite`).

Optionally, you can specify to generate an input file containing all the data loaded from Spice and all the default values used for keys that have not been specified, also known as a populated input file (note that this file will be generated when you run `tudat`). You do this by writing:

```
simulation.options.populatedFile = 'unperturbedSatellite-populated.json';
```

Now, you need to generate the JSON input file that will be provided to the `tudat` binary as command-line argument. You do this by using the `json` package of tudat-matlab:
```
json.export(simulation,'unperturbedSatellite.json');
```

At this point, after running your script, you can run `tudat` with the file 'unperturbedSatellite.json' generated in your working directory, by writing in the command line:
```
tudatBinaryPath unperturbedSatelliteInputFilePath
```

The files 'unperturbedSatellite-populated.json' and 'results.txt' will be generated next to your 'unperturbedSatellite.json'. Now, in MATLAB, you can post-process the results as usual:
```
[results,failed] = loadResults('results.txt');
if failed
    warning('Propagation failed: plotting results obtained until propagation failure.');
end
t = results(:,1);
r = results(:,2:4);
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;
```
Note the use of the function `epochToDate` from tudat-matlab's `convert` package, which converts seconds from J2000 to a MATLAB `datetime`; and the function `loadResults`, which returns the results from the specified file and, in addition, a `bool` indicating whether the propagation failed (when the propagation terminates before reaching the termination condition, in this case the end epoch `'1992-02-14 12:00'`, the output files contain in the header line the word `FAILURE` by default, which is detected by the `loadResults` function).
