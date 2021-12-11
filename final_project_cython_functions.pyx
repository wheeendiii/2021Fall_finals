"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila

Reads in event data about pandemics and wars, as well as data from the United States Consumer Price Index (CPI),
Gross Domestic Product (GPD), and stock market S&P500 and Dow Jones.  Then creates a series of plots combining
these data sets.
"""
import numpy as np
import pandas as pd
from datetime import date
from typing import Union, Literal
import matplotlib.pyplot as plt


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


def read_event_facts(filename: str, types: Union[str, list] = None, ranges: Union[str, list] = None,
                     min_start_year: Union[int, None] = None, max_start_year: Union[int, None] = None,
                     min_end_year: Union[int, None] = None, max_end_year: Union[int, None] = None) -> pd.DataFrame:
    """ Reads in a csv file of events with the below format and optionally filters it by years, types, and ranges.
    Converts it into a Pandas dataframe and returns it after calculating a Duration column

    Event_Name	  Type	    Range	                Start_Year	End_Year	Fatalities
    Spanish Flu	  Pandemics	Affect United States    1918	    1920	    >100m
    Asian Flu	  Pandemics	Affect United States    1957	    1958	    1-10m
    Hong Kong Flu Pandemics	Affect United States    1968	    1970	    1-10m
    London flu	  Pandemics	Affect United States    1972	    1973	    <10,000

    :param filename: The csv file to read in
    :param types: The types of events
    :param ranges: The geographical range impacted
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
    ValueError: Invalid range(s) given: South America. Valid ranges(s): Affect United States
    >>> df = read_event_facts('data/event_facts.csv', ranges='Affect United States', types=['War'])
    >>> df
                      Event_Name Type  ... Fatalities  Duration
    11               World War I  War  ...    10-100m         4
    12                Korean War  War  ...      1-10m         3
    13               Vietnam War  War  ...      1-10m        10
    14              World War II  War  ...      >100m         6
    15                  Gulf War  War  ...  10,000-1m         1
    16  Civil war in Afghanistan  War  ...  10,000-1m         5
    17             War on Terror  War  ...  10,000-1m        20
    18                  Iraq War  War  ...  10,000-1m         8
    19            War in Somalia  War  ...      1-10m        15
    <BLANKLINE>
    [9 rows x 7 columns]
    >>> df = read_event_facts('data/event_facts.csv', min_start_year=1900, max_end_year=1930)
    >>> df[['Event_Name', 'Start_Year', 'End_Year']]
                 Event_Name  Start_Year  End_Year
    0   Diphtheria epidemic        1921      1925
    2    Spanish Flu (H1N1)        1918      1920
    11          World War I        1914      1918
    >>> df = read_event_facts('data/event_facts.csv', max_start_year=1990, min_end_year=1991)
    >>> df[['Event_Name', 'Start_Year', 'End_Year']]
                     Event_Name  Start_Year  End_Year
    6   Second measles outbreak        1981      1991
    7         HIV AIDS pandemic        1981      2021
    15                 Gulf War        1990      1991
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


