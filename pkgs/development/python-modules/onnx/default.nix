{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, cmake
, protobuf
, numpy
, six
, typing-extensions
, typing
, pytestrunner
, pytest
, nbval
, tabulate
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.8.0";

  # Due to Protobuf packaging issues this build of Onnx with Python 2 gives
  # errors on import.
  # Also support for Python 2 will be deprecated from Onnx v1.8.
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f787fd3ce1290e12da335237b3b921152157e51aa09080b65631b3ce3fcc50c";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.5") [ typing ];

  checkInputs = [
    pytestrunner
    pytest
    nbval
    tabulate
  ];

  postPatch = ''
    patchShebangs tools/protoc-gen-mypy.py
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -r $out/bin
  '';

  # The setup.py does all the configuration
  dontUseCmakeConfigure = true;

  meta = {
    homepage    = "http://onnx.ai";
    description = "Open Neural Network Exchange";
    license     = lib.licenses.mit;
    maintainers = [ lib.maintainers.acairncross ];
  };
}
