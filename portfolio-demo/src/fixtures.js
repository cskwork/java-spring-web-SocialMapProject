// 데모 초기 데이터. 모든 아이디·이름·프로젝트·대회는 가상이며 실제 인물·단체·대회와 무관하다.
// 테이블과 필드 이름은 원본 iBATIS 매핑(src/sql/*.xml)과 VO를 그대로 따른다.
//  member(MemberVO) · projectteam(ProjectTeamVO) · specreg(SpecRegVO) · favoritelist(FavoriteVO)
//  hopelist(HopeListVO) · qna(QnaVO) · custservice(CustserviceVO) · competition(CompetitionVO) · major(MajorVO)

// 데모 로그인 계정 (비밀번호는 모두 demo)
export const DEMO_ACCOUNTS = [
  { id: 'leader01', label: '팀장 (진행 중 프로젝트 있음)' },
  { id: 'leader02', label: '팀장 (새 프로젝트 등록 가능)' },
  { id: 'member01', label: '팀원(프리랜서)' },
];
export const DEMO_PASSWORD = 'demo';

// 원본 ProjectTeamAction/SpecRegAction 생성자가 코드에 직접 넣던 지역 목록
export const REGIONS = ['서울', '부산', '대구', '인천', '광주', '대전', '울산', '세종', '경기도', '강원도', '충청남도', '충청북도', '전라북도', '전라남도', '경상북도', '경상남도', '제주도'];

const member = (id, name, auth, teamno1, addr, maj, exp) => ({
  id, pwd: DEMO_PASSWORD, name, gen: auth === '1' ? '3' : '4', birth: '000101', email: `${id}@example.invalid`,
  auth, teamno1, teamno2: null, teamno3: null, addr, maj, exp,
});

