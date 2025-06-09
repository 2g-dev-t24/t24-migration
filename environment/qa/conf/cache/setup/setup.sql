-- For default encrypter initializer
DROP TABLE TAFJ_CACHE_KS_INIT;
CREATE TABLE TAFJ_CACHE_KS_INIT ( RECID VARCHAR2(255));
INSERT INTO TAFJ_CACHE_KS_INIT VALUES ('Waz7G611E%+6291Tqz');
-- For mapping T24 tables to a cache in ignite-cache.xml, 
-- 'Tables' should be used for CACHENAME for read-only data
-- 'TablesXMLClobWriteThrough' should be used for CACHENAME for read/write data
DROP TABLE TAFJ_CACHE;
CREATE TABLE TAFJ_CACHE( RECID VARCHAR(255) PRIMARY KEY, CACHENAME VARCHAR(255), WRITEBATCHROWS VARCHAR2(5));
--FDataEventCache maps to a Data Event Streaming Cache used by that product
INSERT into TAFJ_CACHE (RECID, CACHENAME) VALUES ('F.DATA.EVENTS', 'FDataEventCache');
--TEST.CACHE.FREE.DELETE is part of the samples 
INSERT into TAFJ_CACHE (RECID, CACHENAME) VALUES ('TEST.CACHE.FREE.DELETE','Tables');
-- The default write-through cache used by TAFJ, uncomment to implement or add cache mappings here.
--INSERT into TAFJ_CACHE (RECID, CACHENAME) VALUES ('FBNK.CURRENCY', 'TablesXMLClobWriteThrough');

-- This table will be auto-created by default
DROP TABLE TAFJ_CACHE_CONFIG;
COMMIT;