def add_time_range(e_df: pd.DataFrame, t0: Literal['start_year', 'end_year', 'year_before_end_year',
                                                   'year_after_start_year'], length: int,
                   add_extra_yr_before: bool = False) -> pd.DataFrame:
    """
    This function is used to add two columns ("y_start", "y_end") into the event_fact dataframe based on the selection
    of year t0 and the number of years before and after year t0 for further plotting and study.
    :param e_df: the pd.DataFrame storing the event facts
    :param t0: the specific year used as the zero point in selecting the time range, the value of t0 could be one of
    ["start year", "end year", "the year before end year", "the year after start year"]
    :param length: the number of years to study before and after t0
    :param add_extra_yr_before: Indicates whether an extra year should be added before the beginning
            (to account for pct_change)
    :return: the event facts dataframe with two extra columns storing the start year and end year for further study
    >>> df = pd.DataFrame({'Events': ['Event A', 'Event B', 'Event C'], 'Start_Year': [1950, 1999, 2001], \
                           'End_Year': [1950, 2000, 2010]})
    >>> add_time_range(df, 'invalid_input', 5)  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: y0 must be one of start_year, end_year, year_before_end_year, year_after_start_year
    >>> result = add_time_range(df, 'start_year', 5, add_extra_yr_before=True)
    >>> result.head()
        Events  Start_Year  End_Year  y_start  y_end
    0  Event A        1950      1950     1944   1955
    1  Event B        1999      2000     1993   2004
    2  Event C        2001      2010     1995   2006
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

    if add_extra_yr_before:
        e_df["y_start"] = y0 - length - 1
    else:
        e_df["y_start"] = y0 - length
    e_df["y_end"] = y0 + length
    e_df.astype({'y_start': 'int16', 'y_end': 'int16'})

    return e_df


def trim_to_years(df: pd.DataFrame, start_year: int, end_year: int, year_col_name: str = 'Year',
                  pad: Literal[None, 'zero', 'nan'] = None, pad_col_name: Union[None, str] = None) -> pd.DataFrame:
    """ Given a dataframe with a year    column, filters the dataframe down to the range created by the starting
    and ending years specified as paramters.  If a pad option is specified, then years for which data does not exist
    are padded with the value corresponding to the option.

    :param df: A dataframe with some type of year column
    :param year_col_name: The name of the column holding the years (defaults to 'Year')
    :param start_year: The beginning of the years to include
    :param end_year: The last year to include
    :param pad: Value to insert for years that have no data
    :param pad_col_name: If pad is specified, the value column in which to add padding
    :return: An updated dataframe with only the years between the two specified, with optional padding
    >>> df = pd.DataFrame({'Years': list(range(1990, 2001)), 'Values': list(range(0, 21, 2))})
    >>> trim_to_years(df, 2000, 1999, 'Years')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Invalid years: Start year must be less than end year.
    >>> trim_to_years(df, 1995, 2000, pad='none')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: If pad is specified, pad_col_name must be given.
    >>> trim_to_years(df, 1995, 2000, pad='fill', pad_col_name='Value')  # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Value for pad must be one of: zero, nan
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
    >>> results = trim_to_years(df, 1989, 1992, 'Years', pad='zero', pad_col_name='Values')
    >>> print(results)
       Years  Values
    0   1989       0
    1   1990       0
    2   1991       2
    3   1992       4
    >>> results = trim_to_years(df, 1988, 2003, 'Years', pad='nan', pad_col_name='Values')
    >>> results.tail()
        Years  Values
    11   1999    18.0
    12   2000    20.0
    13   2001     NaN
    14   2002     NaN
    15   2003     NaN
    >>> results.head()
       Years  Values
    0   1988     NaN
    1   1989     NaN
    2   1990     0.0
    3   1991     2.0
    4   1992     4.0
    """
    # Don't use min_max_year_checking() because we want to allow invalid years (for padding)
    if start_year > end_year:
        raise ValueError('Invalid years: Start year must be less than end year.')

    pad_options = {'zero': 0, 'nan': np.NaN}
    if pad:
        # Raise an error if pad is specified but no value column to pad
        if not pad_col_name:
            raise ValueError('If pad is specified, pad_col_name must be given.')
        if pad not in pad_options.keys():
            raise ValueError('Value for pad must be one of: ' + ', '.join(pad_options))
        else:
            pad_value = pad_options[pad]
            pad = True

    df_selected = df.loc[df[year_col_name] >= start_year]
    df_selected = df_selected[df_selected[year_col_name] <= end_year]

    if pad:
        # Given from above that both of these values are filled
        assert pad_value in pad_options.values()
        assert pad_col_name is not None

        # Find the first and last years for which there is data available
        min_year_possible = df[year_col_name].min()
        max_year_possible = df[year_col_name].max()

        if start_year < min_year_possible:
            start_pad_df = pd.DataFrame({year_col_name: list(range(start_year, min_year_possible)),
                                         pad_col_name: [pad_value for _ in range(start_year, min_year_possible)]})
            df_selected = pd.concat([start_pad_df, df_selected])
        if end_year > max_year_possible:
            # Slightly different from start/min, because we need to add values beginning with the next year after the
            # maximum year available, and pad through the end_year specified as a parameter
            end_pad_df = pd.DataFrame({year_col_name: list(range(max_year_possible + 1, end_year + 1)),
                                       pad_col_name: [pad_value for _ in range(max_year_possible + 1, end_year + 1)]})
            df_selected = pd.concat([df_selected, end_pad_df])

        # Reset the index so all index values are unique
        df_selected.reset_index(inplace=True, drop=True)

    return df_selected


def add_mean_and_quartiles(df: pd.DataFrame) -> pd.DataFrame:
    """
    Takes a dataframe with a series of values in columns and adds new columns for the median and quartiles.

    :param df: The dataframe with values in columns
    :return: An updated dataframe with 25pct, median, and 75pct columns

    >>> df = pd.DataFrame({'Col1': [0, 1, 2, 3], 'Col2': [1, 1, 1, 1], 'Col3': [1, 2, 4, 8]})
    >>> print(add_mean_and_quartiles(df))
       Col1  Col2  Col3      mean  median  25pct  75pct
    0     0     1     1  0.666667     1.0    0.5    1.0
    1     1     1     2  1.333333     1.0    1.0    1.5
    2     2     1     4  2.333333     2.0    1.5    3.0
    3     3     1     8  4.000000     3.0    2.0    5.5
    """
    # Get statistics on the df, then grab the appropriate columns from them
    stats_df = df.apply(pd.DataFrame.describe, axis=1)

    df['mean'] = stats_df['mean']
    df['median'] = stats_df['50%']  # median is equivalent to 50% percentile
    df['25pct'] = stats_df['25%']
    df['75pct'] = stats_df['75%']

    return df


def adjust_index(df: pd.DataFrame) -> None:
    """ Takes a dataframe with regular range index and updates it so that it goes from negative numbers from zero,
    to zero, to numbers past zero.  Only works with an odd number of rows.

    :param df: The dataframe whose index should be adjusted
    :return: None

    >>> df = pd.DataFrame().from_dict([x for x in range(0, 6)])
    >>> adjust_index(df)    # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: Dataframe provided must have an odd number of rows.
    >>> df = pd.DataFrame().from_dict([x for x in range(1, 6)])
    >>> adjust_index(df)
    >>> print(df)
        0
    -2  1
    -1  2
    0   3
    1   4
    2   5
    """
    current_index = df.index

    # This only works for an odd number of rows - throw an error if even
    if len(current_index) % 2 == 0:
        raise ValueError('Dataframe provided must have an odd number of rows.')

    range_from_zero = int(current_index.stop/2 - .5)
    df.index = pd.RangeIndex(start=range_from_zero*-1, stop=range_from_zero+1)


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


def get_gdp_info(us_gdp: pd.DataFrame, df: pd.DataFrame):
    """
    Get GDP info from US GDP data for each event in df.
    :param us_gdp: US GDP data
    :param df: the gdp dataframe for selected events
    :return:
    >>> pandemics_gdp = read_event_facts('data/event_facts.csv', types='Pandemics')
    >>> us_gdp_test = pd.read_csv('data/gdp_usafacts.csv')
    >>> get_gdp_info(us_gdp_test, pandemics_gdp)
    """
    cdef int start_year
    cdef int before_event
    cdef int end_year
    cdef int after_event

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
            event_gdp = us_gdp.loc[[0, 124, 131, 152], str(before_event): str(after_event)]
            event_gdp = event_gdp.apply(pd.to_numeric)  # convert all columns of DataFrame
            event_gdp = event_gdp.T
            event_gdp.columns = ['GDP', 'Personal consumption expenditures',
                                 'Gross private domestic investment',
                                 'Government consumption expenditures and gross investment']

            end_interval = end_year - before_event
            start_interval = start_year - before_event

            # call plot_gdp for each event
            plot_gdp(event_gdp, event_name, end_interval, start_interval)


def plot_gdp(gdp_df: pd.DataFrame, event_name: str, end_interval: int, start_interval: int):
    """
    Plot gdp trend for given events.
    :param gdp_df: the gdp dataframe for selected events
    :param event_name: event name for plotting
    :param end_interval: end year of an event
    :param start_interval: start year of an event

    :return: plot of the given dataframe
    >>> us_gdp_df = pd.read_csv('data/gdp_usafacts.csv', header=0)
    >>> event_gdp = us_gdp_df.loc[0, '1947': '1968']
    >>> event_gdp = event_gdp.to_frame()
    >>> plot_gdp(event_gdp, "Test Flu", 4, 2)
    >>> image = plt.imread('Plots/GDP/Test Flu.png')
    >>> print(image[0][0])  # doctest: +ELLIPSIS
    [1. 1. 1. 1.]

    """

    fig, ax = plt.subplots(figsize=(15, 10))
    ax.plot(gdp_df)

    ax.set_xlabel("Year")
    ax.set_ylabel("Gross domestic product ($)")
    ax.ticklabel_format(style='plain', axis='y')

    x_bounds = ax.get_xlim()
    y_bounds = ax.get_ylim()
    ax.vlines(end_interval, y_bounds[0], y_bounds[1], colors='red', linestyles='dashed')
    ax.annotate(text='End Year', xy=(end_interval + 0.5, (y_bounds[0] + y_bounds[1]) * 2 / 3))
    ax.vlines(start_interval, y_bounds[0], y_bounds[1], colors='green', linestyles='solid')
    ax.annotate(text='Start Year', xy=(start_interval - 2, (y_bounds[0] + y_bounds[1]) * 2 / 3))

    plt.title("GDP fluctuations for " + event_name)
    plt.xticks(rotation=45)  # Rotates X-Axis Ticks by 45-degrees
    plt.legend(['GDP', 'Personal consumption expenditures', 'Gross private domestic investment',
                'Government consumption expenditures and gross investment'], loc='upper left')
    plt.savefig('Plots/GDP/' + event_name + '.png')


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
         Year       Value
    102  2015  237.016998
    103  2016  240.007172
    104  2017  245.119583
    105  2018  251.106827
    106  2019  255.657425
    >>> df = read_us_cpi('data/bls_us_cpi.csv', max_year=1950)
    >>> df.tail()
        Year      Value
    33  1946  19.516666
    34  1947  22.325001
    35  1948  24.041666
    36  1949  23.808332
    37  1950  24.066668
    >>> df = read_us_cpi('data/bls_us_cpi.csv', min_year=1990, max_year=1993)
    >>> print(df)
        Year       Value
    77  1990  130.658325
    78  1991  136.191666
    79  1992  140.316666
    80  1993  144.458328
    """

    # Raise an error if the years requested are outside of the year bounds
    if min_year or max_year:
        min_max_year_checking(min_year=min_year, max_year=max_year)

    # Use float32 instead of float16 due to bug with float16 and percentages -
    #    see https://github.com/pandas-dev/pandas/issues/9220
    df = pd.read_csv(filename, header=0, usecols=['Year', 'Value'], dtype={'Year': 'int16', 'Value': 'float32'})

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


