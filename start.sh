#first step
#run the container
docker-compose up -d
#enter into the container
docker-compose exec postgres psql -U myuser -d mydatabase
#do query operations
CREATE TABLE users (
    id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    email VARCHAR (255) UNIQUE NOT NULL
);

INSERT INTO users (username, email) VALUES ('john_doe', 'john.doe@example.com');
#stop the container
docker-compose down
#inspect the volumes for data
docker volume inspect postgres_data //but this says no such volume
#again run it
docker-compose up -d
#check for volumes that exists
docker volume ls   //this gives the exact name of volumes in the container
#now inspect it
docker volume inspect postgres_postgres_data     //this volumes name is not given by me so that i am not able to access it
#save the Mountpoint   /workspace/.docker-root/volumes/postgres_postgres_data/_data
cd /workspace/.docker-root/volumes/postgres_postgres_data/_data
#but not accessable so used sudo
sudo chown -R $(whoami) /workspace/.docker-root/volumes/postgres_postgres_data/_data
cd /workspace/.docker-root/volumes/postgres_postgres_data/_data #now this works
#now we can access the db by 
sudo -i
cd /workspace/.docker-root/volumes/postgres_postgres_data/_data
#if we want the table data we need to up the container and get it
docker-compose up -d
docker ps
docker-compose exec postgres psql -U myuser -d mydatabase
select * from users;  /this gave me the earlier data and this shows the persistance of data
#uploding csv files from host machine
CREATE TABLE sample_csv (
    Store int,
    Type char,
    Size float,
);

docker exec -it container_id /bin/bash
#first copy from the local machine to container
#for that first create a directory in container to store the data
docker exec -it 682 mkdir /data
docker cp "/workspace/postgres/stores data-set.csv" postgres:/data/stores_data-set.csv
#now go to container and enter the data to tables
docker-compose exec postgres psql -U myuser -d mydatabase
\COPY sample_csv FROM '/data/stores_data-set.csv' WITH CSV HEADER;
#to view the data
select * from sample_csv;
CREATE TABLE sales_data (
    Store INT,
    Dept INT,
    Date DATE,
    Weekly_Sales DECIMAL(10, 2),
    IsHoliday BOOLEAN
);
docker cp "/workspace/postgres/sales data-set.csv" container_id:/data/sales_data-set.csv
docker-compose exec postgres psql -U myuser -d mydatabase
\COPY sales_data FROM '/data/sales_data-set.csv' WITH CSV HEADER;
docker cp "/workspace/postgres/Features data set.csv" 682:/data/features_data-set.csv
docker-compose exec postgres psql -U myuser -d mydatabase
CREATE TABLE features_data AS
SELECT *
FROM "/data/features_data-set.csv"
WITH CSV HEADER;
COPY features_data FROM '/data/features_data-set.csv' WITH CSV HEADER;
