{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, av
, ctranslate2
, huggingface-hub
, onnxruntime
, tokenizers

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "faster-whisper";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "guillaumekln";
    repo = "faster-whisper";
    rev = "v${version}";
    hash = "sha256-p8BJ+Bdvn+AQSUS6b2GeYNh2l4KXfPx3o0kImu7xVgw=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "onnxruntime>=1.14,<2" "onnxruntime"
  '';

  propagatedBuildInputs = [
    av
    ctranslate2
    huggingface-hub
    onnxruntime
    tokenizers
  ];

  pythonImportsCheck = [
    "faster_whisper"
  ];

  # all tests require downloads
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/guillaumekln/faster-whisper/releases/tag/v${version}";
    description = "Faster Whisper transcription with CTranslate2";
    homepage = "https://github.com/guillaumekln/faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
