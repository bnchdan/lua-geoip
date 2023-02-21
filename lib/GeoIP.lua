--[[
    requiments: 
        - geoip-database 
        - libgeoip-dev
        - lua-geoip
]]--


-- GeoIP class
GeoIP = {
    filenameIPv4    = "/usr/share/GeoIP/GeoIP.dat", 
    filenameIPv6    = "/usr/share/GeoIP/GeoIPv6.dat", 
    geoip           = require 'geoip',
    geoip_country   = require 'geoip.country'
}



--get IP type
function GeoIP.GetIPType(ip)
    local R = {ERROR = 0, IPV4 = 1, IPV6 = 2, STRING = 3}
    if type(ip) ~= "string" then return R.ERROR end
  
    local chunks = {ip:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")}
    if #chunks == 4 then
      for _,v in pairs(chunks) do
        if tonumber(v) > 255 then return R.STRING end
      end
      return R.IPV4
    end
  
    local chunks = {ip:match("^"..(("([a-fA-F0-9]*):"):rep(8):gsub(":$","$")))}
    if #chunks == 8
    or #chunks < 8 and ip:match('::') and not ip:gsub("::","",1):match('::') then
      for _,v in pairs(chunks) do
        if #v > 0 and tonumber(v, 16) > 65535 then return R.STRING end
      end
      return R.IPV6
    end
  
    return R.STRING
end


function GeoIP.getCountryCode (ip)

    --ipv4
    if GeoIP.GetIPType(ip) == 1 then
        return GeoIP.getGeoIPv4(ip)
    end

    -- ipv6
    if GeoIP.GetIPType(ip) == 2 then
        return GeoIP.getGeoIPv6(ip)
    end

    return 0
end


function GeoIP.getGeoIPv4(ip)
    geodb_country = GeoIP.geoip_country.open(GeoIP.filenameIPv4)
    res = geodb_country:query_by_addr(ip)  
    geodb_country:close()

    if res.code == "--" then
        return 0
    end 

    return res.code
end



function GeoIP.getGeoIPv6(ip)
    geodb_country6 = GeoIP.geoip_country.open(GeoIP.filenameIPv6)
    res = geodb_country6:query_by_addr6(ip)
    geodb_country6:close()

    if res.code == "--" then
        return 0
    end 

    return res.code 
end
