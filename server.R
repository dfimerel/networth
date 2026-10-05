function(input, output, session) {

  # ==========================================================
  # LOAD EXCEL
  # ==========================================================

  data <- reactive({

    req(input$excel_file)

    df <- readxl::read_excel(
      input$excel_file$datapath,
      col_names = TRUE,
      skip = 1,
      col_types = "text"
    )

    names(df) <- trimws(names(df))

    # --------------------------------------------------------
    # DATE
    # --------------------------------------------------------

    raw_date <- trimws(as.character(df$Date))

    df$Date <- as.Date(NA)

    numeric_dates <- grepl(
      "^[0-9]+(\\.[0-9]+)?$",
      raw_date
    )

    if (any(numeric_dates)) {

      df$Date[numeric_dates] <- as.Date(
        as.numeric(raw_date[numeric_dates]),
        origin = "1899-12-30"
      )
    }

    text_dates <- !numeric_dates

    if (any(text_dates)) {

      df$Date[text_dates] <- as.Date(
        raw_date[text_dates],
        format = "%d/%m/%Y"
      )
    }

    # --------------------------------------------------------
    # VALUE
    # --------------------------------------------------------

    df$Value <- as.numeric(
      gsub(
        ",",
        "",
        trimws(df$Value)
      )
    )

    # --------------------------------------------------------
    # TEXT COLUMNS
    # --------------------------------------------------------

    df$Type <- trimws(df$Type)

    df$Category <- trimws(df$Category)

    df$`Asset / Liability` <-
      trimws(df$`Asset / Liability`)

    df
  })


  # ==========================================================
  # LATEST DATE
  # ==========================================================

  latest_date <- reactive({

    req(data())

    max(
      data()$Date,
      na.rm = TRUE
    )
  })


  # ==========================================================
  # LATEST DATA
  # ==========================================================

  latest_data <- reactive({

    df <- data()

    df[
      df$Date == latest_date(),
    ]
  })


  # ==========================================================
  # TOTAL ASSETS
  # ==========================================================

  total_assets <- reactive({

    df <- latest_data()

    sum(
      df$Value[
        df$Type == "Asset"
      ],
      na.rm = TRUE
    )
  })


  # ==========================================================
  # TOTAL LIABILITIES
  # ==========================================================

  total_debt <- reactive({

    df <- latest_data()

    liabilities <- df$Value[
      df$Type == "Liability"
    ]

    if (length(liabilities) == 0) {
      return(0)
    }

    sum(
      liabilities,
      na.rm = TRUE
    )
  })


  # ==========================================================
  # NET WORTH
  # ==========================================================

  current_net_worth <- reactive({

    total_assets() + total_debt()
  })


  # ==========================================================
  # LIQUID WEALTH
  # ==========================================================

  liquid_wealth <- reactive({

    df <- latest_data()

    liquid_categories <- c(
      "Cash",
      "Savings",
      "Investments"
    )

    sum(
      df$Value[
        df$Category %in% liquid_categories &
        df$Type == "Asset"
      ],
      na.rm = TRUE
    )
  })


  # ==========================================================
  # NET WORTH HISTORY
  # ==========================================================

  history <- reactive({

    df <- data()

    dates <- sort(
      unique(df$Date)
    )

    result <- data.frame()

    for (d in dates) {

      d_data <- df[
        df$Date == d,
      ]

      assets <- sum(
        d_data$Value[
          d_data$Type == "Asset"
        ],
        na.rm = TRUE
      )

      liabilities <- sum(
        d_data$Value[
          d_data$Type == "Liability"
        ],
        na.rm = TRUE
      )

      result <- rbind(
        result,
        data.frame(
          date = as.Date(d),
          net_worth =
            assets + liabilities
        )
      )
    }

    result
  })


  # ==========================================================
  # ASSET ALLOCATION
  # ==========================================================

  allocation <- reactive({

    df <- latest_data()

    asset_data <- df[
      df$Type == "Asset",
    ]

    if (nrow(asset_data) == 0) {

      return(
        data.frame(
          Category = character(),
          Value = numeric()
        )
      )
    }

    aggregate(
      Value ~ Category,
      data = asset_data,
      FUN = sum
    )
  })


  # ==========================================================
  # HEADER DATE
  # ==========================================================

  output$current_date <- renderText({

    format(
      latest_date(),
      "%B %Y"
    )
  })


  # ==========================================================
  # NET WORTH
  # ==========================================================

  output$net_worth <- renderText({

    paste0(
      "€",
      format(
        current_net_worth(),
        big.mark = ",",
        scientific = FALSE
      )
    )
  })


  # ==========================================================
  # ASSETS
  # ==========================================================

  output$assets <- renderText({

    paste0(
      "€",
      format(
        total_assets(),
        big.mark = ",",
        scientific = FALSE
      )
    )
  })


  # ==========================================================
  # LIABILITIES
  # ==========================================================

  output$debt <- renderText({

    paste0(
      "€",
      format(
        abs(total_debt()),
        big.mark = ",",
        scientific = FALSE
      )
    )
  })


  # ==========================================================
  # LIQUID WEALTH
  # ==========================================================

  output$liquid <- renderText({

    paste0(
      "€",
      format(
        liquid_wealth(),
        big.mark = ",",
        scientific = FALSE
      )
    )
  })


  # ==========================================================
  # NET WORTH CHANGE
  # ==========================================================

  output$net_worth_change <- renderText({

    h <- history()

    if (nrow(h) < 2) {
      return("")
    }

    current <- h$net_worth[
      nrow(h)
    ]

    previous <- h$net_worth[
      nrow(h) - 1
    ]

    change <- current - previous

    if (previous == 0) {

      return(
        paste0(
          ifelse(
            change >= 0,
            "↑ ",
            "↓ "
          ),
          "€",
          format(
            abs(change),
            big.mark = ",",
            scientific = FALSE
          )
        )
      )
    }

    percentage <-
      change / previous * 100

    arrow <- if (
      change >= 0
    ) {
      "↑"
    } else {
      "↓"
    }

    paste0(
      arrow,
      " €",
      format(
        abs(change),
        big.mark = ",",
        scientific = FALSE
      ),
      " · ",
      sprintf(
        "%.1f",
        abs(percentage)
      ),
      "%"
    )
  })


  # ==========================================================
  # HISTORY CHART
  # ==========================================================

  output$history <- renderPlot({

    h <- history()

    req(nrow(h) > 0)

    if (nrow(h) == 1) {

      ggplot(
        h,
        aes(
          x = date,
          y = net_worth
        )
      ) +

        geom_point(
          color = "#0071e3",
          size = 4
        ) +

        scale_y_continuous(
          labels =
            scales::label_number(
              prefix = "€",
              big.mark = ","
            )
        ) +

        scale_x_date(
          date_labels = "%b %Y"
        ) +

        labs(
          x = NULL,
          y = NULL
        ) +

        theme_minimal()

    } else {

      ggplot(
        h,
        aes(
          x = date,
          y = net_worth,
          group = 1
        )
      ) +

        geom_area(
          fill = "#0071e3",
          alpha = 0.08
        ) +

        geom_line(
          color = "#0071e3",
          linewidth = 1.2
        ) +

        geom_point(
          color = "#0071e3",
          size = 2.5
        ) +

        scale_y_continuous(
          labels =
            scales::label_number(
              prefix = "€",
              big.mark = ","
            )
        ) +

        scale_x_date(
          date_labels = "%b %Y"
        ) +

        labs(
          x = NULL,
          y = NULL
        ) +

        theme_minimal() +

        theme(
          panel.grid.minor =
            element_blank(),

          panel.grid.major.x =
            element_blank(),

          panel.grid.major.y =
            element_line(
              color = "#eeeeef"
            ),

          axis.text =
            element_text(
              color = "#86868b",
              size = 9
            )
        )
    }
  })


  # ==========================================================
  # PROJECTION
  # ==========================================================

  output$projection <- renderPlot({

    req(
      current_net_worth(),
      input$cash_rate,
      input$savings_rate,
      input$investments_rate,
      input$real_estate_rate,
      input$other_rate,
      input$monthly_investment,
      input$projection_years
    )

    df <- latest_data()

    years <- as.numeric(
      input$projection_years
    )

    start_year <- as.integer(
      format(
        latest_date(),
        "%Y"
      )
    )

    # --------------------------------------------------------
    # CURRENT VALUE BY CATEGORY
    # --------------------------------------------------------

    category_values <- aggregate(
      Value ~ Category,
      data = df[df$Type == "Asset", ],
      FUN = sum
    )

    get_value <- function(category) {

      value <- category_values$Value[
        category_values$Category == category
      ]

      if (length(value) == 0) {
        return(0)
      }

      sum(value, na.rm = TRUE)
    }


    cash <- get_value("Cash")

    savings <- get_value("Savings")

    investments <- get_value("Investments")

    real_estate <- get_value("Real Estate")

    other <- sum(
      category_values$Value[
        !category_values$Category %in%
          c(
            "Cash",
            "Savings",
            "Investments",
            "Real Estate"
          )
      ],
      na.rm = TRUE
    )


    # --------------------------------------------------------
    # PROJECTION
    # --------------------------------------------------------

    projection_years <- 0:years

    projected_cash <-
      cash *
      (1 + input$cash_rate / 100) ^
      projection_years

    projected_savings <-
      savings *
      (1 + input$savings_rate / 100) ^
      projection_years

    projected_investments <-
  investments *
  (1 + input$investments_rate / 100) ^
  projection_years +

  input$monthly_investment *
  12 *
  projection_years


    projected_real_estate <-
      real_estate *
      (1 + input$real_estate_rate / 100) ^
      projection_years

    projected_other <-
      other *
      (1 + input$other_rate / 100) ^
      projection_years


    projected_net_worth <-
      projected_cash +
      projected_savings +
      projected_investments +
      projected_real_estate +
      projected_other


    projection <- data.frame(

      year =
        start_year + projection_years,

      value =
        projected_net_worth
    )


    # --------------------------------------------------------
    # CHART
    # --------------------------------------------------------

    ggplot(
      projection,
      aes(
        x = year,
        y = value
      )
    ) +

      geom_area(
        fill = "#0071e3",
        alpha = 0.08
      ) +

      geom_line(
        color = "#0071e3",
        linewidth = 1.4
      ) +

      geom_point(
        color = "#0071e3",
        size = 2.5
      ) +

      scale_y_continuous(
        labels =
          scales::label_number(
            prefix = "€",
            big.mark = ","
          )
      ) +

      labs(
        x = NULL,
        y = NULL
      ) +

      theme_minimal() +

      theme(
        panel.grid.minor =
          element_blank(),

        panel.grid.major.x =
          element_blank(),

        panel.grid.major.y =
          element_line(
            color = "#eeeeef"
          ),

        axis.text =
          element_text(
            color = "#86868b",
            size = 9
          )
      )
  })


  # ==========================================================
  # ASSET ALLOCATION TOTAL
  # ==========================================================

  output$allocation_total <- renderText({

    paste0(
      "€",
      format(
        total_assets(),
        big.mark = ",",
        scientific = FALSE
      ),
      " total assets"
    )
  })


  # ==========================================================
  # ASSET ALLOCATION
  # ==========================================================

  output$allocation <- renderUI({

    a <- allocation()

    if (nrow(a) == 0) {
      return(NULL)
    }

    total <- sum(
      a$Value,
      na.rm = TRUE
    )

    rows <- lapply(
      seq_len(nrow(a)),
      function(i) {

        percentage <-
          a$Value[i] / total * 100

        div(
          class = "allocation-row",

          div(
            class = "allocation-header",

            span(
              class = "allocation-name",
              a$Category[i]
            ),

            span(
              class = "allocation-value",
              paste0(
                round(percentage),
                "%"
              )
            )
          ),

          div(
            class = "allocation-track",

            div(
              style = paste0(
                "height:100%;",
                "width:",
                percentage,
                "%;",
                "background:#0071e3;",
                "border-radius:10px;"
              )
            )
          )
        )
      }
    )

    tagList(rows)
  })


  # ==========================================================
  # ASSET LIST
  # ==========================================================

  output$asset_list <- renderUI({

    df <- latest_data()

    asset_rows <- df[
      df$Type == "Asset",
    ]

    if (nrow(asset_rows) == 0) {

      return(
        div(
          class = "asset-category",
          "No assets"
        )
      )
    }

    rows <- lapply(
      seq_len(nrow(asset_rows)),
      function(i) {

        div(
          class = "asset-row",

          div(

            div(
              class = "asset-name",
              asset_rows$`Asset / Liability`[i]
            ),

            div(
              class = "asset-category",
              asset_rows$Category[i]
            )
          ),

          div(
            class = "asset-value",

            paste0(
              "€",
              format(
                asset_rows$Value[i],
                big.mark = ",",
                scientific = FALSE
              )
            )
          )
        )
      }
    )

    tagList(rows)
  })


  # ==========================================================
  # LIABILITY LIST
  # ==========================================================

  output$liability_list <- renderUI({

    df <- latest_data()

    liability_rows <- df[
      df$Type == "Liability",
    ]

    if (nrow(liability_rows) == 0) {

      return(
        div(
          class = "asset-category",
          "No liabilities"
        )
      )
    }

    rows <- lapply(
      seq_len(nrow(liability_rows)),
      function(i) {

        div(
          class = "asset-row",

          div(

            div(
              class = "asset-name",
              liability_rows$`Asset / Liability`[i]
            ),

            div(
              class = "asset-category",
              liability_rows$Category[i]
            )
          ),

          div(
            class = "asset-value",

            paste0(
              "−€",
              format(
                abs(
                  liability_rows$Value[i]
                ),
                big.mark = ",",
                scientific = FALSE
              )
            )
          )
        )
      }
    )

    tagList(rows)
  })

}
