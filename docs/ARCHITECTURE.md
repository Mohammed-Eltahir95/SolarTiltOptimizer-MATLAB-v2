# Architecture

`run_project.m` loads JSON configuration and calls `solartilt.runStudy`. The `+data` package handles PVGIS and user files, the numerical package performs the preserved transposition and optimization, and `+db` provides SQLite provenance, caching, and run persistence. Reporting consumes tidy annual, monthly, seasonal, and statistics tables.

This separation makes data acquisition replaceable without altering the scientific engine. PVGIS requests are keyed by product, database, period, and coordinates; completed runs retain configuration and results.

