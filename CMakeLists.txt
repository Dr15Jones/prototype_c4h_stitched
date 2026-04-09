cmake_minimum_required(VERSION 3.16...4.0)

project(CMSSW VERSION 1.0.0 LANGUAGES CXX)

# Set compiler from CVMFS (must be before project())
set(CMAKE_CXX_COMPILER "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923/bin/g++")
set(CMAKE_C_COMPILER "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923/bin/gcc")

# Set C++ standard (C++20 required for concepts)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set output directories
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules")

# Include CMSSW utility macros
include(CMSSSWMacros)

# CVMFS paths for external dependencies
set(TBB_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359")
set(ROOT_DIR "/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830")
set(BOOST_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947")
set(MD5_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376")
set(TINYXML2_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5")
set(CLHEP_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319")
set(Python3_ROOT_DIR "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209")
set(PYBIND11_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773")
set(CPU_FEATURES_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254")

# Set CMAKE_PREFIX_PATH to help find packages
list(APPEND CMAKE_PREFIX_PATH ${TBB_ROOT} ${ROOT_DIR} ${BOOST_ROOT} ${CPU_FEATURES_ROOT} ${CLHEP_ROOT} ${TINYXML2_ROOT} ${PYBIND11_ROOT})

find_package(Boost REQUIRED COMPONENTS program_options filesystem serialization)
message(STATUS "Found Boost: ${Boost_VERSION} at ${Boost_DIR}")
find_package(Threads REQUIRED)
find_package(TBB REQUIRED)
find_package(Python3 COMPONENTS Interpreter Development)
find_package(tinyxml2 REQUIRED)
find_package(MD5 REQUIRED)
find_package(CLHEP REQUIRED)
find_package(pybind11 REQUIRED)
find_package(CpuFeatures REQUIRED)
#the include derived from CpuFeatures appears to point to the wrong directory
get_target_property(CPU_INCLUDES CpuFeatures::cpu_features INTERFACE_INCLUDE_DIRECTORIES)
set_target_properties(CpuFeatures::cpu_features PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CPU_INCLUDES};${CPU_INCLUDES}/..")

# Find ROOT
find_package(ROOT REQUIRED COMPONENTS Core RIO Net Hist Tree)
message(STATUS "Found ROOT: ${ROOT_VERSION} at ${ROOT_DIR}")



# Add compile options
add_compile_options(-Wall -Werror=return-type -Wno-attributes -DPROJECT_VERSION="1_0_0" -DCMS_MICRO_ARCH="UNKNOWN")
add_link_options(LINKER:-z,defs)

# Include GNUInstallDirs before adding subdirectories so CMAKE_INSTALL_* variables are available to root_generate_dictionary
include(GNUInstallDirs)

# Add subdirectories
add_subdirectory(DataFormats)
add_subdirectory(FWCore)
add_subdirectory(SimDataFormats)
add_subdirectory(Utilities)

# Generate plugin cache for all plugin libraries
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        FWCoreModulesPlugins
        FWCoreIntegrationPlugins
        FWCoreMessageServicePlugins
        FWCoreServicesPlugins
        FWCoreTestModulesPlugins
)

# ============================================================================
# Installation and package configuration
# ============================================================================

include(CMakePackageConfigHelpers)

# Set installation directories
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR})
set(LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
set(BIN_INSTALL_DIR ${CMAKE_INSTALL_BINDIR})
set(CONFIG_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/CMSSW)

# Install all targets with EXPORT
# Note: This assumes all libraries are built as SHARED libraries
# and should be exported together

# Get all library targets that were created
set(CMSSW_EXPORT_TARGETS
    # FWCore libraries
    FWCoreUtilities
    FWCorePluginManager
    FWCoreReflection
    FWCoreVersion
    FWCoreParameterSet
    FWCoreParameterSetReader
    FWCorePythonParameterSet
    FWCoreServiceRegistry
    FWCoreMessageLogger
    FWCoreMessageService
    FWCoreAbstractServices
    FWCoreConcurrency
    FWCoreSharedMemory
    FWCoreCommon
    FWCoreFramework
    FWCoreSources
    FWCorePythonFramework
    FWCoreTestProcessor
    FWCoreServices
    FWCoreIntegration
    # FWCore plugins
    FWCoreModulesPlugins
    FWCoreIntegrationPlugins
    FWCoreMessageServicePlugins
    FWCoreServicesPlugins
    FWCoreTestModulesPlugins
    # DataFormats libraries
    DataFormatsCommon
    DataFormatsProvenance
    DataFormatsTestObjects
    DataFormatsStdDictionaries_map
    DataFormatsStdDictionaries_others
    DataFormatsStdDictionaries_pair
    DataFormatsStdDictionaries_vector
    DataFormatsWrappedStdDictionaries
    # SimDataFormats libraries
    SimDataFormatsRandomEngine
)

# Install libraries and executables
foreach(target ${CMSSW_EXPORT_TARGETS})
    if(TARGET ${target})
        install(TARGETS ${target}
            EXPORT CMSSSWTargets
            LIBRARY DESTINATION ${LIB_INSTALL_DIR}
            ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
            RUNTIME DESTINATION ${BIN_INSTALL_DIR}
            INCLUDES DESTINATION ${INCLUDE_INSTALL_DIR}
        )
    endif()
endforeach()

# Install executables
set(CMSSW_EXECUTABLES
    cmsRun
    edmPluginDump
    edmPluginHelp
    edmPluginRefresh
    edmWriteConfigs
)

foreach(exec ${CMSSW_EXECUTABLES})
    if(TARGET ${exec})
        install(TARGETS ${exec}
            EXPORT CMSSSWTargets
            RUNTIME DESTINATION ${BIN_INSTALL_DIR}
        )
    endif()
endforeach()

# Install header files
# Install all interface directories maintaining the package structure
install(DIRECTORY DataFormats/
    DESTINATION ${INCLUDE_INSTALL_DIR}/DataFormats
    FILES_MATCHING
    REGEX "/interface/"
)

install(DIRECTORY FWCore/
    DESTINATION ${INCLUDE_INSTALL_DIR}/FWCore
    FILES_MATCHING
    REGEX "/interface/"
)

install(DIRECTORY SimDataFormats/
    DESTINATION ${INCLUDE_INSTALL_DIR}/SimDataFormats
    FILES_MATCHING
    REGEX "/interface/"
)

install(DIRECTORY Utilities/
    DESTINATION ${INCLUDE_INSTALL_DIR}/Utilities
    FILES_MATCHING
    REGEX "/interface/"
)

# install python
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/python
        DESTINATION ${CMAKE_INSTALL_PREFIX})

# Export targets file
install(EXPORT CMSSSWTargets
    FILE CMSSSWTargets.cmake
    NAMESPACE CMSSW::
    DESTINATION ${CONFIG_INSTALL_DIR}
)

# Configure and install package config files
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CMSSSWConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/CMSSSWConfig.cmake
    INSTALL_DESTINATION ${CONFIG_INSTALL_DIR}
    PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/CMSSSWConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/CMSSSWConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/CMSSSWConfigVersion.cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/CMSSSWMacros.cmake
    DESTINATION ${CONFIG_INSTALL_DIR}
)

# Print installation information
message(STATUS "CMSSW will be installed to: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  Libraries: ${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
message(STATUS "  Headers: ${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}")
message(STATUS "  CMake config: ${CMAKE_INSTALL_PREFIX}/${CONFIG_INSTALL_DIR}")

