

osmium extract -H -b 74.81,53.08,85.47,57.37 -o crop.osh.pbf siberian-fed-district-internal.osh.pbf 



sudo apt-get install postgresql-9.1 postgresql-contrib-9.1 postgresql-9.1-postgis postgis zlib1g-dev libexpat1 libexpat1-dev  \
    libxml2 libxml2-dev libgeos-dev libgeos++-dev libprotobuf7 libprotobuf-dev protobuf-compiler libsparsehash-dev libboost-dev \
    libgdal1-dev libproj-dev subversion git build-essential unzip python-dateutil python-psycopg2 \
    graphicsmagick doxygen graphviz python-mapnik2 clang

    postgresql postgis postgresql-contrib clang  libosmium-dev  libosmpbf-dev libgeos++-dev libpq-dev 
    libprotobuf-dev libsparsehash-dev libproj-dev


sudo -u postgres createuser $USER
!!! use gis db below
sudo -u postgres createdb -EUTF8 -O$USER $USER
echo 'CREATE EXTENSION hstore' | sudo -u postgres psql $USER
echo 'CREATE EXTENSION btree_gist' | sudo -u postgres psql $USER
sudo -u postgres psql $USER </usr/share/postgresql/9.5/contrib/postgis-2.2/postgis.sql
sudo -u postgres psql $USER </usr/share/postgresql/9.5/contrib/postgis-2.2/spatial_ref_sys.sql
echo "GRANT ALL ON geometry_columns TO $USER" | sudo -u postgres psql $USER
echo "GRANT ALL ON spatial_ref_sys TO $USER" | sudo -u postgres psql $USER


pip install --user  psycopg2 

sudo apt-get install python-mapnik python-dateutil

git clone https://github.com/openstreetmap/mapnik-stylesheets --depth=1
cd mapnik-stylesheets/
./get-coastlines.sh
./generate_xml.py --accept-none --prefix 'hist_view'

docker run --name "postgis" -p 25432:5432 -d -t \
  -e POSTGRES_USER=gis \
  -e POSTGRES_PASS=pass \
  -e POSTGRES_DBNAME=gis \
  kartoza/postgis:9.6-2.4

docker run -it --rm --network container:postgis \
  -v `pwd`:/data osm-history-importer \
  crop.osh.pbf \
  --dsn "host=127.0.0.1 user=gis password=pass dbname=gis"


