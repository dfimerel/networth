library(shiny)

fluidPage(

  # ==========================================================
  # STYLING
  # ==========================================================

  tags$head(
    tags$style(HTML("

      * {
        box-sizing: border-box;
      }

      body {
        margin: 0;
        background: #f5f5f7;
        color: #1d1d1f;
        font-family:
          -apple-system,
          BlinkMacSystemFont,
          'SF Pro Display',
          'SF Pro Text',
          Helvetica,
          Arial,
          sans-serif;
      }

      .container-fluid {
        max-width: 1450px;
        padding: 30px 42px 55px;
      }

      /* HEADER */

      .topbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 28px;
      }

      .brand {
        font-size: 27px;
        font-weight: 700;
        letter-spacing: -1px;
      }

      .brand-subtitle {
        color: #86868b;
        font-size: 13px;
        margin-top: 3px;
      }

      .date-display {
        color: #86868b;
        font-size: 13px;
        text-align: right;
      }

      /* EXCEL INPUT */

      .data-bar {
        background: #ffffff;
        border: 1px solid #e5e5e7;
        border-radius: 16px;
        padding: 14px 18px;
        margin-bottom: 16px;
      }

      .data-bar .form-group {
        margin-bottom: 0;
      }

      .data-bar .form-control {
        border: none;
        box-shadow: none;
        background: transparent;
        font-size: 12px;
        color: #86868b;
      }

      .data-bar .btn-file {
        background: #0071e3;
        color: white;
        border: none;
        border-radius: 9px;
        padding: 7px 13px;
        font-size: 12px;
        font-weight: 600;
      }

      .data-bar .btn-file:hover {
        background: #0077ed;
      }

      /* METRICS */

      .metric-grid {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr;
        gap: 12px;
        margin-bottom: 12px;
      }

      .metric-card {
        background: #ffffff;
        border-radius: 18px;
        border: 1px solid #e5e5e7;
        padding: 22px 23px;
        min-height: 128px;
      }

      .metric-card.primary {
        background: #1d1d1f;
        border-color: #1d1d1f;
        color: #ffffff;
      }

      .metric-label {
        color: #86868b;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: .5px;
        margin-bottom: 9px;
      }

      .primary .metric-label {
        color: #a1a1a6;
      }

      .metric-value {
        font-size: 27px;
        font-weight: 650;
        letter-spacing: -1px;
      }

      .primary .metric-value {
        font-size: 38px;
        letter-spacing: -1.5px;
      }

      .metric-change {
        margin-top: 8px;
        color: #30a94a;
        font-size: 12px;
        font-weight: 500;
      }

      /* MAIN PANELS */

      .dashboard-grid {
        display: grid;
        grid-template-columns: 1.7fr 1fr;
        gap: 12px;
      }

      .panel {
        background: #ffffff;
        border: 1px solid #e5e5e7;
        border-radius: 18px;
        padding: 22px;
      }

      .panel-title {
        font-size: 16px;
        font-weight: 650;
        letter-spacing: -.2px;
        margin-bottom: 18px;
      }

      .panel-subtitle {
        float: right;
        color: #86868b;
        font-size: 11px;
        font-weight: 400;
        padding-top: 3px;
      }

      /* ALLOCATION */

      .allocation-total {
        color: #86868b;
        font-size: 12px;
        margin-top: -10px;
        margin-bottom: 24px;
      }

      .allocation-row {
        margin-bottom: 18px;
      }

      .allocation-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 7px;
      }

      .allocation-name {
        color: #424245;
        font-size: 13px;
      }

      .allocation-value {
        color: #1d1d1f;
        font-size: 12px;
        font-weight: 600;
      }

      .allocation-track {
        height: 7px;
        width: 100%;
        background: #eeeeef;
        border-radius: 10px;
        overflow: hidden;
      }

      /* PROJECTION */

      .projection-panel {
        margin-top: 12px;
      }

 .projection-controls {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 10px;
  margin-bottom: 5px;
}




      .projection-control {
        background: #f5f5f7;
        border-radius: 12px;
        padding: 10px 13px;
      }

      .projection-control label {
        font-size: 11px;
        color: #86868b;
        font-weight: 500;
        margin-bottom: 4px;
      }

     .projection-control .form-control {
  background: transparent;
  border: 0;
  box-shadow: none;
  padding: 0;
  height: 27px;
  width: 100%;
  max-width: 100%;
  font-size: 15px;
  font-weight: 600;
}

.projection-control .form-group {
  margin: 0;
  width: 100%;
}

.projection-control .shiny-input-container {
  width: 100% !important;
  max-width: 100% !important;
}

.projection-control input {
  width: 100% !important;
  max-width: 100% !important;
}


      .projection-control .form-control:focus {
        box-shadow: none;
      }

      /* ASSETS / LIABILITIES */

      .bottom-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
        margin-top: 12px;
      }

      .asset-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 0;
        border-bottom: 1px solid #eeeeef;
      }

      .asset-row:last-child {
        border-bottom: none;
      }

      .asset-name {
        font-size: 13px;
        font-weight: 500;
      }

      .asset-category {
        color: #86868b;
        font-size: 11px;
        margin-top: 3px;
      }

      .asset-value {
        font-size: 13px;
        font-weight: 600;
        white-space: nowrap;
      }

      /* RESPONSIVE */

      @media (max-width: 1150px) {
        .projection-controls {
          grid-template-columns: repeat(3, 1fr);
        }
      }

      @media (max-width: 1050px) {
        .metric-grid {
          grid-template-columns: 1fr 1fr;
        }

        .metric-card.primary {
          grid-column: span 2;
        }

        .dashboard-grid {
          grid-template-columns: 1fr;
        }
      }

      @media (max-width: 650px) {
        .container-fluid {
          padding: 20px;
        }

        .metric-grid {
          grid-template-columns: 1fr;
        }

        .metric-card.primary {
          grid-column: auto;
        }

        .bottom-grid {
          grid-template-columns: 1fr;
        }

        .projection-controls {
          grid-template-columns: 1fr;
        }

        .topbar {
          align-items: flex-start;
        }
      }

    "))
  ),


  # ==========================================================
  # HEADER
  # ==========================================================

  div(
    class = "topbar",

    div(
      div(
        class = "brand",
        "Net Worth"
      ),

      div(
        class = "brand-subtitle",
        "Personal financial overview"
      )
    ),

    div(
      class = "date-display",
      textOutput("current_date")
    )
  ),


  # ==========================================================
  # EXCEL INPUT
  # ==========================================================

  div(
    class = "data-bar",

    div(
      style = "
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:20px;
      ",

      div(

        div(
          style = "
            font-size:14px;
            font-weight:600;
            color:#1d1d1f;
            margin-bottom:3px;
          ",
          "Your financial data"
        ),

        div(
          style = "
            font-size:12px;
            color:#86868b;
          ",
          "Select your Excel file to update the dashboard."
        )
      ),

      div(
        style = "min-width:280px;",

        fileInput(
          "excel_file",
          NULL,
          accept = c(".xlsx", ".xls"),
          buttonLabel = "Choose Excel file",
          placeholder = "No file selected"
        )
      )
    )
  ),


  # ==========================================================
  # TOP METRICS
  # ==========================================================

  div(
    class = "metric-grid",

    div(
      class = "metric-card primary",

      div(
        class = "metric-label",
        "CURRENT NET WORTH"
      ),

      div(
        class = "metric-value",
        textOutput("net_worth")
      ),

      div(
        class = "metric-change",
        textOutput("net_worth_change")
      )
    ),

    div(
      class = "metric-card",

      div(
        class = "metric-label",
        "TOTAL ASSETS"
      ),

      div(
        class = "metric-value",
        textOutput("assets")
      )
    ),

    div(
      class = "metric-card",

      div(
        class = "metric-label",
        "LIABILITIES"
      ),

      div(
        class = "metric-value",
        textOutput("debt")
      )
    ),

    div(
      class = "metric-card",

      div(
        class = "metric-label",
        "LIQUID WEALTH"
      ),

      div(
        class = "metric-value",
        textOutput("liquid")
      )
    )
  ),


  # ==========================================================
  # HISTORY + ALLOCATION
  # ==========================================================

  div(
    class = "dashboard-grid",

    div(
      class = "panel",

      div(
        class = "panel-title",

        "Net Worth History",

        span(
          class = "panel-subtitle",
          "Historical"
        )
      ),

      plotOutput(
        "history",
        height = "310px"
      )
    ),

    div(
      class = "panel",

      div(
        class = "panel-title",
        "Asset Allocation"
      ),

      div(
        class = "allocation-total",
        textOutput("allocation_total")
      ),

      uiOutput("allocation")
    )
  ),


  # ==========================================================
  # PROJECTION
  # ==========================================================

  div(
    class = "panel projection-panel",

    div(
      class = "panel-title",
      "Net Worth Projection"
    ),

    div(
      style = "
        color:#86868b;
        font-size:12px;
        margin-top:-10px;
        margin-bottom:18px;
      ",
      "Annual growth assumptions by asset category"
    ),

    div(
      class = "projection-controls",

      div(
        class = "projection-control",

        numericInput(
          "cash_rate",
          "Cash",
          value = 0,
          min = -20,
          max = 50,
          step = 0.5
        )
      ),

      div(
        class = "projection-control",

        numericInput(
          "savings_rate",
          "Savings",
          value = 2,
          min = -20,
          max = 50,
          step = 0.5
        )
      ),

      div(
        class = "projection-control",

        numericInput(
          "investments_rate",
          "Investments",
          value = 7,
          min = -20,
          max = 50,
          step = 0.5
        )
      ),

      div(
  class = "projection-control",

  numericInput(
    "monthly_investment",
    "Monthly investment",
    value = 0,
    min = 0,
    step = 100
  )
),


      div(
        class = "projection-control",

        numericInput(
          "real_estate_rate",
          "Real Estate",
          value = 3,
          min = -20,
          max = 50,
          step = 0.5
        )
      ),

      div(
        class = "projection-control",

        numericInput(
          "other_rate",
          "Other",
          value = 2,
          min = -20,
          max = 50,
          step = 0.5
        )
      ),

      div(
        class = "projection-control",

        selectInput(
          "projection_years",
          "Horizon",

          choices = c(
            "5 years" = 5,
            "10 years" = 10,
            "20 years" = 20,
            "30 years" = 30
          ),

          selected = 10
        )
      )
    ),

    plotOutput(
      "projection",
      height = "310px"
    )
  ),


  # ==========================================================
  # ASSETS + LIABILITIES
  # ==========================================================

  div(
    class = "bottom-grid",

    div(
      class = "panel",

      div(
        class = "panel-title",
        "Assets"
      ),

      uiOutput("asset_list")
    ),

    div(
      class = "panel",

      div(
        class = "panel-title",
        "Liabilities"
      ),

      uiOutput("liability_list")
    )
  )

)