export function seedState() {
  return {
    version: 1,
    session: {},
    seq: { projectteam: 13, hopelist: 4, qna: 5, custservice: 9, competition: 8 },
    major: ['경영학', '국어국문학', '미디어커뮤니케이션', '산업디자인', '소프트웨어공학', '시각디자인', '영상학', '전자공학', '컴퓨터공학', '통계학']
      .map((major_name, i) => ({ major_no: i + 1, major_name })),
    member: [
      member('leader01', '데모팀장', '1', '1', '서울', '컴퓨터공학', '웹 서비스 개발 3년, 교내 공모전 팀장 경험'),
      member('leader02', '신규팀장', '1', null, '경기도', '경영학', '창업 동아리 기획 담당'),
      member('member01', '데모팀원', '2', null, '경기도', '시각디자인', 'UI 디자인 공모전 2회 참여'),
      member('leader03', '가상팀장C', '1', '2', '서울', '통계학', '데이터 분석 스터디 운영'),
      member('leader04', '가상팀장D', '1', '3', '대전', '컴퓨터공학', '해커톤 3회 출전'),
      member('leader05', '가상팀장E', '1', '4', '경기도', '소프트웨어공학', '소규모 쇼핑몰 외주 경험'),
      member('leader06', '가상팀장F', '1', '5', '부산', '컴퓨터공학', '게임 개발 동아리'),
      member('leader07', '가상팀장G', '1', '6', '부산', '시각디자인', '브랜드 디자인 4년'),
      member('leader08', '가상팀장H', '1', '7', '세종', '산업디자인', '서비스 디자인 수업 조교'),
      member('leader09', '가상팀장I', '1', '8', '인천', '경영학', '창업 경진대회 본선 진출'),
      member('leader10', '가상팀장J', '1', '9', '강원도', '영상학', '지역 행사 영상 제작'),
      member('leader11', '가상팀장K', '1', '10', '대구', '통계학', '설문 분석 아르바이트'),
      member('leader12', '가상팀장L', '1', '11', '광주', '전자공학', '임베디드 프로젝트 2건'),
      member('leader13', '가상팀장M', '1', '12', '제주도', '소프트웨어공학', '모바일 앱 1인 개발'),
      member('member02', '샘플팀원B', '2', null, '서울', '컴퓨터공학', '프론트엔드 개발 2년'),
      member('member03', '샘플팀원C', '2', null, '서울', '시각디자인', '앱 화면 디자인 포트폴리오 5건'),
      member('member04', '샘플팀원D', '2', null, '경기도', '컴퓨터공학', '자바 백엔드 학습 1년'),
      member('member05', '샘플팀원E', '2', '1', '서울', '소프트웨어공학', '안드로이드 앱 개발'),
      member('member06', '샘플팀원F', '2', null, '부산', '영상학', '유튜브 편집 2년'),
      member('member07', '샘플팀원G', '2', null, '대전', '통계학', '시각화 공모전 수상 1회'),
      member('member08', '샘플팀원H', '2', null, '인천', '경영학', '마케팅 동아리 운영'),
      member('member09', '샘플팀원I', '2', null, '광주', '전자공학', '아두이노 작품 전시'),
      member('member10', '샘플팀원J', '2', null, '제주도', '산업디자인', '제품 디자인 공모전 참가'),
      member('member11', '샘플팀원K', '2', null, '대구', '미디어커뮤니케이션', '카드뉴스 제작 3년'),
      member('member12', '샘플팀원L', '2', null, '세종', '국어국문학', '기획서·보도자료 작성'),
    ],
    projectteam: [
      { teamno: '1', leaderid: 'leader01', title: '캠퍼스 스터디 매칭 앱', comp: '캠퍼스 앱 개발대회', startdate: '2026-10-05', enddate: '2026-12-20', recmem: '2', currmem: '2', maj: '컴퓨터공학, 시각디자인', loc: '서울', sal: '0', cont: '같은 과목을 듣는 학생끼리 스터디를 묶어 주는 앱을 만듭니다.\n화면 디자인 1명, 서버 개발 1명을 더 모집합니다.\n주 1회 온라인 회의.' },
      { teamno: '2', leaderid: 'leader03', title: '데이터로 보는 우리 동네', comp: '가상 데이터 시각화 공모전', startdate: '2026-10-01', enddate: '2026-10-31', recmem: '2', currmem: '2', maj: '통계학, 시각디자인', loc: '서울', sal: '0', cont: '가상 공공데이터로 동네별 생활 지표 대시보드를 만듭니다. 수상 시 상금은 균등 분배합니다.' },
      { teamno: '3', leaderid: 'leader04', title: '분리배출 안내 챗봇', comp: '친환경 해커톤', startdate: '2026-10-17', enddate: '2026-10-19', recmem: '1', currmem: '3', maj: '컴퓨터공학', loc: '대전', sal: '0', cont: '48시간 해커톤에 분리배출 안내 챗봇으로 출전합니다. 백엔드 1명을 찾습니다.' },
      { teamno: '4', leaderid: 'leader05', title: '동네 반찬가게 주문 웹', comp: '', startdate: '2026-10-12', enddate: '2026-11-30', recmem: '2', currmem: '1', maj: '소프트웨어공학, 시각디자인', loc: '경기도', sal: '200000', cont: '작은 가게가 전화 대신 웹으로 주문을 받도록 하는 외주입니다. 관리자 화면은 단순하게 갑니다.' },
      { teamno: '5', leaderid: 'leader06', title: '2D 퍼즐 게임 제작', comp: '게임잼 챌린지', startdate: '2026-11-07', enddate: '2026-11-09', recmem: '3', currmem: '1', maj: '컴퓨터공학, 영상학', loc: '부산', sal: '0', cont: '주말 게임잼에 2D 퍼즐 게임으로 나갑니다. 사운드·트레일러 영상 가능하신 분 환영합니다.' },
      { teamno: '6', leaderid: 'leader07', title: '독립 서점 리브랜딩', comp: '로컬 브랜드 디자인전', startdate: '2026-10-12', enddate: '2026-12-12', recmem: '1', currmem: '1', maj: '시각디자인', loc: '부산', sal: '180000', cont: '로고, 굿즈, SNS 템플릿까지 브랜드를 정리합니다. 월 2회 대면 회의(부산).' },
      { teamno: '7', leaderid: 'leader08', title: '민원 신청 화면 개선안', comp: '공공 UX 아이디어전', startdate: '2026-10-10', enddate: '2026-11-28', recmem: '2', currmem: '2', maj: '산업디자인, 경영학', loc: '세종', sal: '0', cont: '가상의 민원 신청 화면으로 사용성 테스트를 하고 개선안을 발표합니다.' },
      { teamno: '8', leaderid: 'leader09', title: '대학생 중고거래 플랫폼', comp: '창업 아이디어 공모전', startdate: '2026-10-03', enddate: '2026-11-15', recmem: '2', currmem: '1', maj: '경영학, 컴퓨터공학', loc: '인천', sal: '0', cont: '교내 인증 기반 중고거래 서비스 사업계획서와 시제품을 만듭니다.' },
      { teamno: '9', leaderid: 'leader10', title: '지역 축제 홍보 영상', comp: '', startdate: '2026-10-08', enddate: '2026-10-30', recmem: '1', currmem: '1', maj: '영상학, 미디어커뮤니케이션', loc: '강원도', sal: '150000', cont: '가상의 가을 축제 홍보용 30초·60초 영상 두 편을 만듭니다.' },
      { teamno: '10', leaderid: 'leader11', title: '설문 리포트 자동화', comp: '', startdate: '2026-10-15', enddate: '2026-11-15', recmem: '1', currmem: '1', maj: '통계학, 컴퓨터공학', loc: '대구', sal: '120000', cont: '설문 결과 스프레드시트를 받아 요약 리포트를 자동으로 만드는 스크립트를 작성합니다.' },
      { teamno: '11', leaderid: 'leader12', title: '스마트 화분 IoT', comp: '캠퍼스 앱 개발대회', startdate: '2026-09-01', enddate: '2026-11-30', recmem: '0', currmem: '4', maj: '전자공학, 컴퓨터공학', loc: '광주', sal: '0', cont: '모집이 끝난 팀입니다. 참고용으로 남겨 둡니다.' },
      { teamno: '12', leaderid: 'leader13', title: '반려식물 기록 앱', comp: '', startdate: '2026-10-01', enddate: '2027-01-31', recmem: '3', currmem: '1', maj: '소프트웨어공학, 시각디자인', loc: '제주도', sal: '0', cont: '물 주기 알림과 성장 사진 기록 앱을 주말마다 조금씩 만듭니다. 포트폴리오용.' },
    ],
    specreg: [
      ['member02', '2026-09-02 10:12', '프론트엔드 개발 2년, 쇼핑몰 화면 3건', '컴퓨터공학', '서울', '평일 저녁·주말 가능', 1],
      ['member03', '2026-09-05 21:40', '앱 화면 디자인 포트폴리오 5건', '시각디자인', '서울', '디자인 시스템 정리 선호', 1],
      ['member04', '2026-09-08 09:05', '자바 백엔드 학습 1년, 게시판 프로젝트', '컴퓨터공학', '경기도', '해커톤 첫 참가 희망', 1],
      ['member06', '2026-09-10 14:30', '유튜브 편집 2년, 자막·썸네일', '영상학', '부산', '촬영 장비 보유', 1],
      ['member07', '2026-09-12 18:00', '시각화 공모전 수상 1회', '통계학', '대전', '비공개 스펙 예시', 0],
      ['member08', '2026-09-14 11:20', '마케팅 동아리 운영, SNS 캠페인', '경영학', '인천', '콘텐츠 기획 병행', 1],
      ['member09', '2026-09-15 16:45', '아두이노 작품 전시 2회', '전자공학', '광주', '하드웨어 시제품 가능', 1],
      ['member10', '2026-09-17 08:30', '제품 디자인 공모전 참가', '산업디자인', '제주도', '3D 모델링 가능', 1],
      ['member11', '2026-09-19 13:10', '카드뉴스 제작 3년', '미디어커뮤니케이션', '대구', '카피라이팅 가능', 1],
      ['member12', '2026-09-21 19:25', '기획서·보도자료 작성', '국어국문학', '세종', '문서화 담당 희망', 1],
      ['member05', '2026-09-22 20:00', '안드로이드 앱 개발 1년', '소프트웨어공학', '서울', '현재 캠퍼스 스터디 매칭 앱 참여 중', 1],
    ].map(([id, regdate, exp, maj, addr, contadd, showlog]) => ({ id, regdate, exp, maj, addr, contadd, showlog })),
    // artlog 0: 팀원이 스크랩한 프로젝트(teamno, id) / artlog 1: 팀장이 스크랩한 프리랜서(id, leaderid)
    favoritelist: [
      { artlog: 0, teamno: '3', id: 'member01', leaderid: null },
      { artlog: 1, teamno: null, id: 'member06', leaderid: 'leader01' },
    ],
    // log 1: 팀원 → 팀장 참여 희망 / log 0: 팀장 → 팀원 참여 권유 (원본 MsgAction 주석 기준)
    hopelist: [
      { no: 1, sendid: 'member03', getid: 'leader01', regdate: '2026-09-24 10:00', log: 1 },
      { no: 2, sendid: 'member04', getid: 'leader01', regdate: '2026-09-25 15:30', log: 1 },
      { no: 3, sendid: 'leader04', getid: 'member01', regdate: '2026-09-25 18:10', log: 0 },
    ],
    // qalog 0: 질문, 1: 관리자 답변 (같은 no)
    qna: [
      { no: 1, qalog: 0, id: 'member01', title: '참여 희망은 몇 팀까지 보낼 수 있나요?', cont: '여러 프로젝트에 참여 희망을 보내도 되는지 궁금합니다.', regdate: '2026-09-20 09:10' },
      { no: 1, qalog: 1, id: 'admin', title: 'RE: 참여 희망', cont: '참여 희망은 여러 팀에 보낼 수 있습니다. 다만 한 사람이 동시에 진행할 수 있는 프로젝트는 하나이므로, 먼저 수락된 팀이 생기면 다른 팀의 수락은 막힙니다.', regdate: '2026-09-20 13:00' },
      { no: 2, qalog: 0, id: 'leader01', title: '프로젝트 내용을 고치고 싶어요', cont: '등록한 프로젝트의 모집 전공을 바꾸려면 어떻게 하나요?', regdate: '2026-09-21 11:30' },
      { no: 2, qalog: 1, id: 'admin', title: 'RE: 프로젝트 수정', cont: '프로젝트 상세 화면이나 마이페이지 > 나의 프로젝트에서 "프로젝트 수정"을 누르면 됩니다.', regdate: '2026-09-21 15:20' },
      { no: 3, qalog: 0, id: 'member07', title: '스펙을 비공개로 해도 권유를 받을 수 있나요?', cont: '공개 여부를 끄면 팀장님이 제 스펙을 볼 수 없는지 궁금합니다.', regdate: '2026-09-23 20:45' },
      { no: 4, qalog: 0, id: 'leader03', title: '스크랩한 프리랜서는 어디서 보나요?', cont: '프리랜서 목록에서 스크랩한 뒤 다시 찾는 방법을 알려 주세요.', regdate: '2026-09-24 08:15' },
      { no: 4, qalog: 1, id: 'admin', title: 'RE: 스크랩', cont: '마이페이지 > 관심스펙리스트에서 한 번에 볼 수 있습니다.', regdate: '2026-09-24 10:40' },
    ],
    // custlog 0: 공지사항, 1: FAQ
    custservice: [
      { no: 1, custlog: 0, title: 'SocialMap 데모 안내', cont: '이 사이트는 원본 SocialMap 프로젝트 화면을 그대로 옮긴 데모입니다. 모든 데이터는 가상이며, 신청·글은 이 브라우저에만 저장됩니다.', regdate: '2026-09-20', hits: 12 },
      { no: 2, custlog: 0, title: '프로젝트 참여 규칙 안내', cont: '한 사람은 동시에 하나의 프로젝트만 진행할 수 있습니다. 팀장은 진행 중인 프로젝트가 있으면 새 프로젝트를 등록할 수 없습니다.', regdate: '2026-09-22', hits: 8 },
      { no: 3, custlog: 0, title: '쪽지·평점 기능 안내', cont: '데모에서는 다른 사람에게 쪽지를 보내거나 평점을 남기는 기능을 제공하지 않습니다.', regdate: '2026-09-24', hits: 3 },
      { no: 4, custlog: 1, title: '프로젝트는 어떻게 등록하나요?', cont: '팀장 계정으로 로그인한 뒤 메인의 "프로젝트 등록하기" 또는 프로젝트 목록의 "글쓰기"를 누릅니다.', regdate: '2026-09-18', hits: 0 },
      { no: 5, custlog: 1, title: '프로젝트에 참여하려면?', cont: '팀원 계정으로 프로젝트 상세에서 "프로젝트 참여 희망"을 누르면 팀장의 마이페이지 > 참여 희망자에 올라갑니다. 팀장이 수락하면 팀에 합류합니다.', regdate: '2026-09-18', hits: 0 },
      { no: 6, custlog: 1, title: '팀원을 찾는 방법은?', cont: '프리랜서 찾기에서 지역·전공으로 거르고, 상세보기에서 "프로젝트 참여 권유"를 보낼 수 있습니다.', regdate: '2026-09-18', hits: 0 },
      { no: 7, custlog: 1, title: '스펙은 어떻게 등록하나요?', cont: '팀원 계정으로 프리랜서 찾기 화면의 "스팩등록"을 눌러 이력을 적고 공개 여부를 고릅니다. 한 사람당 하나만 등록할 수 있습니다.', regdate: '2026-09-18', hits: 0 },
      { no: 8, custlog: 1, title: '스크랩한 글은 어디서 보나요?', cont: '마이페이지의 관심플젝리스트(팀원) 또는 관심스펙리스트(팀장)에서 볼 수 있습니다.', regdate: '2026-09-18', hits: 0 },
    ],
    competition: [
      [1, '가상 데이터 시각화 공모전', '2026-10-01', '2026-09-01', '2026-10-31', '가상 공공데이터를 주제로 한 시각화 공모전입니다.', '팀 단위 참가, 최대 4인', 120],
      [2, '친환경 해커톤', '2026-10-17', '2026-09-03', '2026-10-19', '48시간 동안 환경 문제를 푸는 서비스를 만듭니다.', '대전 오프라인 진행', 98],
      [3, '창업 아이디어 공모전', '2026-10-03', '2026-09-05', '2026-11-15', '대학생 창업 아이디어와 사업계획서를 겨룹니다.', '사업계획서 10쪽 이내', 87],
      [4, '게임잼 챌린지', '2026-11-07', '2026-09-10', '2026-11-09', '주말 동안 주제에 맞는 게임을 만듭니다.', '온라인·부산 병행', 64],
      [5, '공공 UX 아이디어전', '2026-10-10', '2026-09-12', '2026-11-28', '공공 서비스 화면의 사용성 개선안을 제안합니다.', '발표 자료 제출', 51],
      [6, '로컬 브랜드 디자인전', '2026-10-12', '2026-09-15', '2026-12-12', '지역 가게의 브랜드를 새로 디자인합니다.', '인쇄물·디지털 모두 가능', 33],
      [7, '캠퍼스 앱 개발대회', '2026-09-01', '2026-08-20', '2026-12-20', '캠퍼스 생활을 돕는 앱을 개발합니다.', '시제품 시연 필수', 20],
    ].map(([no, title, startdate, regdate, enddate, cont, contadd, hits]) => ({ no, title, startdate, regdate, enddate, cont, contadd, showlog: 1, hits })),
  };
}