def add_cpi_values(event_df: pd.DataFrame, cpi_df: pd.DataFrame) -> pd.DataFrame:
    """ Takes a dataframe with an Event, End_Year, y_start, and y_end columns, and a dataframe with 'Year' and 'Value'
    column with CPI data, and returns a dataframe with the percentage change for each of those years for each event.
    Note: Each event must have an equal length between their start and end years

    :param event_df: A dataframe with 'Event_Name' column, and columns with 'y_start' and 'y_end' year
    :param cpi_df: A dataframe with CPI data with a 'Year' column and 'Value' column
    :return: A dataframe with the CPI percentage change for each year given for each event

    >>> args = {'Event_Name': ['Event A', 'Event B'], 'y_start': [1990, 1994], 'y_end': [2000, 2002], 'End_Year': [1992, 2001]}
    >>> events_df = pd.DataFrame(args)
    >>> cpi_df = pd.DataFrame({'Year': list(range(1990, 2002)), 'Value': [x * x for x in range(1, 13)]})
    >>> add_cpi_values(events_df, cpi_df) # doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: All events must have the same number of years between their start and end years.
    >>> args = {'Event_Name': ['Event A', 'Event B'], 'y_start': [1990, 1994], 'y_end': [2000, 2004], 'End_Year': [1992, 2002]}
    >>> events_df = pd.DataFrame(args)
    >>> df = add_cpi_values(events_df, cpi_df)
    >>> print(df)
        Event A (ended 1992)  Event B (ended 2002)
    1             300.000000             44.000000
    2             125.000000             36.111111
    3              77.777778             30.612245
    4              56.250000             26.562500
    5              44.000000             23.456790
    6              36.111111             21.000000
    7              30.612245             19.008264
    8              26.562500                   NaN
    9              23.456790                   NaN
    10             21.000000                   NaN
    """
    results = {}
    for _, row in event_df.iterrows():
        event = row['Event_Name']
        plot_start_year = row['y_start']
        plot_end_year = row['y_end']
        event_end_year = row['End_Year']

        # Select all the CPI values between the beginning and ending years
        cpi_df_selected = trim_to_years(cpi_df, plot_start_year, plot_end_year, 'Year', pad='nan', pad_col_name='Value')

        # Calculate the percentage changes.  Value must be changed to float32 away from float16 due to a bug -
        #   see https://github.com/pandas-dev/pandas/issues/9220
        if cpi_df_selected.dtypes['Value'] == 'float16':
            cpi_df_selected = cpi_df_selected.astype({'Value': 'float32'})

        # pct_change() will put in zeros from a value to NaN and we don't want that
        # Save the nan positions, calculate pct_change, and then put all the NaNs back in
        nan_value_positions = cpi_df_selected['Value'].isnull()
        percent_change_df = cpi_df_selected['Value'].pct_change() * 100
        percent_change_df[nan_value_positions] = np.nan

        results['{} (ended {})'.format(event, event_end_year)] = percent_change_df.tolist()

    # Some results will have different values because e.g. there haven't been x number of years passed since the end
    try:
        results_df = pd.DataFrame.from_dict(results)
    except ValueError:
        raise ValueError('All events must have the same number of years between their start and end years.')

    results_df = results_df.iloc[1:, :]  # drop first row in the dataframe since the values are NA
    return results_df


