-- ----------------------------------------------------------------------------
-- ntransform_02.lua
--
-- Copyright (C) 2018-2025  Andy Townsend
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Apply transformations to ways for "nominatim place style 03"
--
-- In each case here all objects are passed through "process_all".
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- "all" function
-- ----------------------------------------------------------------------------
function process_all( objtype, object )

-- ----------------------------------------------------------------------------
-- Here we remove admin_levels 5,6 and 7 for which there is no "place".
--
-- This removes:
-- 5: Various combined authorities in England
-- https://overpass-turbo.eu/s/2c9Q
-- 6: Various unitary councils
-- https://overpass-turbo.eu/s/2c9R
-- 7: NI super-councils and intra-Dublin admin areas
-- https://overpass-turbo.eu/s/2c9S
--
-- We special-case the City of London, which has no "place" tag and would 
-- otherwise be removed here.
-- ----------------------------------------------------------------------------
    if ((( object.tags["admin_level"] == "5"              )  or
         ( object.tags["admin_level"] == "6"              )  or
         ( object.tags["admin_level"] == "7"              )) and
        (( object.tags["place"]       == nil              )  or
         ( object.tags["place"]       == ""               )) and
        (  object.tags["name"]        ~= "City of London"  )) then
        object.tags["admin_level"] = nil
        object.tags["boundary"] = nil
    end

-- ----------------------------------------------------------------------------
-- Instead, add traditional English counties at 6, and special-case 
-- Yorkshire Ridings and Parts of Lincolnshire at admin level 8.
-- ----------------------------------------------------------------------------
    if ( object.tags["boundary"] == "traditional" ) then
        if (( object.tags["name"] == "East Riding of Yorkshire"  ) or
            ( object.tags["name"] == "North Riding of Yorkshire" ) or
            ( object.tags["name"] == "West Riding of Yorkshire"  ) or
            ( object.tags["name"] == "Parts of Holland"          ) or
            ( object.tags["name"] == "Parts of Kesteven"         ) or
            ( object.tags["name"] == "Parts of Lindsey"          )) then
            object.tags["admin_level"] = "8"
        else
            object.tags["admin_level"] = "6"
        end

        object.tags["boundary"] = "administrative"
    end

-- ----------------------------------------------------------------------------
-- Also include the "Six Counties" in Northern Ireland
-- ----------------------------------------------------------------------------
    if (( object.tags["boundary"]    == "historic" ) and
        ( object.tags["admin_level"] == "6"        ) and
        ( object.tags["place"]       ~= nil        ) and
        ( object.tags["place"]       ~= ""         )) then
        object.tags["boundary"] = "administrative"
    end

    return object
end


-- ----------------------------------------------------------------------------
-- "node" function
-- ----------------------------------------------------------------------------
function ott.process_node( object )
   object = process_all( "n", object )

   return object.tags
end


-- ----------------------------------------------------------------------------
-- "way" function
-- ----------------------------------------------------------------------------
function ott.process_way( object )
    object = process_all( "w", object )

    return object.tags
end


-- ----------------------------------------------------------------------------
-- "relation" function
-- ----------------------------------------------------------------------------
function ott.process_relation( object )
   object = process_all( "r", object )

   return object.tags
end


