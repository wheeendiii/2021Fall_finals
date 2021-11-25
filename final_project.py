"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila
"""
import numpy as np
import pandas as pd
from datetime import date
from typing import Union
import matplotlib
import matplotlib.pyplot as plt


def read_worlddb_gdp(filename: str, min_year: Union[int, str, None] = None, max_year: Union[int, str, None] = None,
                     countries: Union[list, None] = None) -> pd.DataFrame:
    """ Takes a csv file from the World Data Bank containing GDP information from various countries.  Original data
    can be obtained from https://databank.worldbank.org/reports.aspx?source=2&type=metadata&series=NY.GDP.MKTP.CD#

    :param countries: A list of countries to include, using their country codes
    :param min_year: The starting year to include data from (otherwise data from the beginning to max_year is returned)
    :param max_year: The ending year to include data from (otherwise data from min_year to current is returned)
    :param filename: The World Data Bank csv file of GDP data
    :return: A pandas dataframe containing the GDP data for the countries and years specified

    >>> read_worlddb_gdp('test.txt')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    FileNotFoundError: [Errno 2] No such file or directory: 'test.txt'
    >>> read_worlddb_gdp('data/WorldDataBank-GDP.csv', min_year=2000, max_year=1980)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid years: Minimum year must be less than maximum year.
    >>> read_worlddb_gdp('data/WorldDataBank-GDP.csv', min_year=1910)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid minimum year: Minimum year cannot be less than 1960.  No data available.
    >>> read_worlddb_gdp('data/WorldDataBank-GDP.csv', max_year=3000)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid maximum year: Maximum year cannot be greater than the year before the current one.
    >>> df = read_worlddb_gdp('data/WorldDataBank-GDP.csv')
    >>> df.head()  # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
         Country Name Country Code  ...              2019              2020
    0     Afghanistan          AFG  ...  19291104007.6135  19807067268.1084
    1         Albania          ALB  ...  15286612572.6895  14799615097.1008
    2         Algeria          DZA  ...  171157803367.473  145163902228.168
    3  American Samoa          ASM  ...         638000000               NaN
    4         Andorra          AND  ...  3155065487.51819               NaN
    <BLANKLINE>
    [5 rows x 63 columns]
    >>> df.tail()  # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
                                       Country Name  ...              2020
    261                          Sub-Saharan Africa  ...  1687597704644.75
    262  Sub-Saharan Africa (excluding high income)  ...  1686475026320.97
    263   Sub-Saharan Africa (IDA & IBRD countries)  ...  1687597704644.75
    264                         Upper middle income  ...  23104877770162.5
    265                                       World  ...  84577962952008.3
    <BLANKLINE>
    [5 rows x 63 columns]
    >>> df = read_worlddb_gdp('data/WorldDataBank-GDP.csv', countries=['IRL', 'IMN', 'GBR'])
    >>> df.head()  # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
           Country Name Country Code  ...              2019              2020
    93          Ireland          IRL  ...  399122063504.148  425888950992.003
    94      Isle of Man          IMN  ...               NaN               NaN
    205  United Kingdom          GBR  ...  2830813507746.87  2707743777173.91
    <BLANKLINE>
    [3 rows x 63 columns]
    >>> df = read_worlddb_gdp('data/WorldDataBank-GDP.csv', min_year=1984, max_year=1985)
    >>> df.head()
         Country Name Country Code              1984              1985
    0     Afghanistan          AFG               NaN               NaN
    1         Albania          ALB  1857338011.85488  1897050133.42015
    2         Algeria          DZA  53698278905.9678  57937868670.1937
    3  American Samoa          ASM               NaN               NaN
    4         Andorra          AND  330070689.298282  346737964.774951
    >>> df = read_worlddb_gdp('data/WorldDataBank-GDP.csv', min_year=1975, max_year=1975, countries=['USA'])
    >>> print(df)
          Country Name Country Code           1975
    206  United States          USA  1684904000000
    """

    if min_year:
        min_year = int(min_year)
        if min_year < 1960:
            raise ValueError('Invalid minimum year: Minimum year cannot be less than 1960.  No data available.')
    if max_year:
        max_year = int(max_year)
        if max_year > (date.today().year - 1):
            raise ValueError('Invalid maximum year: Maximum year cannot be greater than the year before the'
                             ' current one.')

    # Double-check we haven't been given something invalid for years
    if (min_year and max_year) and (min_year > int(max_year)):
        raise ValueError('Invalid years: Minimum year must be less than maximum year.')

    # Rather than specifying by year, be more usable for the future by dropping unneeded columns
    df = pd.read_csv(filename, header=0,
                     dtype={'Country Name': 'string', 'Country Code': 'string'})
    df.drop(columns=['Series Name', 'Series Code'], inplace=True)

    # Trim off the excess year header data (e.g. [YR1971]), and set correct type for the years
    col_names = list(df.columns)
    year_type_dict = {}
    for i, name in enumerate(col_names):
        if name.endswith(']'):
            col_names[i] = int(col_names[i].split(' ')[0])
            year_type_dict[col_names[i]]: 'int16'
    df.columns = col_names
    df = df.astype(year_type_dict)

    df = df[df['Country Code'].notna()]  # Drop rows without country codes
    df = df.replace('..', np.nan)  # Convert the '..'s to NaNs

    if countries:
        countries = [c.upper() for c in countries]  # Make sure all country codes are uppercase
        relevant_countries = df['Country Code'].isin(countries)  # Filter down to the ones we want
        df = df[relevant_countries]

    if max_year:
        max_year_pos = df.columns.get_loc(int(max_year))
        df = df.iloc[:, 0:(max_year_pos + 1)]

    # Minimum year is trickier because we need to keep country info in the first two cols
    if min_year:
        min_year_pos = df.columns.get_loc(int(min_year))
        df_right = df.iloc[:, min_year_pos:]  # Grab the year columns
        df_left = df.iloc[:, 0:2]  # These are the country name and country code

        # Append the year columns on the right to the country name/codes on the left
        df_left[df_right.columns] = df_right.values
        df = df_left

    return df


def add_time_range(e_df: pd.DataFrame, t0: str, length: int) -> pd.DataFrame:
    """
    This function is used to add two columns ("y_start", "y_end") into the event_fact dataframe based on the selection
    of year t0 and the number of years before and after year t0 for further plotting and study.
    :param e_df: the pd.DataFrame storing the event facts
    :param t0: the specific year used as the zero point in selecting the time range, the value of t0 could be one of
    ["start year", "end year", "the year before end year", "the year after start year"]
    :param length: the number of years to study before and after t0
    :return: the event facts dataframe with two extra columns storing the start year and end year for further study
    """
    zero_points = ["start_year", "end_year", "year_before_end_year", "year_after_start_year"]
    for t0 in zero_points:
        if t0 == zero_points[0]:
            y0 = e_df["Start_Year"]
        elif t0 == zero_points[1]:
            y0 = e_df["End_Year"]
        elif t0 == zero_points[2]:
            y0 = e_df["End_Year"] - 1
        else:
            y0 = e_df["Start_Year"] + 1
        e_df["y_start"] = y0 - length
        e_df["y_end"] = y0 + length - 1
    return e_df


def get_sp_dj(df_selected: pd.DataFrame, df_sp_dj: pd.DataFrame, data_type: str) -> pd.DataFrame:
    """
    Get the selected type ("nominal" or "real") of sp_500 and dow_jones monthly data for the selected events.
    :param df_selected: the selected events dataframe
    :param df_sp_dj: the given sp_dj historical data
    :param data_type: could be "nominal" or "real"("real" is inflation adjusted "nominal" index data)
    :return: the dataframe of sp_500 and dow_jones data from y_start year to y_end year for each selected events
    """
    sp_dj_dict = {}
    df_selected = df_selected.loc[df_selected["y_start"] >= 1928]  # the earliest data for sp_dj is in 1927/12
    df_selected = df_selected.loc[df_selected["y_end"] < 2021]  # the latest data for sp_dj is in 2021/11
    event_list = df_selected["Event_Name"].tolist()
    print(event_list)
    for event in event_list:
        row = df_selected[df_selected["Event_Name"] == event]
        start = row["y_start"].values[0]
        end = row["y_end"].values[0]
        df_sp_dj["year"] = df_sp_dj["year"].astype(int)
        sp_dj_selected = df_sp_dj.loc[df_sp_dj["year"] >= start]
        sp_dj_selected = sp_dj_selected[sp_dj_selected["year"] <= end]
        if data_type == "nominal":
            sp_change = sp_dj_selected["nominal_sp500"].pct_change().tolist()
            dj_change = sp_dj_selected["nominal_dj"].pct_change().tolist()
        else:
            sp_change = sp_dj_selected["real_sp500"].pct_change().tolist()
            dj_change = sp_dj_selected["real_dj"].pct_change().tolist()
        sp_dj_dict[event + "_sp500"] = sp_change
        sp_dj_dict[event + "_dj"] = dj_change
    final_df = pd.DataFrame.from_dict(sp_dj_dict)
    final_df = final_df.iloc[1:, :]  # drop first row in the dataframe since the values are NA
    return final_df

def plot_sp_dj(df_plot: pd.DataFrame, year_num: int):
    """
    Plot the given sp500 and dow jones for selected events dataframe.
    :param df_plot: the dataframe with sp500 and dow jones data for selected events
    :param year_num: the years before and after the selected zero point
    :return: plot of the given dataframe
    """
    df_plot.index = df_plot.index - (12 * year_num)
    fig, ax = plt.subplots(figsize=(15, 10))
    ax.plot(df_plot)
    ax.set_xlim(-12 * year_num + 1, 12 * year_num)
    ax.set_xlabel(str(year_num) + " Year Before and After Events")
    ax.set_ylabel("Change of Stock Market Index")
    plt.show()


def output_sp_dj(df_e: pd.DataFrame, df_market: pd.DataFrame, zero_point: str, year_l: int, d_type: str):
    df_e = add_time_range(df_e, zero_point, year_l)
    print("The evolution of {} SP500 and Dow Jones {} years before and after all the Pandemics:".format(d_type, year_l))
    selected_p = df_e.loc[df_e["Type"] == "Pandemics"]
    p_df = get_sp_dj(selected_p, df_market, d_type)
    plot_sp_dj(p_df, year_l)
    print("The evolution of {} SP500 and Dow Jones {} years before and after all the Wars:".format(d_type, year_l))
    selected_w = df_e.loc[df_e["Type"] == "War"]
    w_df = get_sp_dj(selected_w, df_market, d_type)
    plot_sp_dj(w_df, year_l)




def main():
    read_worlddb_gdp('data/WorldDataBank-GDP.csv')
    event_df = pd.read_csv("data/event_facts.csv")
    event_df["duration"] = event_df["End_Year"] - event_df["Start_Year"]
    sp500_df = pd.read_csv("data/sp500_monthly.csv").rename(columns={"real": "real_sp500", "nominal": "nominal_sp500"})
    dj_df = pd.read_csv("data/dow_jone_monthly.csv").rename(columns={"real": "real_dj", "nominal": "nominal_dj"})
    sp_dj = pd.merge(sp500_df, dj_df, on='date')
    sp_dj["date"] = pd.to_datetime(sp_dj["date"], format='%Y-%m-%d')
    sp_dj["year"] = sp_dj["date"].dt.year
    return output_sp_dj(event_df, sp_dj, "year_before_end_year", 10, "real")


if __name__ == '__main__':
    main()
