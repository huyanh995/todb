# 1d. Load general information to cse532.facilityoriginal
db2 load from "Health_Facility_General_Information.csv" of del MESSAGES load.msg INSERT INTO cse532.facilityoriginal
# 1e. Parse (latitude, longitude) to ST_POINT and store to cse532.facility
db2 -tf facilityinsert.sql
# 1d. Create cse532.facilitycertification table
db2 -tf createfacilititycertificationtable.sql
# Load certification information to cse532.facilitycertification
db2 load from "Health_Facility_Certification_Information.csv" of del MESSAGES load.msg INSERT INTO cse532.facilitycertification
# 1g. Run update indexes
db2 -tf createindexes.sql