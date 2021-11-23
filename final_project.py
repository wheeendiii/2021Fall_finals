"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila
"""
import numpy as np
import pandas as pd
from datetime import date
from typing import Union


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
    ValueError: Invalid minimum year: Minimum year cannot be less than 1971.  No data available.
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
            raise ValueError('Invalid minimum year: Minimum year cannot be less than 1971.  No data available.')
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

    df = df[df['Country Code'].notna()]   # Drop rows without country codes
    df = df.replace('..', np.nan)         # Convert the '..'s to NaNs

    if countries:
        countries = [c.upper() for c in countries]               # Make sure all country codes are uppercase
        relevant_countries = df['Country Code'].isin(countries)  # Filter down to the ones we want
        df = df[relevant_countries]

    if max_year:
        max_year_pos = df.columns.get_loc(int(max_year))
        df = df.iloc[:, 0:(max_year_pos + 1)]

    # Minimum year is trickier because we need to keep country info in the first two cols
    if min_year:
        min_year_pos = df.columns.get_loc(int(min_year))
        df_right = df.iloc[:, min_year_pos:]    # Grab the year columns
        df_left = df.iloc[:, 0:2]               # These are the country name and country code

        # Append the year columns on the right to the country name/codes on the left
        df_left[df_right.columns] = df_right.values
        df = df_left

    return df


def main():
    read_worlddb_gdp('data/WorldDataBank-GDP.csv')


if __name__ == '__main__':
    main()