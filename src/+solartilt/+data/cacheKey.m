function key=cacheKey(source,location)
payload=sprintf('%s|%s|%.6f|%.6f|%d|%d|%s',source.type,source.product,location.latitude,location.longitude,source.startYear,source.endYear,source.radiationDatabase);md=java.security.MessageDigest.getInstance('SHA-256');key=lower(reshape(dec2hex(typecast(md.digest(uint8(payload)),'uint8'))',1,[]));
end

