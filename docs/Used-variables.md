### SUGAR_STATUS_PRINT
Option with default value `TRUE`. If this variable is set to `TRUE` process information will be printed.
See [sugar_status_print](https://github.com/ruslo/sugar/tree/master/cmake/print#sugar_status_print)

### SUGAR_STATUS_DEBUG
Option with default value `FALSE`. Works like `SUGAR_STATUS_PRINT` (more verbose). Additionally some debug check performed if this variable is setted to `TRUE` (which can be usually slow, like checking file existence).
See [sugar_status_debug](https://github.com/ruslo/sugar/tree/master/cmake/print#sugar_status_debug)

### SUGAR_SOURCES
List of `sugar_*.cmake` files used in project collected by [sugar_add_this_to_sourcelist](https://github.com/ruslo/sugar/blob/master/cmake/core/sugar_add_this_to_sourcelist.cmake) command.

### SUGAR_ROOT
This variable setted automatically after incuding master [Sugar](https://github.com/ruslo/sugar/tree/master/cmake#master-file) file.

### SUGAR_IOS_ARCH
Optimization for iOS targets building. More [info]
(https://github.com/ruslo/sugar/wiki/Universal-ios-library-%28optimization%29#sugar_ios_arch).