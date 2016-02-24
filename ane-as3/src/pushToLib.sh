cp ane_as3.swc ../../ane-lib/ane_as3.swc
cp ane_as3.swc ane_as3.zip
unzip ane_as3.zip -d temp
cp temp/library.swf ../../ane-lib/android/library.swf
cp temp/library.swf ../../ane-lib/default/library.swf
cp temp/library.swf ../../ane-lib/iphone/library.swf
cp temp/library.swf ../../ane-lib/iphonex86/library.swf
cp temp/library.swf ../../ane-lib/androidx86/library.swf
rm -r temp
rm ane_as3.zip