def get_index(df_selected: pd.DataFrame, df_index: pd.DataFrame, data_type: str) -> pd.DataFrame:
    """
    Get the selected type ("nominal" or "real") of the market index monthly data for the selected events.
    :param df_selected: the selected events dataframe
    :param df_index: the given market index historical data
    :param data_type: could be "nominal" or "real"("real" is inflation adjusted "nominal" index data)
    :return: the dataframe of the market index data from y_start year to y_end year for each selected events

    >>> s = {'Event_Name': ['Event A', 'Event B', 'Event C'], 'y_start': [1909, 1990, 1994], 'y_end': [1911, 2000, 2002]}
    >>> sdf = pd.DataFrame(s)
    >>> idf = pd.DataFrame({'year': list(range(1930, 2020)), 'nominal': [x * x * 100 for x in range(1, 91)], 'real': [y * y for y in range(1, 91)]})
    >>> get_index(sdf, idf, 'real')# doctest: +ELLIPSIS
    Traceback (most recent call last):
    ...
    ValueError: All arrays must be of the same length
    >>> s1 = {'Event_Name': ['Event A', 'Event B'], 'y_start': [1990, 1994], 'y_end': [2000, 2004]}
    >>> sdf1 = pd.DataFrame(s1)
    >>> get_index(sdf1, idf, 'real')
    ['Event A', 'Event B']
         Event A   Event B
    1   0.033056  0.031006
    2   0.032518  0.030533
    3   0.031998  0.030074
    4   0.031494  0.029628
    5   0.031006  0.029196
    6   0.030533  0.028776
    7   0.030074  0.028367
    8   0.029628  0.027971
    9   0.029196  0.027585
    10  0.028776  0.027210
    >>> get_index(sdf1, idf, 'nominal')
    ['Event A', 'Event B']
         Event A   Event B
    1   0.033056  0.031006
    2   0.032518  0.030533
    3   0.031998  0.030074
    4   0.031494  0.029628
    5   0.031006  0.029196
    6   0.030533  0.028776
    7   0.030074  0.028367
    8   0.029628  0.027971
    9   0.029196  0.027585
    10  0.028776  0.027210
    """
    index_dict = {}
    df_selected = df_selected.loc[df_selected["y_start"] >= 1928]  # the earliest data available is in 1927/12
    df_selected = df_selected.loc[df_selected["y_end"] < 2021]  # the latest data for available is in 2021/11
    event_list = df_selected["Event_Name"].tolist()
    print(event_list)
    for event in event_list:
        row = df_selected[df_selected["Event_Name"] == event]

        # Find the beginning and end years
        start = row["y_start"].values[0]
        end = row["y_end"].values[0]
        df_index["year"] = df_index["year"].astype(int)

        # Select all SP500/DJ values between the two beginning and ending years
        index_selected = trim_to_years(df_index, start, end, 'year')

        # Calculate the percentage changes
        if data_type == "nominal":
            pct_change = index_selected["nominal"].pct_change().tolist()
        else:
            pct_change = index_selected["real"].pct_change().tolist()

        # Add all the resulting values to the dict, by event
        index_dict[event] = pct_change

    # Add the dict to the dataframe
    final_df = pd.DataFrame.from_dict(index_dict)
    final_df = final_df.iloc[1:, :]  # drop first row in the dataframe since the values are NA
    return final_df


