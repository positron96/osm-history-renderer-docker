FROM ubuntu:xenial AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y \
  && apt-get install -qq -y \
      wget libboost-dev libexpat1-dev  unzip build-essential \
      clang  libosmium-dev  libosmpbf-dev libgeos++-dev \
      libpq-dev libprotobuf-dev libsparsehash-dev libproj-dev \
  && rm -rf /var/lib/apt/lists/*

  
WORKDIR /build
  
RUN wget -qO temp.zip https://github.com/MaZderMind/osm-history-renderer/archive/master.zip \
  && unzip temp.zip \
  && rm temp.zip

RUN cd osm-history-renderer-master/importer && make

## new carto mapnik style builder
 
#node:lts-alpine
#node:lts-slim

#FROM ubuntu:xenial AS build-style
#RUN apt-get update -qq -y && apt-get install -qq -y \
    
    #python-psycopg2 python-mapnik python-dateutil libprotobuf-lite9v5 \
    #osmium-tool \
  #&& rm -rf /var/lib/apt/lists/*

#wget -qO temp.zip https://github.com/gravitystorm/openstreetmap-carto/archive/master.zip
#unzip temp.zip
#rm temp.zip


#### old mapnik style builder

FROM ubuntu:xenial AS build-style-old

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y && apt-get install -qq -y \    
    wget unzip bzip2 python-mapnik \
  && rm -rf /var/lib/apt/lists/*

wget -qO temp.zip https://github.com/openstreetmap/mapnik-stylesheets/archive/master.zip \
  && unzip temp.zip \
  && rm temp.zip \
  && mv mapnik-stylesheets-master mapnik-stylesheets
  

cd mapnik-stylesheets
./get-coastlines.sh
./generate_xml.py --accept-none --prefix 'hist_view'


FROM ubuntu:xenial 

RUN apt-get update -qq -y && apt-get install -qq -y \
    python-psycopg2 python-mapnik python-dateutil libprotobuf-lite9v5 \
    osmium-tool \
  && rm -rf /var/lib/apt/lists/*
  
#apt-get install fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-hanazono ttf-unifont
  
COPY --from=build /build/osm-history-renderer-master/importer/osm-history-importer /usr/bin
COPY --from=build /build/osm-history-renderer-master/renderer/* /usr/bin/

COPY --from=build-style-old /mapnik-stylesheets /style

WORKDIR /data


