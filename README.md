[![Build Status](https://app.travis-ci.com/wheeendiii/2021Fall_finals.svg?branch=main)](https://app.travis-ci.com/wheeendiii/2021Fall_finals)
# Evolution of Inflation/GDP/Stock Market before and after Wars And Pandemics (Type I)

Group members: Kangyang Wang (*kangyangwang*), Wendy Zhu (*wheeendiii*), and Kay Avila (*kayavila*)

## Reference Articles:
* https://voxeu.org/article/inflation-aftermath-wars-and-pandemics
* https://www.goldmansachs.com/insights/pages/gs-research/reflation-risk/report.pdf

## Potential Questions and Improvements:

Based on the analysis of the above two articles, the authors conclude that, overall, "wars result in higher inflation and bond yields, 
pandemics do not". This conclusion is supported by several well-plotted graphs of Consumer Price Index (CPI) Inflation or Nominal ten-year bond 
yields around wars and pandemics. More specifically, the authors used the last year of significant fatalities as the 
end-year for wars and pandemics (Year = 0) (In a number of instances, this is one year before the formal end of the 
war/pandemics) and overlaid the historical CPI Inflation/Bond Yield data 10 years before and after the year 0 to monitor
the evolution of Inflation and Bond Yield before and after each event.

The analysis of the articles seems well organized, but we have several concerns:
* The conclusion is contradicting with what we are experiencing now. As we know, the CPI inflation rate is surging since the 
outbreak of COVID-19 and is reaching a 30-year record high recently.
* The conclusion in the article didn't consider many inner factors of the events, such as the fatalities and the duration of the events. 
Would they affect the final overall trend of the CPI Inflation and bond yield around the events?
* Are there any significant market vibrations (changes of major market indexes) before and after wars and pandemics?

As we investigate these, we will look specifically at the United States, and see if the authors' proposals hold true
for this one country in particular, using events that have influenced it.

## Hypotheses

* CPI - For the United States, we follow the authors' hypothesis that wars will result in higher inflation in the near term after the end of the war (as indicated by the consumer price index), but pandemics will not.
* GDP - 
* S&P 500 and Dow Jones - 1. In the aftermath of wars and pandemics, the major stock market indexes (S&P500 and Dow Jones) will slide down due to the impacted economic conditions. 2. The major stock market indexes (S&P500 and Dow Jones) will be more volatile after the start of the wars/pandemics.

## Data Sources
### Event Data (Kangyang)

This data file is compiled from the wars and pandemics chart in the reference article "Inflation in the aftermath of wars and pandemics" (https://voxeu.org/article/inflation-aftermath-wars-and-pandemics) and the Wiki pages for wars and pandemics("List of epidemics" - https://en.wikipedia.org/wiki/List_of_epidemics, "Timeline of wars" - https://en.wikipedia.org/wiki/Timeline_of_wars).

### Consumer Price Index (CPI) (Kay)
* CPI for US from 1913-present - https://beta.bls.gov/dataViewer/view/timeseries/CUUR0000SA0
* CPI for G20 countries from 1915-present -  https://stats.oecd.org/Index.aspx?DataSetCode=G20_PRICES# 

Consumer price index represents the change in prices that consumers are paying for common household goods, 
including food, gas, and prescription drugs.

The US CPI data set comes from the United States Bureau of Labor Statistics website, which has data available
from 1913 through the present year.  The values are relevant to each other. That is, rather than discrete amounts, 
the index represents the change in prices from year to year, based on a "base index".  The base index for
this dataset is calculated by taking the average of the period from January 1982 through December 1984 and 
setting it at 100[^1].  All other index values are then given as a percentage change from that value.

### Gross Domestic Product (GDP) (Wendy)
* GDP for all countries from 1960-present - https://databank.worldbank.org/reports.aspx?source=2&type=metadata&series=NY.GDP.MKTP.CD#

### S&P500 and Dow Jones (Kangyang)
* S&P500 historical monthly nominal and real (inflation adjusted) data from 1927 - https://www.macrotrends.net/2324/sp-500-historical-chart-data
* Dow Jones historical monthly nominal and real (inflation adjusted) data from 1915 - https://www.macrotrends.net/1319/dow-jones-100-year-historical-chart

## Conclusions

### Consumer Price Index (CPI) before and after Wars and Pandemics (Kay)

Plotting all pandemics and all wars:
![alt text](Plots/CPI/all_pandemics.png)
![alt text](Plots/CPI/all_wars.png)

Plotting the quartiles and means calculated for all pandemics and all wars:
![alt text](Plots/CPI/pandemics_quartiles.png)
![alt text](Plots/CPI/pandemics_mean.png)
![alt text](Plots/CPI/wars_quartiles.png)
![alt text](Plots/CPI/wars_mean.png)

### Gross Domestic Product (GDP) before and after Wars and Pandemics (Wendy)

1. Overall GDP and subcategories (Personal consumption expenditures, Gross private domestic investment and Government consumption expenditures and gross investment)
![alt text](Plots/GDP/HIV%20AIDS%20pandemic.png)

2. Pandemics Vs. Wars
* GDP fluctuations for SARS outbreak, Ebola virus epidemic and COVID-19 pandemic:
![alt text](Plots/GDP/SARS%20outbreak.png)
![alt text](Plots/GDP/Western%20African%20Ebola%20virus%20epidemic.png)
![alt text](Plots/GDP/COVID-19%20pandemic.png)

* GDP fluctuations for Korean War and World War II:
![alt text](Plots/GDP/Korean%20War.png)
![alt text](Plots/GDP/World%20War%20II.png)


### S&P500 and Dow Jones before and after Wars and Pandemics (Kangyang)

**x = 0 is the January of the selected Year Zero.** 

1. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and Dow Jones historical data 10 years before and after the zero point year, plots would be:

* The evolution of real SP500 and Dow Jones 10 years before and after all the Pandemics:
['Asian Flu', 'Hong Kong Flu', 'London flu', 'Russian flu', 'HIV/AIDS pandemic', 'SARS outbreak', 'Swine flu pandemic']
![alt text](Plots/StockIndex/10y_year_before_end_year_real_all_pandemics.png)

* The evolution of real SP500 and Dow Jones 10 years before and after all the Wars:
['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'War on Terror', 'Iraq War', 'War in Somalia']
![alt text](Plots/StockIndex/10y_year_before_end_year_real_all_wars.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Pandemics with over 1m fatalities:
['Asian Flu', 'Hong Kong Flu', 'HIV/AIDS pandemic']
![alt text](Plots/StockIndex/10y_year_before_end_year_real_pandemics_over_1m_fatalities.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Wars with over 1m fatalities:
['Korean War', 'Vietnam War', 'World War II', 'War in Somalia']
![alt text](Plots/StockIndex/10y_year_before_end_year_real_wars_over_1m_fatalities.png)

2. If we use the event start year as zero point, and select the real SP500 and Dow Jones historical data 5 years before and after the zero point year, plots would be

* The evolution of real SP500 and Dow Jones 5 years before and after all the Pandemics:
![alt text](Plots/StockIndex/5y_start_year_real_all_pandemics.png)

* The evolution of real SP500 and Dow Jones 5 years before and after all the Wars:
![alt text](Plots/StockIndex/5y_start_year_real_all_wars.png)

* The evolution of real SP500 and Dow Jones 5 years before and after Pandemics with over 1m fatalities:
![alt text](Plots/StockIndex/5y_start_year_real_pandemics_over_1m_fatalities.png)

* The evolution of real SP500 and Dow Jones 5 years before and after Wars with over 1m fatalities:
![alt text](Plots/StockIndex/5y_start_year_real_wars_over_1m_fatalities.png)

[comment]: <> (3. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and Dow Jones historical data 5 years before and after the zero point year, plots would be)

[comment]: <> (* The evolution of real SP500 and Dow Jones 5 years before and after all the Pandemics:)

[comment]: <> (['Asian Flu', 'Hong Kong Flu', 'London flu', 'Russian flu', 'SARS outbreak', 'Swine flu pandemic', 'Western African Ebola virus epidemic'])

[comment]: <> (![alt text]&#40;Plots/StockIndex/5y_year_before_end_year_real_all_pandemics.png&#41;)

[comment]: <> (* The evolution of real SP500 and Dow Jones 5 years before and after all the Wars:)

[comment]: <> (['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'Iraq War'])

[comment]: <> (![alt text]&#40;Plots/StockIndex/5y_year_before_end_year_real_all_wars.png&#41;)


[comment]: <> (* The evolution of real SP500 and Dow Jones 5 years before and after Pandemics with over 1m fatalities:)

[comment]: <> (['Asian Flu', 'Hong Kong Flu'])

[comment]: <> (![alt text]&#40;Plots/StockIndex/5y_year_before_end_year_real_pandemics_over_1m_fatalities.png&#41;)


* The evolution of real SP500 and Dow Jones 5 years before and after Wars with over 1m fatalities:
['Korean War', 'Vietnam War', 'World War II']
![alt text](Plots/StockIndex/5y_year_before_end_year_real_wars_over_1m_fatalities.png)



## References
[^1]: https://www.bls.gov/cpi/questions-and-answers.htm#Question_17