def plot_sp_dj(df1: pd.DataFrame, df2: pd.DataFrame, year_num: int, plot_name: str):
    """
    Plot the given sp500 and dow jones for selected events dataframe.
    :param df1: the dataframe with sp500 data for selected events
    :param df2: the dataframe with dow jones data for selected events
    :param year_num: the years before and after the selected zero point
    :param plot_name: the string name of the plot
    :return: plot of the given dataframe
    """
    # change index of data to make the January of "Year Zero" as 0 in x-axis.
    df1.index = df1.index - (12 * year_num)
    df2.index = df2.index - (12 * year_num)

    # get the 25 and 75 percentile bounds for plotting
    df1 = add_mean_and_quartiles(df1)
    df2 = add_mean_and_quartiles(df2)

    fig, (ax3, ax4) = plt.subplots(2, sharex=True, figsize=(10, 5))
    fig.suptitle('Change of Stock Market Indexes')
    # ax1.plot(df1, linewidth=0.5)
    # ax1.set_ylabel("Change of SP500", fontsize = 'x-small')
    # ax2.plot(df2, linewidth=0.5)
    # ax2.set_ylabel("Change of Dow Jones", fontsize = 'x-small')
    ax3.plot(df1.index, df1["75pct"], color='black', label='75% percentile', linewidth=0.5)
    ax3.plot(df1.index, df1["25pct"], color='black', label='25% percentile', linewidth=0.5)
    ax3.plot(df1.index, df1["median"], '--', color='orange', label='median', linewidth=0.5)
    ax3.hlines(y=0, xmin=- (12 * year_num), xmax=12 * (year_num + 1), linewidth=2, color='r')
    ax3.vlines(x=0, ymin=-0.1, ymax=0.1, linestyles='dashed', linewidth=2, color='r')
    ax3.vlines(x=11, ymin=-0.1, ymax=0.1, linestyles='dashed', linewidth=2, color='r')
    ax3.fill_between(df1.index, df1["75pct"], df1["25pct"], facecolor='lightgreen')
    ax3.set_ylabel("Range of SP500", fontsize='x-small')

    ax4.plot(df2.index, df2["75pct"], color='black', label='75% percentile', linewidth=0.5)
    ax4.plot(df2.index, df2["25pct"], color='black', label='25% percentile', linewidth=0.5)
    ax4.plot(df2.index, df2["median"], '--', color='orange', label='median', linewidth=0.5)
    ax4.hlines(y=0, xmin=- (12 * year_num), xmax=12 * (year_num + 1), linewidth=2, color='r')
    ax4.vlines(x=0, ymin=-0.1, ymax=0.1, linestyles='dashed', linewidth=2, color='r')
    ax4.vlines(x=11, ymin=-0.1, ymax=0.1, linestyles='dashed', linewidth=2, color='r')
    ax4.fill_between(df2.index, df2["75pct"], df2["25pct"], facecolor='lightblue')
    ax4.set_xlim(-12 * year_num + 1, 12 * (year_num + 1))
    ax4.set_xlabel(str(year_num) + " Year Before and After Events (month)")
    ax4.set_ylabel("Range of Dow Jones", fontsize='x-small')

    plt.savefig('Plots/StockIndex/' + plot_name + '.png', dpi=200)


