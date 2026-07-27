# Scientific implementation review

The refactor preserves the original equations and defaults for regression reproducibility. These findings are documented rather than silently corrected:

1. **Solar time:** the fallback uses `15 × (UTC hour − 12)` without longitude or equation-of-time corrections. This can shift incidence geometry. PV_LIB activates the original preferred ephemeris branch.
2. **Perez implementation:** the third coefficient is multiplied by zenith in degrees; published formulations commonly use radians. Changing it would alter results.
3. **Night/day treatment:** values are zeroed at `cos(zenith) <= 0.01`; daytime zeros become `0.001 W/m²`, stabilizing ratios but adding a small signal.
4. **Cleaning:** negative/non-finite values become zero and `DHI` is clipped to `GHI`, potentially hiding data-quality problems.
5. **TMY interpretation:** a TMY is representative synthetic months, not one observed historical year; it cannot characterize interannual uncertainty.
6. **Benchmarking:** Perez is a benchmark, not ground truth. Reported errors measure model disagreement.
7. **Resolution:** the deterministic grid is 0–90° in 1° steps, not continuous optimization.
8. **Assumptions:** south azimuth (180°) and albedo 0.20 are fixed defaults.
9. **Uncertainty:** measurement, reanalysis, and parameter uncertainty are not propagated.
10. **PVGIS normalization:** when necessary, DNI is derived from horizontal beam irradiance and PVGIS sun height; the transformation and provenance are stored.
11. **PVGIS TMY database selection:** PVGIS 5.3 documents database selection for hourly series, but its TMY API contract does not expose `raddatabase`; TMY results therefore use the service-selected database and must not automatically be described as ERA5.

Future scientific changes should be separately versioned: validated solar position, literature-audited equations, explicit missing-data policy, sensitivity analysis, and comparison with measured POA irradiance.
