
cmake_minimum_required (VERSION 2.6)

project (VFramework)
set (PROJECT_NAME "VFramework")
set (VERSION "0.0.1")

message ("=== ${PROJECT_NAME} ${VERSION} ===")

set (SRC_DIR src)
set (LIB_DIR lib)

configure_file (
    "${SRC_DIR}/config/config.h.in"
    "${SRC_DIR}/config/config.h"
    )

include (src_list.txt)

include_directories("${SRC_DIR}")

if (STATIC)
    add_library(vframework STATIC ${SRCS})
else (STATIC)
    add_library(vframework SHARED ${SRCS})
endif (STATIC)

set_target_properties (vframework PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR})
set_target_properties (vframework PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${LIB_DIR})
set_target_properties (vframework PROPERTIES CLEAN_DIRECT_OUTPUT 1)



