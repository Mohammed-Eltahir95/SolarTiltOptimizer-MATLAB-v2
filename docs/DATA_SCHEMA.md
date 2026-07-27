# Canonical weather schema

| Column | Required | Unit | Meaning |
|---|---:|---|---|
| `timestamp` | yes | UTC datetime | Unique, ascending observation time |
| `latitude`, `longitude` | yes* | degrees | Added from location config when omitted |
| `ghi`, `dni`, `dhi` | yes | W/m² | Horizontal global, direct normal, horizontal diffuse irradiance |
| `temperature` | no | °C | Air temperature |
| `wind_speed` | no | m/s | Wind speed |
| `pressure` | no | Pa | Surface pressure |
| `relative_humidity` | no | % | Relative humidity |
| `source`, `quality_flag` | no | text | Provenance and QA fields |

Names are case-insensitive. Aliases include `time`, `T2m`, `WS10m`, `SP`, `RH`, and `long`.

