
cmake_minimum_required (VERSION 2.6)

project (Outermaze)
set (PROJECT_NAME "Outermaze")
set (VERSION "0.0.1")

message ("=== ${PROJECT_NAME} ${VERSION} ===")

set (SRC_DIR src)
set (BIN_DIR bin)

configure_file (
    "${SRC_DIR}/config/config.h.in"
    "${SRC_DIR}/config/config.h"
    )

include (src_list.txt)

include_directories("${SRC_DIR}")
include_directories(../vframework/src)
include_directories(../vcurses/src)
include_directories(../vdl/src)

## Add the vframework library.
add_executable(outermaze ${SRCS})

find_library(LIB_VFRAMEWORK vframework PATH ../vframework/lib)
if (NOT LIB_VFRAMEWORK)
    message("Library not found: vframework")
endif (NOT LIB_VFRAMEWORK)

find_library(LIB_NCURSES ncurses PATH ${CMAKE_LIBRARY_PATH})
if (NOT LIB_NCURSES)
    message ("Library not found: ncurses")
endif (NOT LIB_NCURSES)

find_library(LIB_VCURSES vcurses PATH ../vcurses/lib)
if (NOT LIB_VCURSES)
    message("Library not found: vcurses")
endif (NOT LIB_VCURSES)

find_library(LIB_SDL SDL PATH ${CMAKE_LIBRARY_PATH})
if (NOT LIB_SDL)
    message ("Library not found: SDL")
endif (NOT LIB_SDL)

find_library(LIB_VDL vdl PATH ../vdl/lib)
if (NOT LIB_VDL)
    message("Library not found: vdl")
endif (NOT LIB_VDL)

set (LIBS ${LIB_VFRAMEWORK} ${LIB_NCURSES} ${LIB_VCURSES} ${LIB_SDL} ${LIB_VDL})

set_target_properties (outermaze PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})
target_link_libraries (outermaze ${LIBS})