def output_sp_dj(df_e: pd.DataFrame, df_sp: pd.DataFrame, df_dj: pd.DataFrame, zero_point: str, year_l: int,
                 d_type: str):
    """
    manage plots of stock market indexes by changing parameters for event selection criteria.
    :param df_e: the detailed event facts in pd.DataFrame
    :param df_sp: the given historical SP500 data in pd.DataFrame
    :param df_dj: the given historical Dow Jones data in pd.DataFrame
    :param zero_point: the specific year used as the zero point in selecting the time range, the value of t0 could be one of
    ["start year", "end year", "the year before end year", "the year after start year"]
    :param year_l: the number of years to study before and after the year used as "zero point"
    :param d_type: the type of SP500 or Dow Jones historical data to study, could be "real" or "nominal"
    :return: plots for specified event selection criteria
    """
    df_e = add_time_range(df_e, zero_point, year_l)
    name_str = str(year_l) + "y_" + zero_point + "_" + d_type

    print("The evolution of {} SP500 and Dow Jones {} years before and after all the Pandemics:".format(d_type, year_l))
    selected_p = df_e.loc[df_e["Type"] == "Pandemics"]
    p1_df = get_index(selected_p, df_sp, d_type)
    p2_df = get_index(selected_p, df_dj, d_type)
    plot_sp_dj(p1_df, p2_df, year_l, name_str + "_all_pandemics")

    print("The evolution of {} SP500 and Dow Jones {} years before and after all the Wars:".format(d_type, year_l))
    selected_w = df_e.loc[df_e["Type"] == "War"]
    w1_df = get_index(selected_w, df_sp, d_type)
    w2_df = get_index(selected_w, df_dj, d_type)
    plot_sp_dj(w1_df, w2_df, year_l, name_str + "_all_wars")

    print("The evolution of {} SP500 and Dow Jones {} years before and after Pandemics with over 1m fatalities:"
          .format(d_type, year_l))
    selected_1m = df_e.loc[df_e.Fatalities.isin(["1-10m", "10-100m", ">100m"])]
    selected_1m_p = selected_1m.loc[selected_1m["Type"] == "Pandemics"]
    p1_df_1 = get_index(selected_1m_p, df_sp, d_type)
    p2_df_1 = get_index(selected_1m_p, df_dj, d_type)
    plot_sp_dj(p1_df_1, p2_df_1, year_l, name_str + "_pandemics_over_1m_fatalities")

    print("The evolution of {} SP500 and Dow Jones {} years before and after Wars with over 1m fatalities:"
          .format(d_type, year_l))
    selected_1m_w = selected_1m.loc[selected_1m["Type"] == "War"]
    w1_df_1 = get_index(selected_1m_w, df_sp, d_type)
    w2_df_1 = get_index(selected_1m_w, df_dj, d_type)
    plot_sp_dj(w1_df_1, w2_df_1, year_l, name_str + "_wars_over_1m_fatalities")


def plot_cpi(df: pd.DataFrame, plot_name: str, title: str, x_label: str, y_label: str, plot_quartiles: bool = False,
             plot_mean: bool = False) -> None:
    """
    Takes a Pandas dataframe with event and CPI data and plots it, with optional quartiles and mean value.

    :param df: A dataframe with CPI values for various events as the column titles and their values by relative year below
    :param plot_name: The file name to be used for the plot
    :param title: The title to be used for the plot
    :param x_label: The x label to be used for the plot
    :param y_label: The y label to be used for the plot
    :param plot_quartiles: Whether quartiles (25%, 50% aka mean, and 75%) should be plotted - requires these as columns
    :param plot_mean: Whether the the mean should be plotted - requires this as a column
    :return: None
    """

    # Create an empty graph and axes
    figure, axes = plt.subplots(figsize=(15, 10))

    # Either regular values can be plotted, or the quartiles and/or mean
    if plot_quartiles or plot_mean:
        if plot_quartiles:
            axes.plot(df.index, df['75pct'], color='black', label='75% percentile', linewidth=1)
            axes.plot(df.index, df['25pct'], color='black', label='25% percentile', linewidth=1)
            axes.plot(df.index, df['median'],  color='darkgreen', label='median', linewidth=1)
            axes.fill_between(df.index, df['75pct'], df['25pct'], facecolor='lightgreen')
        if plot_mean:
            axes.plot(df.index, df['mean'], '-.', color='purple', label='mean', linewidth=1)
        axes.set_xlabel(x_label)
        axes.set_ylabel(y_label)
        axes.set_title(title)
        axes.set_xticks(df.index.to_list())
        axes.legend()
    else:
        # Plotting normal values
        df.plot(ax=axes, xlabel=x_label, ylabel=y_label, title=title, xticks=df.index.to_list())

    # Save to disk
    figure.savefig(plot_name, dpi=200)


