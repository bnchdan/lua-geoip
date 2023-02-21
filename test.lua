require 'lib.GeoIP'

print ( GeoIP.getCountryCode("8.8.8.8") )                   -- US
print ( GeoIP.getCountryCode("2a00:1450:4001:812::2003") )  -- DE
print ( GeoIP.getCountryCode("2a00:2450:4001:812::2003") )  -- 0
print ( GeoIP.getCountryCode("test") )                      -- 0
