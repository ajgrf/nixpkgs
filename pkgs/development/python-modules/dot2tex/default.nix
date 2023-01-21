{ lib
, python
, buildPythonPackage
, fetchPypi
, substituteAll
, pyparsing
, graphviz
, texlive
}:

buildPythonPackage rec {
  pname = "dot2tex";
  version = "2.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kp77wiv7b5qib82i3y3sn9r49rym43aaqm5aw1bwnzfbbq2m6i9";
  };

  patches = [
    (substituteAll {
      src = ./path.patch;
      inherit graphviz;
    })
    ./test.patch # https://github.com/kjellmf/dot2tex/issues/5
  ];

  propagatedBuildInputs = [ pyparsing ];

  nativeCheckInputs = [
    (texlive.combine {
      inherit (texlive) scheme-small preview pstricks;
    })
  ];

  checkPhase = ''
    ${python.interpreter} tests/test_dot2tex.py
  '';

  meta = with lib; {
    description = "Convert graphs generated by Graphviz to LaTeX friendly formats";
    homepage = "https://github.com/kjellmf/dot2tex";
    license = licenses.mit;
  };

}
