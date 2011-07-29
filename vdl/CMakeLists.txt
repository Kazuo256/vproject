
cmake_minimum_required (VERSION 2.6)

project (VDL)
set (PROJECT_NAME "VDL")
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
include_directories(../vframework/src)

add_library(vdl SHARED ${SRCS})

find_library(LIB_SDL SDL PATH ${CMAKE_LIBRARY_PATH})
if (NOT LIB_SDL)
    message ("Library not found: SDL")
endif (NOT LIB_SDL)

find_library(LIB_VFRAMEWORK vframework PATH ../vframework/lib)
if (NOT LIB_VFRAMEWORK)
    message ("Library not found: vframework")
endif (NOT LIB_VFRAMEWORK)

set_target_properties (vdl PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR})

target_link_libraries (vdl ${LIB_SDL} ${LIB_VFRAMEWORK})


