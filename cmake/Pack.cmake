# Setup package generation

if(NOT CPACK_GENERATOR AND NOT APPLE)
  message("-- Finding default package generator")
  if(WIN32)
    set(CPACK_GENERATOR "NSIS")
  else()
    find_program(APT apt)
    find_program(DNF dnf)
    if(APT AND NOT DNF)
      set(CPACK_GENERATOR "DEB")
    elseif(DNF AND NOT APT)
      set(CPACK_GENERATOR "RPM")
    else()
      message("-- Found both apt and dnf.  Setting DEB generator")
      set(CPACK_GENERATOR "DEB")
    endif()
  endif(WIN32)

  message("-- Setup for packaging with ${CPACK_GENERATOR}")
  set(CPACK_GENERATOR ${CPACK_GENERATOR} CACHE STRING
      "Default package generator for platform" FORCE)
endif(NOT CPACK_GENERATOR AND NOT APPLE)

set(CPACK_PACKAGE_VERSION ${SWIPL_VERSION_STRING})
set(CPACK_PACKAGE_NAME "swipl")
set(CPACK_PACKAGE_RELEASE 1)
set(CPACK_PACKAGE_CONTACT "Jan Wielemaker")
set(CPACK_PACKAGE_VENDOR "SWI-Prolog")

# We don't want an additional page when attacking the dmg
if(NOT BUILD_MACOS_BUNDLE)
  set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
endif()

if(CPACK_GENERATOR STREQUAL RPM)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A comprehensive Prolog environment")
else()
file(READ cmake/pack_summary.txt CPACK_PACKAGE_DESCRIPTION_SUMMARY)
endif()

# Stripping on apple complains about dynamic symbols that cannot be
# stripped
if(NOT APPLE)
  set(CPACK_STRIP_FILES ON)
endif()
# set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

if(NOT CMAKE_SYSTEM_PROCESSOR)
  if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(CMAKE_SYSTEM_PROCESSOR x64)
    else()
      set(CMAKE_SYSTEM_PROCESSOR x86)
    endif()
  endif()
endif()

if(WIN32)
  set(CPACK_PACKAGE_INSTALL_DIRECTORY swipl)

  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
  set(CPACK_NSIS_MODIFY_PATH ON)
  set(CPACK_NSIS_DISPLAY_NAME "SWI-Prolog ${CPACK_PACKAGE_VERSION}")
  set(CPACK_NSIS_URL_INFO_ABOUT "http://swi-prolog.org")
  set(CPACK_NSIS_INSTALLED_ICON_NAME bin\\\\swipl-win.exe)
# does not work
# set(CPACK_NSIS_DEFINES "  !define MUI_STARTMENUPAGE_DEFAULTFOLDER \\\"SWI-Prolog\\\"")
endif()

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")

include(CPack)
