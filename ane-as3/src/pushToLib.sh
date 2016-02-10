cp ane_as3.swc ../../ane-lib/ane_as3.swc
cp ane_as3.swc ane_as3.zip
unzip ane_as3.zip -d temp
cp temp/library.swf ../../ane-lib/android/library.swf
cp temp/library.swf ../../ane-lib/default/library.swf
rm -r temp
rm ane_as3.zip
