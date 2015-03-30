# Open Source Mapfiles

This repository contains map files released by Nautoguide Ltd. under the GPL. We intend to provide a full vector stack for Ordnance Survey Opendata. The first release is a *beta version* of a render for full colour OS Openmap using mapserver

##Openmap vector mapfile

This mapfile will render OS Openmap vector using the OS Full Colour style. In order to use the mapfile you must run the SQL in *sql/create_idx_function.sql* This will create a function in your Postgres database that provides an array index for an element in an array. This is required in order to render roads in the correct order such. 

The mapfile uses the land polygons from the vector_district open data in order to mask out the base mapcolour of blue which is done to ensure that the sea renders properly. It retrieves all data from a postgis database but you can change this to render from shapefiles directly by replacing the lines :-

   CONNECTION "host=localhost dbname=[YOUR DATABASE] user=[YOUR DATABASE USER] password=[YOUR_PASSWORD] port=5432"
   CONNECTIONTYPE POSTGIS
   DATA "wkb_geometry from (SELECT wkb_geometry,ogc_fid FROM mapping_os_opendata_vector_district.land)  AS FOO USING UNIQUE ogc_fid using srid=27700"

with

   CONNECTIONTYPE OGR
   CONNECTION "PATH TO YOUR SHAPEFILE"
   DATA "modified query to replicate SQL as stated in mapfile but using shapefile attributes"

The ordering query used for the roads table will not work as it uses a custom postgres function. You may have to use separate OGR layers to replicate this.

This mapfile is provided without any warranty at all. It is a beta release and is still being tested. We welcome any feedback and improvements, if you are having problems raise an issue on this repository and we will do our best to help where we can.

The following issues are known:-

* missing symbols for a number of the railway station types, we currently only implement two
* some fonts and colours may differ from the OS style sheets
* the roundabout query is repeated in order to ensure the rendering order is correct. At the moment we do not know a way around this but would welcome ideas
* edge clipping will occur for buffered geometries. The solution for this is to render via  a cache such as mapserver
* background style render not completed, on our to-do list (after learning Portugese)

We loaded our data into POSTGIS two stages:-

* combine all OS shapefiles into a single shapefile

     cd <directory where your shapefiles reside>
     perl combine_shape_files.pl .

* load data using ogr2ogr

    ogr2ogr -f PostgreSQL  -skipfailures -fieldTypeToString ALL -nlt geometry -progress PG:"dbname=[YOUR DATABASE] user=[YOUR UJSER] password=[YOUR PASSWORD] host=l[YOUR HOST]" --config PG_USE_COPY YES -overwrite -nln [SCHEMA.TABLENAME] [SHAPEFILENAME].shp

Ths can be done in a single stage but we like to check the combined file first in QGIS

Hope you find this useful, let us know your thoughts, feedback or ideas

Nautoguide Ltd.
