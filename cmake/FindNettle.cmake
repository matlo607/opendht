# - Try to find Nettle
#
# The following variables are optionally searched for defaults:
#  CONAN_NETTLE_ROOT:    Base directory where all Nettle components are found
#
# The following are set after configuration is done:
#  NETTLE_FOUND
#  NETTLE_INCLUDE_DIRS    --> Nettle's include directories
#  NETTLE_LIBRARIES       --> Nettle's static libraries

include(FindPackageHandleStandardArgs)

if (CONAN_NETTLE_ROOT)
    message(STATUS "CONAN_NETTLE_ROOT: ${CONAN_NETTLE_ROOT}")
    set(CONAN_NETTLE_ROOT "" CACHE PATH "Folder contains Nettle")
endif()

find_path(NETTLE_INCLUDE_DIR "nettle/nettle-types.h"
    PATHS ${CONAN_NETTLE_ROOT} "/usr/include")

find_library(NETTLE_LIBRARY "nettle"
    PATHS ${CONAN_NETTLE_ROOT} "/usr/lib"
    PATH_SUFFIXES "lib" "lib64")

find_library(HOGWEED_LIBRARY "hogweed"
    PATHS ${CONAN_NETTLE_ROOT} "/usr/lib"
    PATH_SUFFIXES "lib" "lib64")

find_package_handle_standard_args(NETTLE DEFAULT_MSG
    NETTLE_INCLUDE_DIR
    NETTLE_LIBRARY
    HOGWEED_LIBRARY)

if(NETTLE_FOUND)
    set(NETTLE_INCLUDE_DIRS ${NETTLE_INCLUDE_DIR})
    set(NETTLE_LIBRARIES ${NETTLE_LIBRARY} ${HOGWEED_LIBRARY})

    message(STATUS "Found Nettle\n"
        " * include: ${NETTLE_INCLUDE_DIRS}\n"
        " * libraries: ${NETTLE_LIBRARIES}\n")
    mark_as_advanced(CONAN_NETTLE_ROOT
        NETTLE_INCLUDE_DIR
        NETTLE_LIBRARY
        HOGWEED_LIBRARY)

    if(NOT TARGET Nettle::Nettle)
        add_library(Nettle::Nettle UNKNOWN IMPORTED)
        set_target_properties(Nettle::Nettle PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${NETTLE_INCLUDE_DIRS}"
            IMPORTED_LOCATION ${NETTLE_LIBRARY})
    endif()

    if(NOT TARGET Nettle::Hogweed)
        add_library(Nettle::Hogweed UNKNOWN IMPORTED)
        #set_target_properties(Nettle::Hogweed PROPERTIES
        #    INTERFACE_INCLUDE_DIRECTORIES "${NETTLE_INCLUDE_DIRS}")
        set_target_properties(Nettle::Hogweed PROPERTIES
            IMPORTED_LOCATION ${HOGWEED_LIBRARY}
            INTERFACE_LINK_LIBRARIES Nettle::Nettle)
    endif()
endif()
