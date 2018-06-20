# - Try to find Argon2
#
# The following variables are optionally searched for defaults:
#  CONAN_ARGON2_ROOT:    Base directory where all Argon2 components are found
#
# The following are set after configuration is done:
#  ARGON2_FOUND
#  ARGON2_INCLUDE_DIRS    --> Argon2's include directories
#  ARGON2_LIBRARIES       --> Argon2's static libraries

include(FindPackageHandleStandardArgs)

if (CONAN_ARGON2_ROOT)
    message(STATUS "CONAN_ARGON2_ROOT: ${CONAN_ARGON2_ROOT}")
    set(CONAN_ARGON2_ROOT "" CACHE PATH "Folder contains Argon2")
endif()

find_path(ARGON2_INCLUDE_DIR "argon2.h"
    PATHS ${CONAN_ARGON2_ROOT} "/usr/include")

find_library(ARGON2_LIBRARY "argon2"
    PATHS ${CONAN_ARGON2_ROOT} "/usr/lib"
    PATH_SUFFIXES "lib" "lib64")

find_package_handle_standard_args(ARGON2 DEFAULT_MSG
    ARGON2_INCLUDE_DIR
    ARGON2_LIBRARY)

if(ARGON2_FOUND)
    set(ARGON2_INCLUDE_DIRS ${ARGON2_INCLUDE_DIR})
    set(ARGON2_LIBRARIES ${ARGON2_LIBRARY})

    message(STATUS "Found Argon2\n"
        " * include: ${ARGON2_INCLUDE_DIRS}\n"
        " * libraries: ${ARGON2_LIBRARIES}\n")
    mark_as_advanced(CONAN_ARGON2_ROOT
        ARGON2_INCLUDE_DIR
        ARGON2_LIBRARY)

    if(NOT TARGET Argon2::Argon2)
        add_library(Argon2::Argon2 UNKNOWN IMPORTED)
        set_target_properties(Argon2::Argon2 PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ARGON2_INCLUDE_DIRS}")
        set_target_properties(Argon2::Argon2 PROPERTIES
            IMPORTED_LOCATION ${ARGON2_LIBRARIES})
    endif()
endif()
