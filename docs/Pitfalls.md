#### Suppress pragma duplication
```cpp
#include <leathers/push>
#include <leathers/format>
#include <leathers/format> // <--- redundant, probably error
// some code
#include <leathers/pop>
```
Error:
```
.../leathers/format:..:.: error:
"`leathers/format` already included; see README.txt for more info"
```

#### Push pragma duplication
```cpp
#include <leathers/push>
#include <leathers/push> // <--- redundant, already "pushed", probably error
#include <leathers/format>
// some code
#include <leathers/pop>
```
Error:
```
.../leathers/push:..:.: error: "Not ending 'leathers/push' include detected;"
```

#### Best practices
To avoid last two pitfalls just remember to **not** "push"/"pop"-ing **before** include directive:
```cpp
#include <leathers/push>
#include <leathers/format>
#include <Foo.hpp> // surprise! suppressing warnings in `Foo.hpp` file
#include <Boo.hpp> // what if there is another 'leathers/push' inside Boo.hpp?
```

#### Broken
This warnings is broken on Visual Studio (bugs closed as `WONTFIX`):
* [4514](https://connect.microsoft.com/VisualStudio/feedback/details/893419) (unreferenced-inline)
* [4503](https://connect.microsoft.com/VisualStudio/feedback/details/898267) (decorated name length exceeded ...)
* [4710](https://connect.microsoft.com/VisualStudio/feedback/details/898281) (function not inlined)
* 4714 (marked as __forceinline not inlined)