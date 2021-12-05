"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila
"""
import numpy as np
import pandas as pd
from datetime import date
from typing import Union, Literal
import matplotlib.pyplot as plt


def trim_to_years(df: pd.DataFrame, start_year: int, end_year: int, year_col_name: str = 'Year') -> pd.DataFrame:
    """

    :param df: A dataframe with some type of year column
    :param year_col_name: The name of the column holding the years (defaults to 'Year')
    :param start_year: The beginning of the years to include
    :param end_year: The last year to include
    :return: An updated dataframe with only the years between the two specified
    >>> df = pd.DataFrame({'Years': list(range(1990, 2001)), 'Values': list(range(0, 21, 2))})
    >>> trim_to_years(df, 2000, 1999, 'Years')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid years: end_year cannot be less than start_year.
    >>> results = trim_to_years(df, 1995, 2020, 'Years')
    >>> print(results)
        Years  Values
    5    1995      10
    6    1996      12
    7    1997      14
    8    1998      16
    9    1999      18
    10   2000      20
    >>> results = trim_to_years(df, 1900, 1910, 'Years')
    >>> len(results)
    0
    """
    if end_year < start_year:
        raise ValueError('Invalid years: end_year cannot be less than start_year.')

    df_selected = df.loc[df[year_col_name] >= start_year]
    df_selected = df_selected[df_selected[year_col_name] <= end_year]

    return df_selected


def min_max_year_checking(min_year: int = None, min_year_possible: int = None, max_year: Union[int, None] = None,
                          max_year_possible: int = None) -> None:
    """ Throws an error if a given minimum year is less than a minimum year possible, maxinum year is greater than a
    maximum year possible (or the current year, if none given), or if the minimum year is greater than the maximum year.

    :param min_year: The minimum year value to check
    :param min_year_possible: The lowest possible year
    :param max_year: The maximum year value to check
    :param max_year_possible: The maximum possible year
    :return: None but raises a ValueError if one of the criteria isn't met

    >>> min_max_year_checking(min_year=2000, max_year=1980)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid years: Minimum year must be less than maximum year.
    >>> min_max_year_checking(min_year=1910, min_year_possible=1960)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid minimum year: Minimum year cannot be less than 1960.
    >>> min_max_year_checking(min_year=3000)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid minimum year: Minimum year cannot be greater than 2021.
    >>> min_max_year_checking(max_year=3000)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid maximum year: Maximum year cannot be greater than 2021.
    >>> min_max_year_checking(min_year=1950, max_year=1930)   # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid years: Minimum year must be less than maximum year.
    """
    curr_year = date.today().year

    if min_year:
        if min_year_possible and min_year < min_year_possible:
            raise ValueError('Invalid minimum year: Minimum year cannot be less than {}.'.format(min_year_possible))
        elif min_year > curr_year:
            raise ValueError('Invalid minimum year: Minimum year cannot be greater than {}.'.format(curr_year))
    if max_year:
        # Set maximum year to the current year if none given
        if not max_year_possible:
            max_year_possible = curr_year
        if max_year > max_year_possible:
            raise ValueError('Invalid maximum year: Maximum year cannot be greater than {}.'.format(max_year_possible))

    # Double-check we haven't been given something invalid for years
    if (min_year and max_year) and (min_year > max_year):
        raise ValueError('Invalid years: Minimum year must be less than maximum year.')


def read_worlddb_gdp(filename: str, min_year: Union[int, None] = None, max_year: Union[int, None] = None,
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

    # Raise an error if the years requested are outside of the year bounds
    min_max_year_checking(min_year=min_year, min_year_possible=1960, max_year=max_year,
                          max_year_possible=(date.today().year - 1))

    # Rather than specifying by year, be more usable for the future by dropping unneeded columns
    df = pd.read_csv(filename, header=0, dtype={'Country Name': 'string', 'Country Code': 'string'})
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


def read_us_cpi(filename: str, min_year: Union[int, None] = None, max_year: Union[int, None] = None) -> pd.DataFrame:
    """ Loads a CVS file with CPI information from the US Bureau of Labor Statistics into a Pandas dataframe.  Also
    averages all the month values for each year in order to only return one value for each year.
    Data sets available at https://beta.bls.gov/dataViewer/view/timeseries/CUUR0000SA0

    :param filename:
    :param min_year:
    :param max_year:
    :return:

    >>> read_us_cpi('test.txt')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    FileNotFoundError: [Errno 2] No such file or directory: 'test.txt'
    >>> df = read_us_cpi('data/bls_us_cpi.csv', min_year=2015)
    >>> df.head()
         Year    Value
    102  2015  237.000
    103  2016  240.000
    104  2017  245.125
    105  2018  251.125
    106  2019  255.625
    >>> df = read_us_cpi('data/bls_us_cpi.csv', max_year=1950)
    >>> df.tail()
        Year      Value
    33  1946  19.515625
    34  1947  22.328125
    35  1948  24.046875
    36  1949  23.812500
    37  1950  24.062500
    >>> df = read_us_cpi('data/bls_us_cpi.csv', min_year=1990, max_year=1993)
    >>> print(df)
        Year    Value
    77  1990  130.625
    78  1991  136.250
    79  1992  140.250
    80  1993  144.500
    """

    # Raise an error if the years requested are outside of the year bounds
    if min_year or max_year:
        min_max_year_checking(min_year=min_year, max_year=max_year)

    df = pd.read_csv(filename, header=0, usecols=['Year', 'Value'], dtype={'Year': 'int16', 'Value': 'float16'})

    # Calculate the averages for each year, and keep year as a column, not an index
    df = df.groupby('Year').mean()
    df.reset_index(inplace=True)

    # If either minimum or maximum year was specified, filter down on these
    if min_year or max_year:
        # Find the minimum and maximum years if one of these wasn't given as a parameter
        if not min_year:
            min_year = int(df['Year'].min())
        elif not max_year:
            max_year = int(df['Year'].max())

        df = df[df['Year'] >= min_year]
        df = df[df['Year'] <= max_year]

    return df


def read_event_facts(filename: str, types: Union[str, list] = None, ranges: Union[str, list] = None,
                     min_start_year: Union[int, None] = None, max_start_year: Union[int, None] = None,
                     min_end_year: Union[int, None] = None, max_end_year: Union[int, None] = None) -> pd.DataFrame:
    """ Reads in a csv file of events with the below format and optionally filters it by years, types, and ranges.
    Converts it into a Pandas dataframe and returns it after calculating a Duration column

    Event_Name	  Type	    Range	                Start_Year	End_Year	Fatalities
    Spanish Flu	  Pandemics	Worldwide	            1918	    1920	    >100m
    Asian Flu	  Pandemics	Worldwide	            1957	    1958	    1-10m
    Hong Kong Flu Pandemics	Worldwide	            1968	    1970	    1-10m
    London flu	  Pandemics	Include United States	1972	    1973	    <10,000

    :param filename: The csv file to read in
    :param type: The types of events
    :param range: The geographical range impacted
    :param min_start_year: Minimum start year to filter by
    :param max_start_year: Maximum start year to filter by
    :param min_end_year: Minimum end year to filter by
    :param max_end_year: Maximum end year to filter by
    :return: A pandas dataframe from the events file

    >>> read_event_facts('test.txt')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    FileNotFoundError: [Errno 2] No such file or directory: 'test.txt'
    >>> read_event_facts('data/event_facts.csv', min_start_year=2022)  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid start year value(s):  Invalid minimum year: Minimum year cannot be greater than 2021.
    >>> read_event_facts('data/event_facts.csv', min_end_year=1950, max_end_year=1930)  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid end year value(s):  Invalid years: Minimum year must be less than maximum year.
    >>> read_event_facts('data/event_facts.csv', types='Historical Events')
    Traceback (most recent call last):
    ...
    ValueError: Invalid type(s) given: Historical Events. Valid type(s): Pandemics, War
    >>> read_event_facts('data/event_facts.csv', ranges='South America')
    Traceback (most recent call last):
    ...
    ValueError: Invalid range(s) given: South America. Valid ranges(s): Worldwide, Include United States
    >>> df = read_event_facts('data/event_facts.csv', ranges='Worldwide', types=['War'])
    >>> df
          Event_Name Type      Range  Start_Year  End_Year Fatalities  Duration
    12   World War I  War  Worldwide        1914      1918    10-100m         4
    15  World War II  War  Worldwide        1939      1945      >100m         6
    >>> df = read_event_facts('data/event_facts.csv', min_start_year=1900, max_end_year=1930)
    >>> df[['Event_Name', 'Start_Year', 'End_Year']]
                             Event_Name  Start_Year  End_Year
    0   Encephalitis Lethargic Pandemic        1915      1926
    1                       Spanish Flu        1918      1920
    12                      World War I        1914      1918
    >>> df = read_event_facts('data/event_facts.csv', max_start_year=1990, min_end_year=1991)
    >>> df[['Event_Name', 'Start_Year', 'End_Year']]
               Event_Name  Start_Year  End_Year
    6   HIV AIDS pandemic        1981      2021
    16           Gulf War        1990      1991
    """

    # Raise an error if one of the optional year parameters given is invalid
    try:
        min_max_year_checking(min_year=min_start_year, max_year=max_start_year)
    except ValueError as e:
        raise ValueError('Invalid start year value(s):  {}'.format(str(e)))
    try:
        min_max_year_checking(min_year=min_end_year, max_year=max_end_year)
    except ValueError as e:
        raise ValueError('Invalid end year value(s):  {}'.format(str(e)))

    df = pd.read_csv(filename, usecols=['Event_Name', 'Type', 'Range', 'Start_Year', 'End_Year', 'Fatalities'],
                     dtype={'Event_Name': 'string', 'Type': 'string', 'Range': 'string', 'Start_Year': 'int16',
                            'End_Year': 'int16', 'Fatalities': 'string'})

    # If types were given, convert to a list and error if invalid ones are given
    if types:
        if isinstance(types, str):
            types = [types]

        # Find any given types that are not actually present in the dataset
        valid_types = list(df['Type'].unique())
        invalid_types = np.setdiff1d(types, valid_types)
        if len(invalid_types) > 0:
            raise ValueError('Invalid type(s) given: ' + ', '.join(invalid_types) + '. Valid type(s): ' +
                             ', '.join(valid_types))

        relevant_types = df['Type'].isin(types)  # Filter down to the ones we want
        df = df[relevant_types]

    # If ranges are given, convert to a list and error if invalid ones are given
    if ranges:
        if isinstance(ranges, str):
            ranges = [ranges]

        # Find any given types that are not actually present in the dataset
        valid_ranges = list(df['Range'].unique())
        invalid_ranges = np.setdiff1d(ranges, valid_ranges)
        if len(invalid_ranges) > 0:
            raise ValueError('Invalid range(s) given: ' + ', '.join(invalid_ranges) + '. Valid ranges(s): ' +
                             ', '.join(valid_ranges))

        relevant_ranges = df['Range'].isin(ranges)  # Filter down to the ones we want
        df = df[relevant_ranges]

    # Filter by starting year if applicable
    if min_start_year or max_start_year:
        # Find the minimum and maximum years if one of these wasn't given as a parameter
        if not min_start_year:
            min_start_year = int(df['Start_Year'].min())
        elif not max_start_year:
            max_start_year = int(df['Start_Year'].max())

        df = df[df['Start_Year'] >= min_start_year]
        df = df[df['Start_Year'] <= max_start_year]

    # Filter by ending year if applicable
    if min_end_year or max_end_year:
        # Find the minimum and maximum years if one of these wasn't given as a parameter
        if not min_end_year:
            min_end_year = int(df['End_Year'].min())
        elif not max_end_year:
            max_end_year = int(df['End_Year'].max())

        df = df[df['End_Year'] >= min_end_year]
        df = df[df['End_Year'] <= max_end_year]

    # Add duration column
    df["Duration"] = df["End_Year"] - df["Start_Year"]

    return df


def add_time_range(e_df: pd.DataFrame, t0: Literal['start_year', 'end_year', 'year_before_end_year', 'year_after_start_year'], length: int) -> pd.DataFrame:
    """
    This function is used to add two columns ("y_start", "y_end") into the event_fact dataframe based on the selection
    of year t0 and the number of years before and after year t0 for further plotting and study.
    :param e_df: the pd.DataFrame storing the event facts
    :param t0: the specific year used as the zero point in selecting the time range, the value of t0 could be one of
    ["start year", "end year", "the year before end year", "the year after start year"]
    :param length: the number of years to study before and after t0
    :return: the event facts dataframe with two extra columns storing the start year and end year for further study
    >>> df = pd.DataFrame({'Events': ['Event A', 'Event B', 'Event C'], 'Start_Year': [1950, 1999, 2001], \
                           'End_Year': [1950, 2000, 2010]})
    >>> add_time_range(df, 'invalid_input', 5)  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: y0 must be one of start_year, end_year, year_before_end_year, year_after_start_year
    >>> result = add_time_range(df, 'start_year', 5)
    >>> result.head()
        Events  Start_Year  End_Year  y_start  y_end
    0  Event A        1950      1950     1945   1955
    1  Event B        1999      2000     1994   2004
    2  Event C        2001      2010     1996   2006
    >>> result = add_time_range(df, 'end_year', 5)
    >>> result.head()
        Events  Start_Year  End_Year  y_start  y_end
    0  Event A        1950      1950     1945   1955
    1  Event B        1999      2000     1995   2005
    2  Event C        2001      2010     2005   2015
    >>> result = add_time_range(df, 'year_after_start_year', 2)
    >>> result.head()
        Events  Start_Year  End_Year  y_start  y_end
    0  Event A        1950      1950     1949   1953
    1  Event B        1999      2000     1998   2002
    2  Event C        2001      2010     2000   2004
    >>> result = add_time_range(df, 'year_before_end_year', 0)
    >>> result.head()
        Events  Start_Year  End_Year  y_start  y_end
    0  Event A        1950      1950     1949   1949
    1  Event B        1999      2000     1999   1999
    2  Event C        2001      2010     2009   2009
    """
    zero_points = ["start_year", "end_year", "year_before_end_year", "year_after_start_year"]

    # Select starting year (y0) based on the t0 parameter
    if t0 == zero_points[0]:
        y0 = e_df["Start_Year"]
    elif t0 == zero_points[1]:
        y0 = e_df["End_Year"]
    elif t0 == zero_points[2]:
        y0 = e_df["End_Year"] - 1
    elif t0 == zero_points[3]:
        y0 = e_df["Start_Year"] + 1
    else:
        raise ValueError('y0 must be one of ' + ', '.join(zero_points))

    e_df["y_start"] = y0 - length
    e_df["y_end"] = y0 + length
    e_df.astype({'y_start': 'int16', 'y_end': 'int16'})

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

        # Find the beginning and end years
        start = row["y_start"].values[0]
        end = row["y_end"].values[0]
        df_sp_dj["year"] = df_sp_dj["year"].astype(int)

        # Select all SP500/DJ values between the two beginning and ending years
        sp_dj_selected = df_sp_dj.loc[df_sp_dj["year"] >= start]
        sp_dj_selected = sp_dj_selected[sp_dj_selected["year"] <= end]

        # Calculate the percentage changes
        if data_type == "nominal":
            sp_change = sp_dj_selected["nominal_sp500"].pct_change().tolist()
            dj_change = sp_dj_selected["nominal_dj"].pct_change().tolist()
        else:
            sp_change = sp_dj_selected["real_sp500"].pct_change().tolist()
            dj_change = sp_dj_selected["real_dj"].pct_change().tolist()

        # Add all the resulting values to the dict, by event
        sp_dj_dict[event + "_sp500"] = sp_change
        sp_dj_dict[event + "_dj"] = dj_change

    # Add the dict to the dataframe
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
    print("The evolution of {} SP500 and Dow Jones {} years before and after Pandemics with over 1m fatalities:"
          .format(d_type, year_l))
    selected_1m = df_e.loc[df_e.Fatalities.isin(["1-10m", "10-100m", ">100m"])]
    selected_1m_p = selected_1m.loc[selected_1m["Type"] == "Pandemics"]
    p_df_1 = get_sp_dj(selected_1m_p, df_market, d_type)
    plot_sp_dj(p_df_1, year_l)
    print("The evolution of {} SP500 and Dow Jones {} years before and after Wars with over 1m fatalities:"
          .format(d_type, year_l))
    selected_1m_w = selected_1m.loc[selected_1m["Type"] == "War"]
    w_df_1 = get_sp_dj(selected_1m_w, df_market, d_type)
    plot_sp_dj(w_df_1, year_l)


def analyze_cpi(us_cpi_file: str, events_file: str, verbose: Union[bool, None] = False) -> None:
    """
    # TODO

    :param us_cpi_file:
    :param events_file:
    :param verbose: Indicates whether to print debugging information
    :return:
    """
    us_cpi_df = read_us_cpi(us_cpi_file)
    min_cpi_year = us_cpi_df['Year'].min()

    pandemics_df = read_event_facts(events_file, types='Pandemics', min_start_year=min_cpi_year,
                                    min_end_year=min_cpi_year)
    wars_df = read_event_facts(events_file, types='War', min_start_year=min_cpi_year, min_end_year=min_cpi_year)

    # Add the start and end years for plotting (
    pandemics_df = add_time_range(pandemics_df, 'end_year', 10)
    wars_df = add_time_range(pandemics_df, 'end_year', 10)

    # Add the individual values for those years
    add_cpi_values(pandemics_df, us_cpi_df)


def add_cpi_values(event_df: pd.DataFrame, cpi_df: pd.DataFrame) -> pd.DataFrame:
    """
    Takes a dataframe with an Event column and y_start and y_end years.. #TODO

    :param event_df: A dataframe with 'Event_Name' column, and columns with y_start and y_end years
    :param cpi_df: A dataframe with CPI data
    :return:

    >>> df = pandas.df({'Events': ['Event A', 'Event B'], 'y_start': [1960, 2007], 'y_end': [1965, 2013]})
    >>> df.head()
    """

    for _, row in event_df.iterrows():
        event = row['Event_Name']
        start = row['y_start']
        end = row['y_end']

        # Select all the CPI values between the beginning and ending years
        cpi_df_selected = trim_to_years(cpi_df, start, end, 'Year')

        # Calculate the percentage changes


def analyze_stockmarket(sp500_file: str, dowjones_file: str, events_file: str):
    """

    :param sp500_file:
    :param dowjones_file:
    :param events_file:
    :return:
    """
    event_df = read_event_facts(events_file)
    sp500_df = pd.read_csv(sp500_file).rename(columns={"real": "real_sp500", "nominal": "nominal_sp500"})
    dj_df = pd.read_csv(dowjones_file).rename(columns={"real": "real_dj", "nominal": "nominal_dj"})

    # Create a dataframe with information on both Dow Jones and SP500 by year
    sp_dj = pd.merge(sp500_df, dj_df, on='date')
    sp_dj["date"] = pd.to_datetime(sp_dj["date"], format='%Y-%m-%d')
    sp_dj["year"] = sp_dj["date"].dt.year

    print("1. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and "
          "Dow Jones historical data 10 years before and after the zero point year, plots would be")
    output_sp_dj(event_df, sp_dj, "year_before_end_year", 10, "real")


def analyze_gdp(gdp_file: str, events_file: str) -> None:
    """
    For each event, select gdp data 10 year before and after, and pass the df to plot_gdp().
    :param gdp_file: gdp data file name
    :param events_file: events file name
    :return:
    """
    # read in us gdp file
    us_gdp_df = pd.read_csv(gdp_file, header=0)

    # separate pandemics and wars gdp dataframe
    pandemics_gdp = read_event_facts(events_file, types='Pandemics')
    wars_gdp = read_event_facts(events_file, types='War')

    # get gdp_info for each pandemic/war events
    get_gdp_info(us_gdp_df, pandemics_gdp)
    get_gdp_info(us_gdp_df, wars_gdp)


def get_gdp_info(us_gdp: pd.DataFrame, df: pd.DataFrame):
    """
    Get GDP info from US GDP data for each event in df.
    :param us_gdp: US GDP data
    :param df: the gdp dataframe for selected events
    :return:
    >>> pandemics_gdp = read_event_facts('data/event_facts.csv', types='Pandemics')
    >>> us_gdp_test = pd.read_csv('data/gdp_usafacts.csv', header=0)
    >>> get_gdp_info(us_gdp_test, pandemics_gdp)
    """
    # go through event file and get start_year, end_year
    for index, row in df.iterrows():
        event_name = row['Event_Name']
        start_year = int(row['Start_Year'])
        before_event = start_year - 10
        end_year = int(row['End_Year'])
        after_event = end_year + 10

        # If start year less than min_year, start from 1929
        if start_year >= 1929:
            if end_year > 2020:
                end_year = 2020
            if after_event > 2020:
                after_event = 2020
            if before_event < 1929:
                before_event = 1929

            # Slice GDP df according to event
            event_gdp = us_gdp.loc[0, str(before_event): str(after_event)]

            # call plot_gdp for each event
            plot_gdp(event_gdp, event_name)


def plot_gdp(gdp_df: pd.DataFrame, event_name: str):
    """
    Plot gdp trend for given events.
    :param gdp_df: the gdp dataframe for selected events
    :param event_name: event name for plotting
    :param end_year: end year of an event
    :return: plot of the given dataframe
    >>> us_gdp_df = pd.read_csv('data/gdp_usafacts.csv', header=0)
    >>> event_gdp = us_gdp_df.loc[0, '1947': '1968']
    >>> plot_gdp(event_gdp, "Asian Flu")
    """

    fig, ax = plt.subplots(figsize=(15, 10))
    gdp_df= gdp_df.values.astype(int)
    ax.plot(gdp_df)

    ax.set_xlabel("Years before and after event end year")
    ax.set_ylabel("Gross domestic product ($)")
    ax.ticklabel_format(style='plain', axis='y')
    plt.title("GDP fluctuations for " + event_name)

    plt.xticks(rotation=45)  # Rotates X-Axis Ticks by 45-degrees
    plt.savefig('Plots/GDP/'+event_name+'.png')


def main():
    us_cpi_data = 'data/bls_us_cpi.csv'
    events_data = 'data/event_facts.csv'
    sp500_data = 'data/sp500_monthly.csv'
    dowjones_data = 'data/dow_jone_monthly.csv'
    us_gdp_data = 'data/gdp_usafacts.csv'

    #analyze_stockmarket(sp500_data, dowjones_data, events_data)
    analyze_cpi(us_cpi_data, events_data)
    #analyze_gdp(us_gdp_data, events_data)


if __name__ == '__main__':
    main()