def plot_all_cpi_graphs(pandemics_cpi_df, wars_cpi_df):
    """ Takes dataframes with CPI information as well as pandemics and wars and is responsible for configuring
    all of the plots for these.

    :param pandemics_cpi_df: The dataframe with pandemic and CPI information
    :param wars_cpi_df: THe dataframe with war and CPI information
    :return:
    """
    # Plot individual events as lines
    plot_cpi(pandemics_cpi_df, 'Plots/CPI/all_pandemics.png', title='Individual Pandemics vs CPI Change',
             x_label='Years +/- End of Pandemic', y_label='Year on Year CPI % Change')
    plot_cpi(wars_cpi_df, 'Plots/CPI/all_wars.png', title='Individual Wars vs CPI Change',
             x_label='Years +/- End of War', y_label='Year on Year CPI % Change')

    # Calculate quartiles so these can be plotted
    pandemics_cpi_df = add_mean_and_quartiles(pandemics_cpi_df)
    wars_cpi_df = add_mean_and_quartiles(wars_cpi_df)

    # Plot averages for pandemics (quartiles and mean)
    plot_cpi(pandemics_cpi_df, 'Plots/CPI/pandemics_quartiles_mean.png', title='Averaged Pandemics vs CPI Change '
                                                                               'Quartiles and Mean',
             x_label='Years +/- End of Pandemic',
             y_label='Year on Year CPI % Change', plot_quartiles=True, plot_mean=True)

    # Plot averages for wars (quartiles and mean)
    plot_cpi(wars_cpi_df, 'Plots/CPI/wars_quartiles_mean.png', title='Averaged Wars vs CPI Change Quartiles and Mean',
             x_label='Years +/- End of War',
             y_label='Year on Year CPI % Change', plot_quartiles=True, plot_mean=True)


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


def analyze_cpi(us_cpi_file: str, events_file: str, year_boundaries: int,
                graph_type: Literal['start_year', 'end_year', 'year_before_end_year', 'year_after_start_year']) -> tuple:
    """ This takes an events file and file with CPI information and prepares two dataframes for plotting, one for wars
    and one for pandemics.  The dataframes returned have the percentage CPI change from year to year.

    :param us_cpi_file: The location on disk of the CPI file
    :param events_file: The location on disk of the events file
    :param year_boundaries: How many years before/after from the event to graph
    :param graph_type: One of 'start_year', 'end_year', 'year_before_end_year', or 'year_after_start_year'
    :return: Two dataframes, one for pandemics and one for wars, with the CPI change attached

    >>> cpi_file = 'data/bls_us_cpi.csv'
    >>> events_file = 'data/event_facts.csv'
    >>> pans_df, wars_df = analyze_cpi(cpi_file, events_file, 10, 'end_year')
    >>> pans_df.head()                                              # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
         Diphtheria epidemic (ended 1925)  ...  COVID-19 pandemic (ended 2021)
    -10                          0.915146  ...                        3.156841
    -9                           7.666934  ...                        2.069342
    -8                          17.840731  ...                        1.464832
    -7                          17.283953  ...                        1.622224
    -6                          15.235460  ...                        0.118625
    <BLANKLINE>
    [5 rows x 11 columns]
    >>> wars_df.tail()                                              # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
        World War I (ended 1918)  ...  War in Somalia (ended 2021)
    6                   0.439882  ...                          NaN
    7                   2.433085  ...                          NaN
    8                   0.902617  ...                          NaN
    9                  -1.930320  ...                          NaN
    10                 -1.152188  ...                          NaN
    [5 rows x 9 columns]
    """
    us_cpi_df = read_us_cpi(us_cpi_file)
    min_cpi_year = us_cpi_df['Year'].min()

    pandemics_df = read_event_facts(events_file, types='Pandemics', min_start_year=min_cpi_year,
                                    min_end_year=min_cpi_year)
    wars_df = read_event_facts(events_file, types='War', min_start_year=min_cpi_year, min_end_year=min_cpi_year)

    # Add the start and end years for plotting
    pandemics_df = add_time_range(pandemics_df, graph_type, year_boundaries, add_extra_yr_before=True)
    wars_df = add_time_range(wars_df, graph_type, year_boundaries, add_extra_yr_before=True)

    # Add the individual values for those years
    pandemics_cpi_df = add_cpi_values(pandemics_df, us_cpi_df)
    wars_cpi_df = add_cpi_values(wars_df, us_cpi_df)

    # Update the index so that it goes from negative years from zero, to zero, to years past zero
    adjust_index(pandemics_cpi_df)
    adjust_index(wars_cpi_df)

    return pandemics_cpi_df, wars_cpi_df


