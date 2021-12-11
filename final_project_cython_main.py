"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila

Reads in event data about pandemics and wars, as well as data from the United States Consumer Price Index (CPI),
Gross Domestic Product (GPD), and stock market S&P500 and Dow Jones.  Then creates a series of plots combining
these data sets.

This version uses compiled cython functions.
"""

from final_project_cython import *


def main():
    """
    Main function for starting all data processing and plotting
    :return: None
    """
    us_cpi_data = 'data/bls_us_cpi.csv'
    events_data = 'data/event_facts.csv'
    sp500_data = 'data/sp500_monthly.csv'
    dowjones_data = 'data/dow_jone_monthly.csv'
    us_gdp_data = 'data/gdp_usafacts.csv'

    analyze_index(sp500_data, dowjones_data, events_data)
    analyze_gdp(us_gdp_data, events_data)
    pandemics_cpi_df, wars_cpi_df = analyze_cpi(us_cpi_data, events_data, 10, 'end_year')
    plot_all_cpi_graphs(pandemics_cpi_df, wars_cpi_df)


if __name__ == '__main__':
    main()
