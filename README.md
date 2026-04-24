# Rocket Flight Simulator (Analytical)

Analytical MATLAB model for a solid rocket motor burnback and 2D flight simulation. 
The project estimates chamber pressure, thrust, propellant mass, Mach number, trajectory, 
and body forces for an annular acceleration grain with an optional cruise grain.

## Overview

The main workflow is script-based:

1. Define atmosphere, target mission, fuel, nozzle, grain, and vehicle values.
2. Run the annular/cylindrical burnback model to generate pressure, mass, and thrust data.
3. Use the thrust curve in a flight simulation.
4. Plot the resulting motor and flight performance.

Saved example figures are included in `figures/`.

## Requirements

- MATLAB
- Aerospace Toolbox, for `atmosisa`
- Symbolic Math Toolbox, for `syms` and `vpasolve`

## Quick Start

Open MATLAB in this repository folder and run:

```matlab
initialize
```

This executes the default simulation setup, including:

- `BurnbackSim_Annular.m`
- `FlightSim.m`
- `results.m`

The run produces figures for chamber pressure, thrust, propellant mass,
trajectory, Mach number, and forces.

## Main Files

- `initialize.m` - default entry point for a single rocket simulation.
- `BurnbackSim_Annular.m` - solves motor burnback and builds the thrust curve.
- `RocketSystem_Annular.m` - ODE model for annular grain pressure and burnback.
- `RocketSystem_Cylinder.m` - ODE model for the cruise/base grain.
- `FlightSim.m` - integrates the rocket's 2D flight state using the thrust
  history.
- `results.m` - creates diagnostic plots.
- `RocketFuel.m` - fuel property class used by the simulation and optimizers.
- `compute_drag.m`, `compute_lift.m`, `compute_diff.m` - helper functions for
  flight dynamics.

## Optimization Scripts

The repository also includes several optimization and comparison scripts:

- `Optimizer.m` - tests multiple fuel options against pressure and Mach targets.
- `Optimize_AeAtCruise.m` - estimates nozzle expansion ratio for cruise thrust.
- `OptimizeCruise*.m` - earlier or alternate cruise optimization scripts.
- `OptimizerResults.m` - plotting/analysis for optimizer output.
- `ResultBundle.m` - container class for optimizer results.

## Default Scenario

The default values in `initialize.m` model a rocket at approximately 21.3 km
altitude targeting Mach 3 cruise with an HTPB/AP 70% fuel option. Vehicle,
nozzle, and grain parameters are defined directly in the script, so changing a
case is usually done by editing `initialize.m` or one of the optimizer scripts.

## Notes

- Scripts share variables through the MATLAB workspace, so run them from the
  repository root unless you refactor them into functions.
- Several files contain commented historical configurations and validation
  cases.
- Units are SI unless otherwise noted.
