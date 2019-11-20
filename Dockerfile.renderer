FROM ubuntu:xenial 

RUN apt-get update -q -y && apt-get install -q -y \
    wget unzip bzip2 \
    python-psycopg2 python-mapnik python-dateutil libprotobuf-lite9v5 \
    \
  && rm -rf /var/lib/apt/lists/*
  
#apt-get install fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-hanazono ttf-unifont
  
#COPY --from=build /build/osm-history-renderer-master/renderer/* /usr/bin/

RUN wget -qO temp.zip https://github.com/MaZderMind/osm-history-renderer/archive/master.zip \
  && unzip temp.zip \
  && rm temp.zip \
  && cp osm-history-renderer-master/renderer/* /usr/bin/ \
  && rm -rf osm-history-renderer-master

WORKDIR /data

RUN wget -qO temp.zip https://github.com/openstreetmap/mapnik-stylesheets/archive/master.zip \
  && unzip temp.zip -d /usr/share \
  && rm temp.zip \
  && cd /usr/share \
  && mv mapnik-stylesheets-master osm-mapnik
  
#/usr/share/osm-mapnik/osm.xml
  
RUN cd /usr/share/osm-mapnik \
  && ./get-coastlines.sh \
  && ./generate_xml.py --accept-none --prefix 'hist_view'
  

ENTRYPOINT ["render.py"]





