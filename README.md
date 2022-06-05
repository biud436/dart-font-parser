# Introduction

다트를 이용하여 트루 타입 폰트를 읽고 폰트 파일에서 이름을 추출하는 프로그램입니다.

## Usage

폰트는 인터넷을 통해 다운로드가 이뤄지는데, `lib/common/config.yaml` 파일에서 폰트 위치를 설정할 수 있습니다.

```yaml
font:
    remotePath: https://github.com/biud436/font-parser/raw/main/res/NanumGothicCoding.ttf
    localPath: fonts/NanumGothicCoding.ttf
```

폰트 파서를 실행하려면 다음과 같이 하세요. 테스트 폰트는 나눔고딕코딩 폰트입니다.

```bash
dart bin/dart_font_parser.dart --font=NanumGothicCoding
```

정상적으로 출력된다면 `이 폰트의 이름은 NanumGothicCoding 입니다`와 `이 폰트의 이름은 °¬àµÏTµ) 입니다` 라는 메시지가 출력됩니다.

한글 폰트는 UTF-16-BE 또는 EUC-KR로 인코딩을 해야 정상적으로 표현되는데, 다트에서는 적절한 패키지를 찾지 못했습니다.
