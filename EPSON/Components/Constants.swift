//
//  Constants.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/18/24.
//

import Foundation

enum Constants {
  
  static var ip = "127.0.0.1"
  static var baseURL: String { "http://\(ip):8000" }
  
  static let samples = [
    """
    2024년 10월 03일 목요일에 열리는 가을 운동회 안내
    장소와 시간은 XX중학교 운동장, 10시부터 14시 30분까지야. 학부모님들은 9시 45분까지 운동장으로 오시면 되고 차량은 교내 진입 금지야.
    도시락을 꼭 준비해야 한다고 안내해줘.
    특성화, 방과후, 동아리 수업 정상 진행이고 장소가 협소하니 가정 당 한 분만 참석할 수 있다고 해줘.
    마지막으로 사진 촬영은 삼가달라고 안내해줘.
    이 안내문을 25장 인쇄해줘.
    """,
    """
    2024년 10월 03일 목요일에 열리는 가을 운동회 안내
    장소와 시간은 XX중학교 운동장, 10시부터 14시 30분까지야. 학부모님들은 9시 45분까지 운동장으로 오시면 되고 차량은 교내 진입 금지야.
    도시락을 꼭 준비해야 한다고 안내해줘.
    특성화, 방과후, 동아리 수업 정상 진행이고 장소가 협소하니 가정 당 한 분만 참석할 수 있다고 해줘.
    마지막으로 사진 촬영은 삼가달라고 안내해줘.
    이 안내문을 25장 인쇄해줘.
    특성화, 방과후, 동아리 수업 정상 진행이고 장소가 협소하니 가정 당 한 분만 참석할 수 있다고 해줘.
    마지막으로 사진 촬영은 삼가달라고 안내해줘.
    이 안내문을 25장 인쇄해줘.
    """,
    """
    Sample 3
    """,
    """
    Sample 4
    """,
  ]
  
  static let htmlSample = """
<!DOCTYPE html>
<html>

<head>
  <meta name="viewport" content="height=device-height"/>
  <style>
    /* Set A4 size */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    @page {
      size: A4;
      margin: 0;
    }

    html,
    body {
      width: 210mm;
      height: 297mm;
      margin: 0;
      padding: 0;
      display: flex;
    }

    .page {
      width: 80%;
      height: 80%;
      padding: 20px;
      box-sizing: border-box;
      background-color: #f9f9f9;
    }

    .content {
      text-indent: 8px;
      font-size: 14px;
      padding: 1em;
      line-height: 150%;
    }

    .title {
      border: solid 1px;
      padding: 1em;
      width: 80%;
      box-shadow: 5px 5px;
      margin-block: 1.5em;
    }

    table,
    th,
    td {
      border: 1px solid black;
      border-collapse: collapse;
    }
  </style>
</head>

<body>
  <div class="page">
    <table style="border: 1px solid;">
      <tr style="border: 1px solid;">
        <th style="width: 20%; padding: 12px;">
          <p style="font-size: 14px;">큰 꿈을 키우며 사랑이 가득한 해동교육</p>
        </th>
        <th style="width: 60%">
          <div style="display: flex; flex-direction: row; align-items: center; justify-content: center; ;">
            <img width="60px" style="object-fit: cover;" src="./pororo.png" />
            <h1>해 동 알 림 마 당</h1>
          </div>
        </th>
        <th style="width: 20%">
          <p style="font-size: 12px;">
            발행일: 2024. 04. 17.<br>
            발행인 : 김 세 영<br>
            편집인 : 정 재 헌
          </p>
        </th>
      </tr>
      <tr>
        <td colspan="3">
          <p style="text-align: center; font-size: 12px; padding: 4px;">
            ♠ 부산광역시 해운대구 우동 1로 104(우동) ☎ 740-7200 ☞ <a href="http:..www,headong.es.kr">http://www.haedong.es.kr</a>
          </p>
        </td>
      </tr>
      <tr>
        <td class="content" colspan="3">
          <div style="display: flex; justify-content: center;">
            <div class="title">
              <h2 style="text-align: center;">2023학년도 해동 한마음 운동회 안내</h2>
            </div>
          </div>
          <p>
            학부모님 안녕하십니까?<br>
            쑥쑥 자라나는 아이들의 웃음소리가 어우러져 따스함을 더해 주는 계절을 맞이하여 해동 가족들이 함께 하는 『2023학년도 해동 한마음 운동회』 를 준비하였습니다.<br>
            해동 아이들이 한마음 운동회를 통해 활기차고 행복한 시간을 보낼 수 있기를 바랍 니다. 운동회 당일 학부모 줄다리기 및 조부모 선물 낚시도 준비되어 있으니 다양한 활동에 적극적으로 참여하셔서
            많은
            격려와 박수를 보내주시면 감사하겠습니다.<br>
          </p>
          <br>
          <br>
          <p style="font-weight: bold; text-indent: 0px;">
            ◆ 일시 : 2023. 5. 4(목) 08:30~12:20<br>
            &emsp;- 1부(08:30~10:25, 1~6학년 학년군 단체경기, 1~2학년, 5~6학년 개인 달리기)<br>
            &emsp;- 2부(10:40~11:25, 1~6학년 학년군 단체경기, 3~4학년 개인 달리기)<br>
            &emsp;- 3부(11:40~12:20, 1~3학년 줄다리기 및 이어달리기, 4~6학년 줄다리기 및 이어달리기)<br>
            ◆ 장소 : 본교 운동장<br>
            ◆ 종목 : 개인 달리기, 학년군 청백 단체경기(2경기), 청백 이어달리기(저학년, 고학년), 학부모 줄다리기, 어르신들을 위한 경기 등<br>
            ※ 우천 및 미세먼지 나쁨 시 2023. 10. 20.(금)로 순연
          </p>
          <br>
          <p style="text-indent: 0px;">
            ◈부탁의 말씀<br>
            1. 차량은 학교에 진입할 수 없으며 주차장도 개방하지 않습니다.<br>
            2. 학생들에게 급식이 제공되며 식중독 예방을 위하여 일체의 간식 반입을 제한합니다.<br>
            3. 학부모님의 관심과 협조로 청렴한 학교 문화를 만들 수 있도록 동참하여 주십시오.<br>
            4. 학생 수가 많아 별도의 학부모 석을 마련해 드리지 못하는 점을 양해 부탁드립니다.<br>
            5. 원활한 게임 활동 진행을 위하여 우리 학생들과 함께하는 활동에 적극적으로 참여해 주십시오.<br>
            6. 우리 자녀들에게 쓰레기는 가정으로 가져가시는 모범을 보여주시면 해동의 생활교육이 실현됩니다.<br>
          </p>
          <br>
          <p style="text-align: center;">2024. 04. 17.</p>
          <br>
          <h2 style="text-align: center;">해동초등학교장</h2>
        </td>
      </tr>
    </table>
  </div>
</body>

</html>
"""
}