def analyze_index(sp500_file: str, dowjones_file: str, events_file: str):
    """
    manage the outputs of stock index analysis by passing different parameters of interest to the previous functions and
    print out results in a readable way.
    :param sp500_file: the name of the data file contains SP500 historical monthly data
    :param dowjones_file: the name of the data file contains Dow Jones historical monthly data
    :param events_file: the name of the data file contains detailed event facts
    :return: print out results in a readable format

    >>> str1 = 'data/sp500_monthly.csv'
    >>> str2 = 'data/dow_jone_monthly.csv'
    >>> str3 = 'data/event_facts.csv'
    >>> analyze_index(str1, str2, str3)
    1. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and Dow Jones historical data 10 years before and after the zero point year, plots would be
    The evolution of real SP500 and Dow Jones 10 years before and after all the Pandemics:
    ['Polio', 'Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'London flu', 'Second measles outbreak', 'SARS outbreak', 'Swine flu pandemic (H1N1)']
    ['Polio', 'Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'London flu', 'Second measles outbreak', 'SARS outbreak', 'Swine flu pandemic (H1N1)']
    The evolution of real SP500 and Dow Jones 10 years before and after all the Wars:
    ['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'Iraq War']
    ['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'Iraq War']
    The evolution of real SP500 and Dow Jones 10 years before and after Pandemics with over 1m fatalities:
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)']
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)']
    The evolution of real SP500 and Dow Jones 10 years before and after Wars with over 1m fatalities:
    ['Korean War', 'Vietnam War', 'World War II']
    ['Korean War', 'Vietnam War', 'World War II']
    3. If we use the event start year as zero point, and select the real SP500 and Dow Jones historical data 5 years before and after the zero point year, plots would be
    The evolution of real SP500 and Dow Jones 5 years before and after all the Pandemics:
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'London flu', 'Second measles outbreak', 'HIV AIDS pandemic', 'SARS outbreak', 'Swine flu pandemic (H1N1)']
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'London flu', 'Second measles outbreak', 'HIV AIDS pandemic', 'SARS outbreak', 'Swine flu pandemic (H1N1)']
    The evolution of real SP500 and Dow Jones 5 years before and after all the Wars:
    ['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'War on Terror', 'Iraq War', 'War in Somalia']
    ['Korean War', 'Vietnam War', 'World War II', 'Gulf War', 'Civil war in Afghanistan', 'War on Terror', 'Iraq War', 'War in Somalia']
    The evolution of real SP500 and Dow Jones 5 years before and after Pandemics with over 1m fatalities:
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'HIV AIDS pandemic']
    ['Asian Flu (H2N2)', 'Hong Kong Flu (H3N2)', 'HIV AIDS pandemic']
    The evolution of real SP500 and Dow Jones 5 years before and after Wars with over 1m fatalities:
    ['Korean War', 'Vietnam War', 'World War II', 'War in Somalia']
    ['Korean War', 'Vietnam War', 'World War II', 'War in Somalia']
    """
    event_df = read_event_facts(events_file)
    sp_df = pd.read_csv(sp500_file)
    dj_df = pd.read_csv(dowjones_file)

    # Create a dataframe with information on both Dow Jones and SP500 by year
    sp_df["date"] = pd.to_datetime(sp_df["date"], format='%Y-%m-%d')
    sp_df["year"] = sp_df["date"].dt.year

    dj_df["date"] = pd.to_datetime(dj_df["date"], format='%Y-%m-%d')
    dj_df["year"] = dj_df["date"].dt.year

    print("1. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and "
          "Dow Jones historical data 10 years before and after the zero point year, plots would be")
    output_sp_dj(event_df, sp_df, dj_df, "year_before_end_year", 10, "real")
    # print("2. If we use the year before the event end year as zero point, and select the nominal SP500 and "
    #       "Dow Jones historical data 10 years before and after the zero point year, plots would be")
    # output_sp_dj(event_df, sp_df, dj_df, "year_before_end_year", 10, "nominal")
    print("3. If we use the event start year as zero point, and select the real SP500 and "
          "Dow Jones historical data 5 years before and after the zero point year, plots would be")
    output_sp_dj(event_df, sp_df, dj_df, "start_year", 5, "real")
    # print("4. If we use the year before the event end year as zero point, and select the inflation adjusted SP500 and "
    #       "Dow Jones historical data 5 years before and after the zero point year, plots would be")
    # output_sp_dj(event_df, sp_df, dj_df, "year_before_end_year", 5, "real")
