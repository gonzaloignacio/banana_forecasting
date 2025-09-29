# GENERAL OBJECTIVE
Optimize banana supply forecasting using data analysis and machine learning models, aiming to reduce requirement-export mismatches and enhance supply chain stability.


# WHY REQUIREMENT &ACTUAL EXPORT?

* Requirement: Forecast should fit accurately to the initial requirements. Demand rate is equal to the requirements.
* Export: Initial requirements can increase/decrease, setting a demand rate different from the requirements.

# MODEL SELECTION

The candidate models are the following:

| Model                       | Reason                                                                                 |
|------------------------------|----------------------------------------------------------------------------------------|
| Naive Model                  | Baseline model to compare with more complex models and evaluate improvement in forecasting efficiency. |
| Moving Average               | Smooths time series data with no obvious trend or seasonality to observe stable patterns. |
| ARIMA                        | Captures clear trends in time series data, such as agricultural product yield.       |
| Exponential Smoothing        | Adapts to fluctuating time series by assigning different weights to past data.       |
| Time Series Linear Model (TSLM) | Uses different transformations to capture long-term trends and variations.          |

 * The length of data is only 48 weeks which is not enough for  decomposition analysis.
 * Applying multiple models to fit the data and using (Mean absolute percentage error) MAPE to compare errors which can help better understand its characteristics for further analysis.

# MODEL COMPARISON FOR ACTUAL PRODUCTION

| Model Name               | Parameters  | MAPE (%) |
|--------------------------|------------|----------|
| Naive                    | 1          | 7.66     |
| Moving Average           | (4,0,2)    | 6.65     |
| ARIMA                    | (A, A, N)  | 3.82     |
| Exponential Smoothing    | squared ~  | 5.74     |
| TSLM                     | squared    | 5.90     |

 * ARIMA(4,0,2) is the best forecasting model.
 * MAPE values are higher than the current forecasting MAPE(3.71%), but the difference is minimal.

# MODEL COMPARISON FOR REQUIREMENT PRODCTION

| Model Name            | Parameters       | MAPE (%) |
|-----------------------|-----------------|----------|
| Naive                 | -               | 7.54     |
| Moving Average        | 3               | 5.71     |
| ARIMA                 | (3,0,3)         | 4.07     |
| Exponential Smoothing | (M, A, N)       | 4.38     |
| TSLM                  | squared ~ squared | 5.42    |

 * ARIMA(3,0,3) is the best forecasting model.
 * MAPE values are higher than the current forecasting MAPE(2.97%), but the difference is minimal

# FORECAST ACCURACY INSIGHTS

* ARIMA model performed best in both cases, but the current estimates performs better, because of the length of the dataset.
* However, unless the company is expecting a sudden decrease in the demand, the ARIMA estimates are better than the current estimates for the prediction period (2024-49 to 2025-11).

  # KEY CHALLENGES
* Training the model with at least 3 years of data would result with more accurate models.
* Market demand fluctuations impacting weekly orders.
* External factors (weather, logistics, supply chain disruptions) not fully integrated.
* Forecasting models lack real-time adjustments, delaying corrective actions.

# TECHNOLOGY-ORIENTED RECOMMENDATIONS
*  Advanced Models – Hybrid approaches (ARIMA + ML, bagging or booting) for better predictions.
* External Data Integration – Incorporate weather, logistics, and supply chain disruptions.
*   Dynamic Forecasting – Implement rolling updates for real-time adjustments.
*  Operational Enhancements – Improve supplier collaboration, buffer
 stock strategy, and real-time KPI tracking.

 # BUSINESS-ORIENTED RECOMMENDATIONS
 * Demand-Supply Matching– Data-driven order matching, Flexible procurement contracts, Real-Time demand response.
 * Application of Forecasting Capabilities – Dynamic pricing strategy, Performance-based contracts，Real-time logistics optimization.
 * Sustainability Oriented Approach – Reduce the impact of market price fluctuations, Optimize production and order decisions to reduce waste and stock-outs on both sides.
 *  Continuous Process Improvement –  Regularly review and update, Enhance communication with all parties to adapt to the environment.
