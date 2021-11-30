[![Build Status](https://app.travis-ci.com/wheeendiii/2021Fall_finals.svg?branch=main)](https://app.travis-ci.com/wheeendiii/2021Fall_finals)
# Inflation In The Aftermath Of Wars And Pandemics (Type I)

Group members: Kangyang Wang (*kangyangwang*), Wendy Zhu (*wheeendiii*), and Kay Avila (*kayavila*)

## Reference Articles:
* https://voxeu.org/article/inflation-aftermath-wars-and-pandemics
* https://www.goldmansachs.com/insights/pages/gs-research/reflation-risk/report.pdf

## Potential Questions and Improvements:

Based on the analysis of the above two articles, the authors conclude that "wars result in higher inflation and bond yields, 
pandemics do not". This conclusion is supported by several well-plotted graphs of CPI Inflation or Nominal ten-year bond 
yields around wars and pandemics. More specifically, the authors used the last year of significant fatalities as the 
end-year for wars and pandemics (Year = 0) (In a number of instances, this is one year before the formal end of the 
war/pandemics) and overlaid the historical CPI Inflation/Bond Yield data 10 years before and after the year 0 to monitor
the evolution of Inflation and Bond Yield before and after each event.

The analysis of the articles seems well organized, but we have several concerns:
* The conclusion is contradicting with what we are experiencing now. As we know, the CPI inflation rate is surging since the 
outbreak of COVID-19 and is reaching a 30-year record high recently.
* The conclusion in the article didn't consider many inner factors of the events, such as the fatalities and the duration of the events. 
Would they affect the final overall trend of the CPI Inflation and bond yield around the events?
* Is there any significant market vibrations (changes of major market indexes) before and after wars and pandemics?

## Hypotheses



## Data Sources
**Event Data** (Kangyang)

This data file is compiled from the wars and pandemics chart in the reference article "Inflation in the aftermath of wars and pandemics" (https://voxeu.org/article/inflation-aftermath-wars-and-pandemics) and the Wiki pages for wars and pandemics("List of epidemics" - https://en.wikipedia.org/wiki/List_of_epidemics, "Timeline of wars" - https://en.wikipedia.org/wiki/Timeline_of_wars).

**Consumer Price Index (CPI)** (Kay)
* CPI for US from 1913-present - https://beta.bls.gov/dataViewer/view/timeseries/CUUR0000SA0
* CPI for G20 countries from 1915-present -  https://stats.oecd.org/Index.aspx?DataSetCode=G20_PRICES# 

Consumer price index represents the change in prices that consumers are paying for common household goods, including food, gas, and prescription drugs.

The US CPI data set comes from the United States Bureau of Labor Statistics website, which has data available from 1913 through the present year.  The values are relevant to each other. That is, the rather than discrete amounts, the index represents the change in prices from year to year, based on a "base index".  The base index for this dataset is calculated by taking the average of the period from January 1982 through December 1984 and setting it at 100[^1].  All other index values are then given as a percentage change from that time period.

**Gross Domestic Product (GDP)** (Wendy)
* GDP for all countries from 1960-present - https://databank.worldbank.org/reports.aspx?source=2&type=metadata&series=NY.GDP.MKTP.CD#

**S&P500 and Dow Jones** (Kangyang)
* S&P500 historical monthly nominal and real (inflation adjusted) data from 1927 - https://www.macrotrends.net/2324/sp-500-historical-chart-data
* Dow Jones historical monthly nominal and real (inflation adjusted) data from 1915 - https://www.macrotrends.net/1319/dow-jones-100-year-historical-chart

## Conclusions

**Consumer Price Index (CPI) before and after Wars and Pandemics** (Kay)

**Gross Domestic Product (GDP) before and after Wars and Pandemics** (Wendy)

**S&P500 and Dow Jones before and after Wars and Pandemics** (Kangyang)

If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and Dow Jones historical data 10 years before and after the zero point year, plots would be:

* The evolution of real SP500 and Dow Jones 10 years before and after all the Pandemics:
['Asian Flu', 'Hong Kong Flu', 'London flu', 'Russian flu', 'HIV/AIDS pandemic', 'SARS outbreak', 'Swine flu pandemic']
![alt text](https://github.com/wheeendiii/2021Fall_finals/blob/main/Plots/plot_sp_dj_all_pandemics.png)

* The evolution of real SP500 and Dow Jones 10 years before and after all the Wars:
['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'War on Terror', 'Iraq War', 'War in Somalia']
![alt text](https://github.com/wheeendiii/2021Fall_finals/blob/main/Plots/plot_sp_dj_all_wars.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Pandemics with over 1m fatalities:
['Asian Flu', 'Hong Kong Flu', 'HIV/AIDS pandemic']
![alt text](https://github.com/wheeendiii/2021Fall_finals/blob/main/Plots/plot_sp_dj_pandemics_over_1m_fatalities.png)

* The evolution of real SP500 and Dow Jones 10 years before and after Wars with over 1m fatalities:
['Korean War', 'Vietnam War', 'World War II', 'War in Somalia']
![alt text](https://github.com/wheeendiii/2021Fall_finals/blob/main/Plots/plot_sp_dj_wars_over_1m_fatalities.png)

## References
[^1]: https://www.bls.gov/cpi/questions-and-answers.htm#Question_17
