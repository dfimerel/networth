# Net Worth Tracker

A simple offline personal net worth dashboard built with R Shiny.

## Features

- Current net worth
- Total assets
- Liabilities
- Liquid wealth
- Net worth history
- Asset allocation
- Individual assets and accounts
- Net worth projection
- Monthly investment contributions

## Project Structure

```text
networth-tracker/
├── app.R
├── ui.R
├── server.R
├── global.R
└── README.md
```

## Excel File

The dashboard reads an Excel file containing these columns:

| Date | Asset / Liability | Category | Type | Value |
|---|---|---|---|---:|
| 31/01/2026 | Checking | Cash | Asset | 5000 |
| 31/01/2026 | Savings | Savings | Asset | 20000 |
| 31/01/2026 | ETF | Investments | Asset | 30000 |
| 31/01/2026 | Apartment | Real Estate | Asset | 500000 |

`Type` must be either `Asset` or `Liability`.

Multiple rows can have the same date and category. For example, multiple Cash accounts or Investment accounts are supported.

## Running the Dashboard

1. Open the `networth-tracker` project folder in Positron/RStudio.
2. Open the **Console** in Positron.
3. Run:

```r
shiny::runApp()
```

4. Positron will start the Shiny application and open the dashboard in a browser window.
5. Click **Choose Excel file** and select your Excel file.

To stop the dashboard, stop the running R process in Positron.

The dashboard uses the latest date in the Excel file for the current financial position.

## Projection

The projection allows separate annual growth assumptions for:

- Cash
- Savings
- Investments
- Real Estate
- Other

A monthly investment contribution can also be entered.

The projection is an estimate based on the assumptions entered in the dashboard.

## Privacy

The application runs locally on your Mac and does not require an internet connection.

Financial data is read directly from the Excel file and is not uploaded to an external service.
