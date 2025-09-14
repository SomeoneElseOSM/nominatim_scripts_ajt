# -----------------------------------------------------------------------------
# call_nominatim_01.sh
# Derived from garmin_map_etrex_03.sh, in turn from update_render.sh
#
# This uses osm-tags-transform to 
# transform data before feeding it to nominatim.
# -----------------------------------------------------------------------------
local_filesystem_user=ajtown
local_nominatim_user=nominatim
cd /home/${local_filesystem_user}/data/
if test -e update_nominatim.running
then
    echo update_nominatim.running exists so exiting
    exit 1
else
    touch update_nominatim.running
fi
#
# ----------------------------------------------------------------------------
# What's the file that we are interested in?
#
# The data file is downloaded in ~/data which allows it to be shared with data
# files user by update_render.sh, update_vector.sh or garmin_map_etrex_03.sh;
# if any of those is also installed.
#
# While still testing, just use a small area:
#
# Four parameters can be set, such as:
# europe united-kingdom england north-yorkshire
# ----------------------------------------------------------------------------
if [ -z "$4" ]
then
    if [ -z "$3" ]
    then
	if [ -z "$2" ]
	then
	    if [ -z "$1" ]
	    then
		echo "1-4 arguments needed (continent, country, state, region).  No arguments passed - exiting"
		rm update_nominatim.running
		exit 1
	    else
		# ----------------------------------------------------------------------
		# Sensible options here might be "antarctica" or possibly "central-america".
		# ----------------------------------------------------------------------
		echo "1 argument passed - processing a continent"
		file_prefix1=${1}
		file_page1=http://download.geofabrik.de/${file_prefix1}.html
		file_url1=http://download.geofabrik.de/${file_prefix1}-latest.osm.pbf
	    fi
	else
	    # ----------------------------------------------------------------------
	    # Sensible options here might be e.g. "europe" and "albania".
	    # ----------------------------------------------------------------------
	    echo "2 arguments passed - processing a continent and a country"
	    file_prefix1=${2}
	    file_page1=http://download.geofabrik.de/${1}/${file_prefix1}.html
	    file_url1=http://download.geofabrik.de/${1}/${file_prefix1}-latest.osm.pbf
	fi
    else
	# ----------------------------------------------------------------------
	# Sensible options here might be e.g. "europe" "united-kingdom" and "england".
	# ----------------------------------------------------------------------
	echo "3 arguments passed - processing a continent, a country and a subregion"
	file_prefix1=${3}
	file_page1=http://download.geofabrik.de/${1}/${2}/${file_prefix1}.html
	file_url1=http://download.geofabrik.de/${1}/${2}/${file_prefix1}-latest.osm.pbf
    fi
else
    # ----------------------------------------------------------------------
    # Sensible options here might be e.g. "europe" "united-kingdom", "england" and "bedfordshire"
    # ----------------------------------------------------------------------
    echo "3 arguments passed - processing a continent, a country and a subregion"
    file_prefix1=${4}
    file_page1=http://download.geofabrik.de/${1}/${2}/${3}/${file_prefix1}.html
    file_url1=http://download.geofabrik.de/${1}/${2}/${3}/${file_prefix1}-latest.osm.pbf
fi

#
# Now we know what we are downloading, define some shared functions
#
final_tidy_up()
{
    cd /home/${local_filesystem_user}/data/nominatim
    rm transformed_after.pbf
    cd /home/${local_filesystem_user}/data/
    rm last_modified1.$$
    rm update_nominatim.running
}

m_error_01()
{
    final_tidy_up
# -----------------------------------------------------------------------------
# Uncomment to send an email on build failure
# -----------------------------------------------------------------------------
    # date | mail -s "call_nominatim_01_03 FAILED on `hostname`" ${local_filesystem_user}
    exit 1
}

# -----------------------------------------------------------------------------
# When was the target file last modified?
# -----------------------------------------------------------------------------
echo "Checking last modified date for ${file_prefix1}"
wget $file_page1 -O file_page1.$$ --output-file /dev/null
grep " and contains all OSM data up to " file_page1.$$ | sed "s/.*and contains all OSM data up to //" | sed "s/. File size.*//" > last_modified1.$$
rm file_page1.$$
#
file_extension1=`cat last_modified1.$$`
#
if test -e ${file_prefix1}_${file_extension1}.osm.pbf
then
    echo "${file_prefix1} already downloaded"
else
    echo "Downloading ${file_prefix1}"
    wget $file_url1 -O ${file_prefix1}_${file_extension1}.osm.pbf --output-file /dev/null
fi
#
mkdir -p nominatim
cd nominatim
#
# ------------------------------------------------------------------------------
# Run osm-tags-transform
# ------------------------------------------------------------------------------
if /home/${local_filesystem_user}/src/osm-tags-transform/build/src/osm-tags-transform -c /home/${local_filesystem_user}/src/nominatim_scripts_ajt/ntransform_01.lua ../${file_prefix1}_${file_extension1}.osm.pbf -O -o transformed_after.pbf
then
    echo Transform OK
else
    echo Transform Error
    m_error_01
fi

# ------------------------------------------------------------------------------
# Call nominatim itself
# ------------------------------------------------------------------------------
echo "Running nominatim - this will take from 5 mins to several hours"
#
systemctl stop nominatim.service
sudo -u ${local_nominatim_user} sh -c "/home/${local_filesystem_user}/src/nominatim_scripts_ajt/call_nominatim_02.sh"
systemctl start nominatim.service
systemctl restart nominatim.service
#
# -----------------------------------------------------------------------------
# And final tidying up.
# -----------------------------------------------------------------------------
final_tidy_up
#
