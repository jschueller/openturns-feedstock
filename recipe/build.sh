#!/bin/sh

# dynamic lookup patches
curl -L https://github.com/openturns/openturns/commit/d3ddfaba807a649a7a95cefce9f66b4ce22514ee.patch | patch -p1
curl -L https://github.com/openturns/openturns/commit/e9f265e38b30091eefa324489aeef6f881033408.patch | patch -p1
curl -L https://github.com/openturns/openturns/commit/0fb469153aa8bb0035c62d0ed56122733d20fcc8.patch | patch -p1

mkdir build && cd build

cmake \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DLAPACK_LIBRARIES="$PREFIX/lib/libopenblas${SHLIB_EXT}" \
  -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_MACOSX_RPATH=ON \
  -DUSE_COTIRE=ON -DCOTIRE_MAXIMUM_NUMBER_OF_UNITY_INCLUDES="-j${CPU_COUNT}" \
  ..
make install -j${CPU_COUNT}
rm -r ${PREFIX}/share/gdb
ctest -R pyinstallcheck --output-on-failure -j${CPU_COUNT}
