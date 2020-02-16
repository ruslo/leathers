### TODO
```bash
wget https://github.com/phonegap/ios-sim/archive/1.8.2.tar.gz
unpack.py 1.8.2.tar.gz
ios-sim-1.8.2/
xcodebuild -configuration Release -target ios-sim
./build/Release/ios-sim --launch /.../_builds/xcode/Debug-iphonesimulator/example.app --stdout debug.output
```
https://github.com/phonegap/ios-sim