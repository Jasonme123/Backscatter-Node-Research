# Backscatter Node Research — PBR Simulator

MATLAB simulator for a phase-based ranging (PBR) backscatter system in the BLE 2.4 GHz band. A single reader at the origin estimates the range to N tags placed in 2D using one channel pair for PBR and the remaining channels for RSSI.

Run `Main_Simulation.m`. Old FMCW code is archived in `Old Code/`.

## Active files

### `Main_Simulation.m`
Top-level driver. Sets flags, loads params, places nodes, calls scenarios.

- `PLACEMENT_MODE`
- `N_TAGS`
- `RANGE_MIN`
- `RANGE_MAX`

### `sim_params.m`
Common parameters dropped into the workspace by the driver.

- `fc`, `BW`, `df`, `N_ch`, `freqs`
- `pbr_pair`, `rssi_idx`
- `link.Pt`, `link.refl`
- `P_noise`

### `placeNodes2D.m`
Function. Generates N `Node` objects at random 2D positions using a local RandStream.

- `N`
- `range_min`
- `range_max`
- `mode`

### `Node.m`
Class. Stores tag position.

- `x`, `y`
- `range` (dependent)

### `scenario_pbr_rssi.m`
Script. Simulates IQ on every channel; PBR pair + RSSI average; prints table; plots circles.

- Reads `nodes`, `true_d`, `freqs`, `df`, `N_ch`, `pbr_pair`, `rssi_idx`, `link`, `P_noise`, `RANGE_MAX`
- Writes `d_pbr`, `d_rssi`, `d_est_pbrrssi`

### `scenario_pbr_only.m`
Script. Simulates IQ on the PBR pair only; PBR range estimate; prints table; plots circles.

- Reads `nodes`, `true_d`, `freqs`, `df`, `pbr_pair`, `link`, `P_noise`, `RANGE_MAX`
- Writes `d_est_pbronly`

### `backscatter_link.m`
Function. One IQ sample for one tag at one frequency, with link budget + AWGN.

- Inputs: `d`, `f`, `link`, `P_noise`
- Outputs: `I`, `Q`, `Pr`

### `pbr_range.m`
Function. Single-pair phase-based range estimate.

- Inputs: `I1`, `Q1`, `I2`, `Q2`, `df`
- Output: `d_est`

### `rssi_range.m`
Function. Range estimate from RSSI on one or more channels (averaged).

- Inputs: `I`, `Q`, `freqs`, `link`
- Outputs: `d_est`, `d_per_ch`
