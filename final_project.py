"""
IS597 Spring 2021 Final Project
Group members: Kangyang Wang, Wendy Zhu, and Kay Avila
"""
import numpy as np
import pandas as pd
from typing import Union


def read_worlddb_gdp(filename: str, years: Union[list, None] = None, countries: Union[list, None] = None) -> \
        pd.DataFrame:
    """

    :param countries: A list of countries to include, using their country codes
    :param years: A list of years to include
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
    [5 rows x 52 columns]
    >>> df.tail()  # doctest: +ELLIPSIS +NORMALIZE_WHITESPACE
                                       Country Name  ...              2020
    261                          Sub-Saharan Africa  ...  1687597704644.75
    262  Sub-Saharan Africa (excluding high income)  ...  1686475026320.97
    263   Sub-Saharan Africa (IDA & IBRD countries)  ...  1687597704644.75
    264                         Upper middle income  ...  23104877770162.5
    265                                       World  ...  84577962952008.3
    [5 rows x 52 columns]
    """

    # Rather than specifying all the years, be more usable for the future by dropping unneeded columns
    df = pd.read_csv(filename, header=0,
                     dtype={'Country Name': 'string', 'Country Code': 'string'})
    df.drop(columns=['Series Name', 'Series Code'], inplace=True)

    # Trim off the excess year header data (e.g. [YR1971]), and set correct type for the years
    col_names = list(df.columns)
    year_type_dict = {}
    for i, name in enumerate(col_names):
        if name.endswith(']'):
            col_names[i] = col_names[i].split(' ')[0]
            year_type_dict[col_names[i]]: 'int16'
    df.columns = col_names
    df = df.astype(year_type_dict)

    df = df[df['Country Code'].notna()]   # Drop rows without country codes
    df = df.replace('..', np.nan)         # Convert the '..'s to NaNs

    # TODO: Filter down to the provided countries if relevant
    if countries:
        countries = ['USA', 'GBR']

    # TODO: Filter by years
    if years:
        pass

    return df


def main():
    read_worlddb_gdp('data/WorldDataBank-GDP.csv')


if __name__ == '__main__':
    main()