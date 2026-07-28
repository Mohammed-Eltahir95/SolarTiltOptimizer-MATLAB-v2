c# Requirements

- MATLAB R2023b or newer.
- Internet access for live PVGIS acquisition.
- MATLAB's `sqlite` interface for the local cache and results database.
- Optional PV_LIB (`pvl_ephemeris`) to reproduce the original script's preferred solar-position branch. Without it, the preserved fallback is used.

No Mapping, Statistics and Machine Learning, Optimization, or Parallel Computing Toolbox is required. The optimizer is the original exhaustive grid search.

