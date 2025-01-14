[![Build Status](https://app.travis-ci.com/wheeendiii/2021Fall_finals.svg?branch=main)](https://app.travis-ci.com/wheeendiii/2021Fall_finals)
# Evolution of Inflation/GDP/Stock Market before and after Wars/Pandemics (Type I)

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
* GDP - The growth of GDP will be exceptionally strong during wars and will remain an increasing trend afterwards, whereas pandemics exhibit minor impact on GDP growth. 
* S&P 500 and Dow Jones
  1. In the aftermath of wars and pandemics, the major stock market indexes (S&P500 and Dow Jones) will slide down due to the impacted economic conditions. 
  2. The major stock market indexes (S&P500 and Dow Jones) will be more volatile after the start of the wars/pandemics.

## Data Sources
### Event Data

This data file is compiled from the wars and pandemics chart in the reference article "Inflation in the aftermath of wars and pandemics" (https://voxeu.org/article/inflation-aftermath-wars-and-pandemics) and the Wiki pages for wars and pandemics("List of epidemics" - https://en.wikipedia.org/wiki/List_of_epidemics, "Timeline of wars" - https://en.wikipedia.org/wiki/Timeline_of_wars).

**Note: We modified our original event dataset to focus only on the events that are significantly related to U.S.** The pandemics/epidemics selected in this dataset are based on the article "The Worst Outbreaks in U.S. History"[^2].

### Consumer Price Index (CPI)
* CPI for US from 1913-present - https://beta.bls.gov/dataViewer/view/timeseries/CUUR0000SA0
* CPI for G20 countries from 1915-present -  https://stats.oecd.org/Index.aspx?DataSetCode=G20_PRICES# 

Consumer price index represents the change in prices that consumers are paying for common household goods, 
including food, gas, and prescription drugs.

The US CPI data set comes from the United States Bureau of Labor Statistics website, which has data available
from 1913 through the present year.  The values are relative to each other. That is, rather than discrete amounts, 
the index represents the change in prices from year to year, based on a "base index".  The base index for
this dataset is calculated by taking the average of the period from January 1982 through December 1984 and 
setting it at 100[^1].  All other index values are then given as a percentage change from that value.

### Gross Domestic Product (GDP)
* GDP for all countries from 1929-present - https://databank.worldbank.org/reports.aspx?source=2&type=metadata&series=NY.GDP.MKTP.CD#

### S&P500 and Dow Jones
* S&P500 historical monthly nominal and real (inflation adjusted) data from 1927 - https://www.macrotrends.net/2324/sp-500-historical-chart-data
* Dow Jones historical monthly nominal and real (inflation adjusted) data from 1915 - https://www.macrotrends.net/1319/dow-jones-100-year-historical-chart

## Conclusions

### Consumer Price Index (CPI) before and after Wars and Pandemics

First we plotted individual pandemics/epidemics and wars.  The year that the event ended is
set as time zero.  The plot lines end early when no data for an event exists.  For instance,
the two ongoing health events, covid-19 and HIV/AIDS, are plotted for 2021 as year zero, which
is the last year for which there is data.

Notably, the graphs for diptheria epidemic and Spanish flu look the same, because they have an
overlapping time period with the former ending in 1925 and the latter ending in 1920.  The time
period for these two events also overlap with the United States' involvement in World War I, which
lasted from 1914 to 1918.  This makes it hard to draw independent conclusions for events during
that time.
![All Pandemics](Plots/CPI/all_pandemics.png)
![All Wars](Plots/CPI/all_wars.png)

In order to get a higher level picture, we also plotted the 25% and 75% percentiles and median
of the values, as well as the mean of the values.

The quartiles for the pandemics have a wider band than the wars, meaning the pandemics follow
less of a strict pattern than the wars.  On average, the pandemics have a much smaller increase
in the rate of inflation at their end than the wars do.
![Pandemics Quartiles/Mean](Plots/CPI/pandemics_quartiles_mean.png)

Wars have a narrower range of inflation change values, except right after the end of the war.
Here, they exhibit a large range.  Looking at the individual graphs above, the events that
most notably lead to an increase in inflation in the United States were World War I and World
War II, as well as the Vietnam War.  Many of the other wars did not seem to have a noticeable
impact on inflation when they ended.
![Wars Quartiles/Mean](Plots/CPI/wars_quartiles_mean.png)

From these results, we conclude that the authors conclusions (and our hypothesis following them)
were correct on average.  Inflation tends to increase after wars end but not as noticeably after
pandemics.  However, as we've seen, this is far from guaranteed.

### Gross Domestic Product (GDP) before and after Wars and Pandemics

**1. Overall GDP and subcategories (Personal consumption expenditures, Gross private domestic investment and Government consumption expenditures and gross investment)**
![alt text](Plots/GDP/HIV%20AIDS%20pandemic.png)

Take the ongoing HIV pandemic as an example, all indexes exhibit a gradually increasing pattern throughout the years. Personal consumption expenditure takes up the majority of proportion of GDP, 
while Gross private domestic investment and government consumption stays more stable and with less proportion.  

**2. Pandemics Vs. Wars**
* GDP fluctuations for SARS outbreak, Hong Kong Flu and COVID-19 pandemic:
![GDP SARS outbreak](Plots/GDP/SARS%20outbreak.png)
![GDP Hong Kong outbreak](Plots/GDP/Hong%20Kong%20Flu.png)
Pandemics appear to cause negligible effects on GDP and its sub-categories. With an exception to COVID-19 pandemic where
 Personal consumption index decrease led to a noticable drop in overall GDP. 
![GDP Covid-19 outbreak](Plots/GDP/COVID-19%20pandemic.png)

* GDP fluctuations for Korean War and World War II:
![GDP Korean War](Plots/GDP/Korean%20War.png)
GDP trends fluctuate more around war-time period compare to those for pandemics. Government consumption index increases
significantly for wars, and it leads to increases of overall GDP. For Korean War, government consumption reaches a peak before
war period and a drastic increase in the later part of World War II. 
![GDP World War II](Plots/GDP/World%20War%20II.png)


### S&P500 and Dow Jones before and after Wars and Pandemics

**Monthly historical data for S&P500 and Dow Jones are used in the plots below. x = 0 is the January of the selected "Year Zero".** 

1. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and Dow Jones historical data 10 years before and after the zero point year, plots would be:

* The evolution of real SP500 and Dow Jones 10 years before and after all the Pandemics:
['Asian Flu', 'Hong Kong Flu', 'London flu', 'Russian flu', 'HIV/AIDS pandemic', 'SARS outbreak', 'Swine flu pandemic']
![SP500 DJ Pandemics](Plots/StockIndex/10y_year_before_end_year_real_all_pandemics.png)

* The evolution of real SP500 and Dow Jones 10 years before and after all the Wars:
['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'War on Terror', 'Iraq War', 'War in Somalia']
![SP500 DJ Wars](Plots/StockIndex/10y_year_before_end_year_real_all_wars.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Pandemics with over 1m fatalities:
['Asian Flu', 'Hong Kong Flu', 'HIV/AIDS pandemic']
![SP500 DJ High Fatality Pandemics](Plots/StockIndex/10y_year_before_end_year_real_pandemics_over_1m_fatalities.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Wars with over 1m fatalities:
['Korean War', 'Vietnam War', 'World War II', 'War in Somalia']
![SP500 DJ High Falality Wars](Plots/StockIndex/10y_year_before_end_year_real_wars_over_1m_fatalities.png)

In the above plots, I used the year before the formal end of wars and pandemics as the year 0, which is the segment within the dashed lines. The 0 in the x-axis is the January of Year 0. Then, we plotted the percentage change of indexes 10 years before and after the year 0 to see whether these indexes would be impacted by the occurrence of wars/pandemics.
From the plots, we can see (1) during the years after the formal end of severe pandemics with over 1 million fatalities, the volatility of S&P 500 and Dow Jones increases; (2) After the end of wars, there was usually a dip of these indexes; (3) The percentage change of S&P 500 and Dow Jones are closely related to each other; (4) In a long term, the inflation adjusted indexes was NOT significantly impacted by wars and pandemics.

2. If we use the event start year as zero point, and select the real SP500 and Dow Jones historical data 5 years before and after the zero point year, plots would be

* The evolution of real SP500 and Dow Jones 5 years before and after all the Pandemics:
![SP500 DJ All Pandemics](Plots/StockIndex/5y_start_year_real_all_pandemics.png)

* The evolution of real SP500 and Dow Jones 5 years before and after all the Wars:
![SP500 DJ All Wars](Plots/StockIndex/5y_start_year_real_all_wars.png)

* The evolution of real SP500 and Dow Jones 5 years before and after Pandemics with over 1m fatalities:
![SP500 DJ High Fatality Pandemics](Plots/StockIndex/5y_start_year_real_pandemics_over_1m_fatalities.png)

* The evolution of real SP500 and Dow Jones 5 years before and after Wars with over 1m fatalities:
![SP500 DJ High Fatality Wars](Plots/StockIndex/5y_start_year_real_wars_over_1m_fatalities.png)

In the above plots, I used the start year of wars and pandemics as year 0 and plotted the historical percentage change of indexes 5 years before and after the year 0 to explore the volatility of these indexes after the start of wars and pandemics.
We can see there was no significant change happened after the start of wars and pandemics.

**Therefore, I would reject our original hypotheses.**

## Selective Compilation (Numba and Cython)

Without any selective compilation, the program took about 43.99 seconds on an initial sample run.

We initially intended to try numba compilation on the read_event_facts(), which uses numpy.setdiff1d(), since numba primarily improves numpy functionality.  However, once applying it, numba took issue with the try/except code catching different kinds of exceptions, and that led to us researching and reading that numba has only the barest exception handling support.[^3].  Handling different kinds of exceptions in read_event_facts() function was desirable and thus numba was not a good option.

Next we followed the PyCharm instructions for compiling with cython.[^4]  Without any help with static typing, only compiling the code as is from a .pyx file, a sample run of the program took 24.7 seconds.  Profiling showed that analyze_index(), output_sp_dj(), plot_sp_dj(), and add_mean_and_quartiles() took the most time.  As these were primarily pandas and plotting, they did not easily take to static typing.  The helper functions min_max_year_checking() and read_event_facts() seemed to be more readily adapted, but on attempting that,  we better understood the static typing inside a function is for variables declared inside the function rather than the parameters.  get_gdp_info() is the only function where we save new variables inside of the function, so we added static typing there.  After recompiling, a sample run took 21.7 samples.

However, sample running times varied greatly, and so these numbers are only provided as examples.

## References
[^1]: https://www.bls.gov/cpi/questions-and-answers.htm#Question_17
[^2]: https://www.healthline.com/health/worst-disease-outbreaks-history
[^3]: https://numba.pydata.org/numba-doc/dev/reference/pysupported.html#pysupported-exception-handling
[^4]: https://www.jetbrains.com/help/pycharm/cython.html#get-started-cython
