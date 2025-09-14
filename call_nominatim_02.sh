dropdb nominatim
cd ~/nominatim-project
export USERNAME=nominatim
export USERHOME=/srv/nominatim
. $USERHOME/nominatim-venv/bin/activate;time nominatim import --osm-file /home/ajtown/data/nominatim/transformed_after.pbf --no-updates  2>&1 | tee setup_$$.log
