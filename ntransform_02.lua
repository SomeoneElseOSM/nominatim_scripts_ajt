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

    if (( object.tags["admin_level"] ~= nil  )  and
        ( object.tags["admin_level"] ~= ""   )) then
        object.tags["admin_level"] = nil
    end

    if ( object.tags["place"] == "country" ) then
        object.tags["admin_level"] = "2"
    end

    if ( object.tags["place"] == "state" ) then
        object.tags["admin_level"] = "4"
    end

    if ( object.tags["place"] == "county" ) then
        object.tags["admin_level"] = "6"
    end

    if ( object.tags["place"] == "city" ) then
        object.tags["admin_level"] = "8"
    end

    if ( object.tags["place"] == "town" ) then
        object.tags["admin_level"] = "9"
    end

    if (( object.tags["place"] == "village" ) or
        ( object.tags["place"] == "suburb"  )) then
        object.tags["admin_level"] = "10"
    end

    if (( object.tags["place"] == "hamlet"        ) or
        ( object.tags["place"] == "neighbourhood" )) then
        object.tags["admin_level"] = "11"
    end

    if ( object.tags["place"] == "locality" ) then
        object.tags["admin_level"] = "12"
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


