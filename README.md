# Banana Supply Forecasting Project

## General Objective
Optimize banana supply forecasting using data analysis and machine learning models to reduce requirement-export mismatches and enhance supply chain stability.

> **Note on Data Privacy:**  
> All numerical values shown in this README are **percentages** or **normalized metrics** to illustrate trends and comparisons. Absolute values from the company's operations have been omitted to protect sensitive business information.

## Requirement vs Export
- **Requirement:** Forecast should fit initial requirements (demand rate = requirements).  
- **Export:** Initial requirements can increase/decrease, setting a demand rate different from requirements.

## Model Selection
| Model                       | Reason                                                                 |
|------------------------------|------------------------------------------------------------------------|
| Naive Model                  | Baseline for comparison with complex models.                           |
| Moving Average               | Smooths time series with no obvious trend or seasonality.             |
| ARIMA                        | Captures clear trends in time series.                                 |
| Exponential Smoothing        | Weights past data to adapt to fluctuating patterns.                   |
| Time Series Linear Model (TSLM) | Captures long-term trends via transformations.                       |

## Model Comparison for Actual Production
| Model Name               | Parameters    | MAPE (%) |
|--------------------------|--------------|----------|
| Naive                    | 1            | 7.66     |
| Moving Average           | (4,0,2)      | 6.65     |
| ARIMA                    | (A, A, N)    | 3.82     |
| Exponential Smoothing    | squared ~    | 5.74     |
| TSLM                     | squared      | 5.90     |

**Best model:** ARIMA(4,0,2)  

MAPE values are slightly higher than the current forecasting (3.71%), but the difference is minimal.

## Model Comparison for Requirement Production
| Model Name               | Parameters       | MAPE (%) |
|--------------------------|-----------------|----------|
| Naive                    | -               | 7.54     |
| Moving Average           | 3               | 5.71     |
| ARIMA                    | (3,0,3)         | 4.07     |
| Exponential Smoothing    | (M, A, N)       | 4.38     |
| TSLM                     | squared ~ squared | 5.42   |

**Best model:** ARIMA(3,0,3)  

MAPE values are slightly higher than the current forecasting (2.97%), but acceptable for short-term predictions.

## Forecast Accuracy Insights
- ARIMA performed best in both cases.  
- Current estimates perform better due to dataset length.  
- For 2024-49 to 2025-11, ARIMA estimates are preferable unless sudden demand decreases occur.

## Key Challenges
- Short dataset (48 weeks) limits accuracy.  
- Market demand fluctuations.  
- External factors (weather, logistics, supply chain disruptions).  
- Models lack real-time adjustment capability.

## Technology-Oriented Recommendations
- **Advanced Models:** Hybrid approaches (ARIMA + ML, bagging or boosting).  
- **External Data Integration:** Weather, logistics, supply chain events.  
- **Dynamic Forecasting:** Rolling updates for real-time adjustments.  
- **Operational Enhancements:** Supplier collaboration, buffer stocks, real-time KPI tracking.

## Business-Oriented Recommendations
- **Demand-Supply Matching:** Flexible procurement, real-time response.  
- **Forecasting Application:** Dynamic pricing, performance-based contracts, logistics optimization.  
- **Sustainability Approach:** Reduce waste, optimize production, mitigate market fluctuation effects.  
- **Continuous Improvement:** Regular updates, enhanced communication.
