# CMake Build System - Library Summary

## Generated Libraries

This CMake build system will create the following shared libraries:

### DataFormats Libraries
1. **libDataFormatsCommon.so** - Common data format classes
2. **libDataFormatsProvenance.so** - Provenance and metadata classes
3. **libDataFormatsStdDictionaries.so** - ROOT dictionaries for standard types
4. **libDataFormatsTestObjects.so** - Test objects for framework testing
5. **libDataFormatsWrappedStdDictionaries.so** - Wrapped standard dictionaries

### FWCore Libraries
6. **libFWCoreAbstractServices.so** - Abstract service interfaces
7. **libFWCoreCommon.so** - Common FWCore utilities
8. **libFWCoreConcurrency.so** - Concurrency and threading support
9. **libFWCoreFramework.so** - Main framework library
10. **libFWCoreIntegration.so** - Integration test support
11. **libFWCoreMessageLogger.so** - Message logging system
12. **libFWCoreMessageService.so** - Message service implementation
13. **libFWCoreModules.so** - Standard framework modules
14. **libFWCoreParameterSet.so** - Configuration parameter handling
15. **libFWCoreParameterSetReader.so** - Parameter set reading
16. **libFWCorePluginManager.so** - Plugin loading and management
17. **libFWCorePythonFramework.so** - Python bindings for framework (if Python available)
18. **libFWCorePythonParameterSet.so** - Python parameter set interface (if Python available)
19. **libFWCoreReflection.so** - Type reflection utilities
20. **libFWCoreServiceRegistry.so** - Service registry and management
21. **libFWCoreServices.so** - Standard framework services
22. **libFWCoreSharedMemory.so** - Shared memory support
23. **libFWCoreSources.so** - Input source implementations
24. **libFWCoreTestProcessor.so** - Test processor utilities
25. **libFWCoreUtilities.so** - Base utilities library
26. **libFWCoreVersion.so** - Version information

### SimDataFormats Libraries
27. **libSimDataFormatsRandomEngine.so** - Random number engine state storage

### Utilities Libraries
28. **libUtilitiesTesting.so** - Testing utilities (if sources exist)

## Plugin Modules

The following plugin modules will be built:
- **FWCoreIntegrationPlugins** - Integration test plugins
- **FWCoreMessageServicePlugins** - Message service plugins
- **FWCoreServicesPlugins** - Service plugins

## Dependencies

### External Dependencies Required
- Boost (program_options, filesystem, serialization)
- Intel TBB (Threading Building Blocks)
- pthreads
- UUID library
- MD5 library

### External Dependencies Optional
- ROOT (Core, RIO, Net, Tree, Hist)
- Python3 (for Python bindings)
- TinyXML2 (for XML parsing)

## Build Order

The CMake system will automatically build libraries in the correct dependency order:

1. Base libraries (FWCoreUtilities, FWCoreReflection)
2. DataFormats/Provenance
3. FWCore/MessageLogger
4. DataFormats/Common
5. FWCore framework components
6. Higher-level services and modules

## Library Naming Convention

Libraries follow the pattern: `lib<Subsystem><Package>.so`

Examples:
- `FWCore/Utilities` → `libFWCoreUtilities.so`
- `DataFormats/Common` → `libDataFormatsCommon.so`
- `SimDataFormats/RandomEngine` → `libSimDataFormatsRandomEngine.so`

## Include Paths

Each library exports its interface directory, making headers accessible as:
```cpp
#include "FWCore/Utilities/interface/Exception.h"
#include "DataFormats/Common/interface/Handle.h"
```

## Build System Features

- Automatic dependency resolution
- Parallel builds supported
- Proper include path propagation
- Plugin building for selected packages
- Optional component handling (Python, ROOT)
- Position-independent code by default
- Symbol visibility control
