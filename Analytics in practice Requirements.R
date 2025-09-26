# Import libraries
library(forecast)
library(zoo)
library(ggplot2)

# Read csv
banana <- read.csv("E vs R vs A.csv")

# Get time series
banana_act_ts <- ts(banana$Requirement, start = c(2024, 1), freq = 52)

# Plot the time series
banana_act_ts |> 
  autoplot(col = "blue") +
  labs(title = "Banana Exports in 2024",
       x = "Week",
       y = "Exports"
  ) +
  theme_minimal()

# Divide 36 datapoints for train and 12 for validation
train_ts <- window(banana_act_ts, end = time(banana_act_ts)[36])
valid_ts <- window(banana_act_ts, start = time(banana_act_ts)[37])

# Get accuracy of the given forecasts
forecast_estimates <- accuracy(banana[37: 48, 2], banana[37: 48, 3])
forecast_requirements <- accuracy(banana[37: 48, 3], banana[37: 48, 4])

# Run naive
results <- data.frame(model = 0, parameter = 0,MAPE = 0)
naive_mod_forecast <- naive(train_ts, h = 12)
naive_mape <- accuracy(naive_mod_forecast, valid_ts)[2,5]

# Store results in a dataframe
results[1, ] <- c("Naive", "", naive_mape)

# Run moving average and store MAPE and RMSE
results_ma <- data.frame(parameters = seq(1:4), MAPE = 0)
for (i in (1:4)){
  train_ma <- rollmean(train_ts, k = i, align = "right")
  ma_valid_forecast <- forecast(train_ma, h = 12)
  results_ma[i, 1] <- i
  results_ma[i, 2] <- accuracy(ma_valid_forecast, valid_ts)[2, 5]
} 

# Store results in dataframe
results[2, ] <- c("Moving Average", which.min(results_ma$MAPE),min(results_ma$MAPE))

# Run best arima
results_arima <- data.frame(parameters = 0, MAPE = 0)
n <- 1
for (p in (0 : 4)) {
  for (d in (0 : 1)) {
    for (q in (0 : 4)) {
      arima_model <- arima(train_ts, c(p, d, q))
      arima_forecast <- forecast(arima_model, h = 12)
      results_arima[n, 1] <- paste("(", p, ",", d, ",", q, ")")
      results_arima[n, 2] <- accuracy(arima_forecast, valid_ts)[2, 5]
      n <- n + 1
    }
  }
}

# Store results in a dataframe
results[3, ] <- c("ARIMA", results_arima$parameters[which.min(results_arima$MAPE)],min(results_arima$MAPE))

# Run exponential smoothing
error_ets <- c("A", "M")
trend_ets <- c("N", "A", "M")
season_ets <- c("N", "A", "M")

results_ets <- data.frame(parameters = 0, MAPE = 0)
m <- 1
for (e in error_ets){
  for (t in trend_ets){
    for (s in season_ets){
      if ((e == "A" && t == "M" && e == "A"))
          {  
        next
      }
      ets_mod <- ets(train_ts, model = paste0(e, t, s))
      ets_forecast <- forecast(ets_mod, h = 12) 
      results_ets[m, 1] <- paste("(", e, ",", t, ",", s, ")")
      results_ets[m, 2] <- accuracy(ets_forecast, valid_ts)[2,5]
      m <- m + 1
    }
  }
}

# Store results in a dataframe
results[4, ] <- c("Exponential Smoothing", results_ets$parameters[which.min(results_ets$MAPE)],min(results_ets$MAPE))

# Run additive trend

outcome_transformations <- list(
  linear = function(x) x,
  squared = function(x) x^2,
  sqrt = function(x) sqrt(x),
  log = function(x) log(x)
)

# Define inverse transformations for forecasts
inverse_transformations <- list(
  linear = function(x) x,
  squared = function(x) sqrt(x),
  sqrt = function(x) x^2,
  log = function(x) exp(x)
)

# Define trend transformations using formula notation
trend_transformations <- list(
  linear = "trend",
  squared = "I(trend^2)",
  sqrt = "I(sqrt(trend))",
  exp = "I(exp(trend))",
  log = "I(log(trend))"
)

results_tslm <- data.frame(parameters = 0, MAPE = 0)
m <- 1
time_index <- seq_along(train_ts)

for (outcome_name in names(outcome_transformations)) {
  outcome_transform <- outcome_transformations[[outcome_name]]
  inverse_transform <- inverse_transformations[[outcome_name]]
  
  transformed_train <- outcome_transform(train_ts)
  
  for (trend_name in names(trend_transformations)) {
    trend_formula <- trend_transformations[[trend_name]]
    
    # Fit tslm model using formula notation
      tslm_model <- tslm(transformed_train ~ eval(parse(text = trend_formula)), data = data.frame(trend = time_index))
      
      tslm_forecast <- forecast(tslm_model, h = 12)
      
      # Inverse transform forecast
      final_forecast <- inverse_transform(tslm_forecast$mean)
      
      # Compute MAPE
      MAPE_value <- accuracy(final_forecast, valid_ts)[1, 5]
      
      # Store results
      results_tslm[m, ] <- c(paste(outcome_name, "~", trend_name), MAPE_value)
      m <- m + 1
  }
}

# Store results in a dataframe
results[5, ] <- c("Time Series Linear Model", results_tslm$parameters[which.min(as.numeric(results_tslm$MAPE))], min(as.numeric(results_tslm$MAPE)))

arima_mod <- arima(train_ts, order = c(3, 0, 3))
arima_pred <- forecast(arima_mod, h = 12)$mean

# Compute best model
final_model <- data.frame(week = banana[37: 48, 1], actual = valid_ts, predicted = arima_pred)

#Plot best model
ggplot(data = final_model, aes(x = week)) +
  geom_line(aes(y = actual, color = "actual")) +
  geom_line(aes(y = predicted, color = "predicted")) +
  scale_color_manual(values = c("actual" = "red", "predicted" = "blue"))

write.csv2(final_model, "banana_req_predictions.csv", row.names = FALSE)
write.csv2(results, "best_models_accuracy_req.csv", row.names = FALSE)

all_models_results <- data.frame(model = "Naive", 
                                 parameters = "", 
                                 MAPE = naive_mape)

results_ma$model <- "Moving Average"
all_models_results <- rbind(all_models_results, results_ma)

results_arima$model <- "ARIMA"
all_models_results <- rbind(all_models_results, results_arima)

results_ets$model <- "Exponential Smoothing"
all_models_results <- rbind(all_models_results, results_ets)

results_tslm$model <- "Time Series Linear Model"
all_models_results <- rbind(all_models_results, results_tslm)

write.csv2(all_models_results, "all_models_results_req.csv", row.names = FALSE)

arima_full <- arima(banana_act_ts, order = c(3, 0, 3))

forecast_full <- forecast(arima_full, h = 16)$mean

predictions_2025 <- data.frame(week = (202449:202452))
predictions_2025[5:16, ] <- (202501:202512)

predictions_2025$forecast <- forecast_full

write.csv2(predictions_2025, "predictions_2025_req.csv", row.names = FALSE)

