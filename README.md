# SolarTiltOptimizer-MATLAB

A reproducible MATLAB pipeline for fixed solar-panel tilt optimization with eight diffuse-radiation transposition models: Liu–Jordan, Badescu, Klucher, Perez, Hay–Davies, HDKR, Koronakis, and Temps–Coulson.

## Quick start

Open MATLAB R2023b or newer in this folder, run `setup`, then `run_project`. The default JSON requests PVGIS TMY data for Wadi Halfa, Dongola, Khartoum, and Port Sudan. `config/hourly_era5_example.json` explicitly requests the distinct PVGIS-ERA5 2005–2023 hourly product. Downloads are cached in SQLite.

Set `dataSource.type` to `pvgis`, `csv`, or `excel`. File imports follow [the canonical schema](docs/DATA_SCHEMA.md). Users may select any subset of the eight models.

## Outputs

- Tidy annual, monthly, seasonal, gain, ranking, and Perez-relative statistics tables
- English PNG figures
- SQLite request provenance, normalized weather, configurations, and results when MATLAB's `sqlite` interface is available
- Cross-location model rankings, gain metrics, and a dependency-free location map

The cleaning rules, 1° grid search, Perez benchmark, and seasons are preserved from the original script. The Perez coefficient calculation and PVGIS TMY time alignment include documented correctness fixes; see [the scientific review](SCIENTIFIC_REVIEW.md).

The PVGIS API chooses the radiation source for its TMY endpoint; the historical
configuration explicitly requests PVGIS-ERA5 for 2005–2023. Keep the two
products distinct when interpreting or citing results.

PVGIS TMY source-year timestamps are normalized to a continuous representative
year, and the API-provided irradiance time offset is applied before solar-position
calculations. This keeps hourly integration and irradiance geometry aligned.

Run tests:

```matlab
addpath('src'); results = runtests('tests','IncludeSubfolders',true); assertSuccess(results)
```

## Author

Mohammed Eltahir — Karabük University  
2228132324@ogrenci.karabUk.edu.tr 



## Terms

Copyright © 2026 Mohammed Eltahir. All rights reserved. Inspection is permitted for portfolio and academic evaluation; reuse, modification, redistribution, or research/commercial execution requires prior written permission. See `LICENSE.txt`.

PVGIS is a European Commission Joint Research Centre service and remains subject to its provider terms and attribution requirements.
