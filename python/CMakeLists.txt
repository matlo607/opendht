# path to opendht library
set(PROJECT_BINARY_DIR ${LIBRARY_OUTPUT_DIRECTORY})

# Used to locate opendht.pyx
set(CURRENT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CURRENT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

configure_file(setup.py.in setup.py)

add_custom_target(python ALL
    COMMAND PYTHONPATH=${CMAKE_CURRENT_SOURCE_DIR} python3 setup.py build
    DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/opendht_cpp.pxd"
    "${CMAKE_CURRENT_SOURCE_DIR}/opendht.pyx"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

install(CODE "execute_process(COMMAND python3 setup.py install --root=\$ENV{DESTDIR}/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})")
if (OPENDHT_TOOLS)
    install(PROGRAMS "${CMAKE_CURRENT_SOURCE_DIR}/tools/dhtcluster.py" DESTINATION ${CMAKE_INSTALL_BINDIR} RENAME dhtcluster)
endif()
