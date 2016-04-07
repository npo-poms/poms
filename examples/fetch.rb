require 'poms'

# Initialize poms with the correct credentials
Poms.init(key: '**API KEY**', secret: '**API SECRET**', origin: '**ORIGIN**')

# Fetch an entity from POMS by mid
Poms.fetch("POMS_S_NTR_2342303")
# => A hash representing the data corresponding to the given MID

# Fetch multiple entities
Poms.fetch(["WO_TELEAC_003061", "POMS_EO_622912"])
# => An array of hashes representing data corresponding to those MID's
