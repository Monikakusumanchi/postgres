import pandas as pd
from sqlalchemy import create_engine

# Replace with your PostgreSQL connection string
db_url = 'postgresql://myuser:mypassword@postgres:5432/mydatabase'

# Replace with the actual path to your CSV file inside the container
csv_path = '/data/features_data-set.csv'

# Read CSV file into a Pandas DataFrame
df = pd.read_csv(csv_path)

# Connect to the PostgreSQL database
engine = create_engine(db_url)

# Dynamically create a table based on the DataFrame
table_name = 'features_data1'
df.to_sql(table_name, con=engine, index=False, if_exists='replace')

# Print the schema of the dynamically created table
with engine.connect() as connection:
    result = connection.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '{table_name}'")
    for row in result:
        print(row)
