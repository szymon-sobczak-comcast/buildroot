#!/usr/bin/env python

import json, sys
from os import walk


licenseMap = {
    "WPEFramework": {
        "license": "Apache License Version 2.0"
    },
    "WPENetworkProcess": {
        "license": "BSD & LGPLv2+"
    },
    "WPEProcess": {
        "license": "Apache License Version 2.0"
    },
    "WPEStorageProcess": {
        "license": "BSD & LGPLv2+"
    },
    "WPEWebProcess": {
        "license": "BSD & LGPLv2+"
    },
    "gst-inspect-1.0": {
        "license": "LGPLv2+"
    },
    "gst-launch-1.0": {
        "license": "LGPLv2+"
    },
    "gst-plugin-scanner": {
        "license": "LGPLv2+"
    },
    "gst-typefind-1.0": {
        "license": "LGPLv2+"
    },
    "libWPEBackend-rdk": {
        "license": "BSD-2-Clause"
    },
    "libWPEBackend": {
        "license": "BSD-2-Clause"
    },
    "libWPEFramework": {
        "license": "Apache License Version 2.0"
    },
    "libWPEInjectedBundle": {
        "license": "Apache License Version 2.0"
    },
    "libWPEWebInspectorResources": {
        "license": "BSD & LGPLv2+"
    },
    "libWPEWebKit": {
        "license": "BSD & LGPLv2+"
    },
    "libatomic": {
        "license": "LGPLv2.1"
    },
    "libblkid": {
        "license": "LGPLv2.1+"
    },
    "libbrcm": {
        "license": "Broadcom Proprietary"
    },
    "libcairo": {
        "license": "LGPLv2.1+"
    },
    "libcurl": {
        "license": "MIT/X derivate"
    },
    "libepoxy": {
        "license": "MIT"
    },
    "libexpat": {
        "license": "MIT"
    },
    "libffi": {
        "license": "MIT"
    },
    "libfontconfig": {
        "license": "MIT"
    },
    "libfreetype": {
        "license": "FTL"
    },
    "libgcc_s": {
        "license": "LGPLv2.1"
    },
    "libgcrypt": {
        "license": "LGPLv2.1+"
    },
    "libgio-2.0": {
        "license": "LGPLv2.1+"
    },
    "libgiognutls": {
        "license": "LGPLv2.1+"
    },
    "libglib-2.0": {
        "license": "LGPLv2.1+"
    },
    "libgmodule-2.0": {
        "license": "LGPLv2.1+"
    },
    "libgmp": {
        "license": "LGPLv2.1"
    },
    "libgnutls": {
        "license": "LGPLv2.1"
    },
    "libgnutlsxx": {
        "license": "LGPLv2.1+"
    },
    "libgobject-2.0": {
        "license": "LGPLv2.1+"
    },
    "libgpg-error": {
        "license": "LGPLv2.1"
    },
    "libgst" : {
        "license": "LGPLv2+"
    },
    "libharfbuzz": {
        "license": "MIT"
    },
    "libhogweed": {
        "license": "LGPLv2+"
    },
    "libiconv": {
        "license": "LGPLv2.1"
    },
    "libicudata": {
        "license": "ICU License"
    },
    "libicui18n": {
        "license": "ICU License"
    },
    "libicuuc": {
        "license": "ICU License"
    },
    "libintl": {
        "license": "LGPLv2.1"
    },
    "libjpeg": {
        "license": "BSD-3-Clause"
    },
    "libmng": {
        "license": "Zlib"
    },
    "libmount": {
        "license": "LGPLv2.1+"
    },
    "libmpg123": {
        "license": "LGPLv2.1"
    },
    "libnettle": {
        "license": "LGPLv2+"
    },
    "libnxclient": {
        "license": "Broadcom Proprietary"
    },
    "libopus": {
        "license": "BSD License 2.0"
    },
    "libpcre": {
        "license": "BSD-3c"
    },
    "libpcreposix": {
        "license": "BSD-3c"
    },
    "libpixman-1": {
        "license": "MIT"
    },
    "libpng16": {
        "license": "libpng license"
    },
    "libsoup-2.4": {
        "license": "LGPLv2+"
    },
    "libsqlite3": {
        "license": "Public Domain"
    },
    "libstdc++": {
        "license": "LGPLv2.1"
    },
    "libtasn1": {
        "license": "LGPLv2.1+"
    },
    "libuuid": {
        "license": "BSD-3c"
    },
    "libwebp": {
        "license": "BSD-3c"
    },
    "libwebpdemux": {
        "license": "BSD-3c"
    },
    "libxkbcommon": {
        "license": "MIT & MIT-style"
    },
    "libxml2": {
        "license": "MIT"
    },
    "libxslt": {
        "license": "MIT"
    },
    "libz": {
        "license": "Zlib"
    }
}


def walkPath(path, array):
	for (dirpath, dirnames, filenames) in walk('/home/wouter/nfs/homecast/usr/lib'):
		array.extend(filenames)

	return array


files = []

print "Reading lib & bin paths"
files = walkPath('/home/wouter/nfs/homecast/usr/lib', files)
files = walkPath('/home/wouter/nfs/homecast/usr/bin', files)

matchedFiles = {}
unmatchedFiles = []

for file in files:

	fileFound = False
	# disect file remove .so-1234
	normalizedFile = file[: file.find('.so') ]

	# try to match with licenseMap
	for licenseMapFilename in licenseMap.keys():
		if normalizedFile.find( licenseMapFilename ) != -1:
			#print "found match with " + normalizedFile
			matchedFiles[ file ] = licenseMap[ licenseMapFilename ]
			fileFound = True
			break


	if fileFound == False:
		print "Unresolved file, please fix mapping:"
		print file
		sys.exit(-1)


print "Writing to wpe_licenses.json"
with open('wpe_licenses.json', 'w') as fp:
    json.dump(matchedFiles, fp, indent=4)

print "Done."

# print unresolved files

# write output license json

