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
-- Apply "name" transformations to ways for "map style 03"
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- "all" function
-- ----------------------------------------------------------------------------
function process_all( objtype, object )

    if ((( object.tags["admin_level"] == "5" )  or
         ( object.tags["admin_level"] == "6" )) and
        (( object.tags["place"]       == nil )  or
         ( object.tags["place"]       == ""  ))) then
        object.tags["admin_level"] = nil
        object.tags["boundary"] = nil
    end

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


