{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase, qtquickcontrols, curaengine }:

mkDerivation rec {
  name = "cura-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "1x732bzxdxnz1av8jlv5kzs08jpmsg6bz9i88jr63kw32d901xsm";
  };

  buildInputs = [ qtbase qtquickcontrols ];
  propagatedBuildInputs = with python3.pkgs; [ uranium zeroconf pyserial numpy-stl ];
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [ "-DURANIUM_DIR=${python3.pkgs.uranium.src}" ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i 's, executable_name = .*, executable_name = "${curaengine}/bin/CuraEngine",' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://github.com/Ultimaker/Cura";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
