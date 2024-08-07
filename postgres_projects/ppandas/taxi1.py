# create a virtualenv
python3 -m venv env

# activate the virtualenv
source env/bin/activate

# launch python
python

# install pandas pyarrow 
pip3 install pandas pyarrow fastparquet

# load the parquet file into a pandas DataFrame

import pandas as pd
df = pd.read_parquet('df = pd.read_parquet('/Users/data-engineering/postgres_projects/datasets/NY2022_10.parquet',\
engine='pyarrow')', engine='pyarrow')

# save the DataFrame as csv file
df.to_csv('/Users/data-engineering/postgres_projects/datasets/NY2022_10.csv')

# load the cvs file into a pandas DataFrame
df = pd.read_csv('/Users/data-engineering/postgres_projects/datasets/NY2022_10.csv', index_col=0)

# Let's have a look at the 5 rows of the DataFrame

df.head()

