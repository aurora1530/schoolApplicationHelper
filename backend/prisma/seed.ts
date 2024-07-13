import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const prefectures = [
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];

const methods = ['一般', '推薦', 'AO'];
const documentTypes = ['入学願書', '成績証明書', '推薦状', '志望動機書', 'その他'];
const subjects = ['国語', '数学', '英語', '理科', '社会', 'その他'];

// generate by chatGPT-4o
const flowerNames = [
  'バラ',
  'チューリップ',
  'ヒマワリ',
  'デイジー',
  'ユリ',
  'ラン',
  'キク',
  'ボタン',
  'アヤメ',
  'ラベンダー',
  'スイセン',
  'マリーゴールド',
  'ヒヤシンス',
  'ケシ',
  'ベゴニア',
  'カーネーション',
  'ガーデニア',
  'ペチュニア',
  'ジャスミン',
  'ジニア',
  'アネモネ',
  'アスター',
  'ツバキ',
  'ダリア',
  'フリージア',
  'ハイビスカス',
  'タチアオイ',
  'モクレン',
  'スイセン',
  'パンジー',
  'プリムラ',
  'ラナンキュラス',
  'キンギョソウ',
  'スイートピー',
  'スミレ',
  'フジ',
  'キンポウゲ',
  'クロッカス',
  'グラジオラス',
  'ライラック',
  'ハス',
  'アサガオ',
  'シャクナゲ',
  'サフラン',
  'スノードロップ',
  'ストック',
  'バーベナ',
  'ヤロウ',
  'アリッサム',
  'ホウセンカ',
  'ツリガネソウ',
  'ケマンソウ',
  'ブーゲンビリア',
  'カレンデュラ',
  'カンナ',
  'コスモス',
  'シクラメン',
  'ルリヒエンソウ',
  'ジギタリス',
  'ガザニア',
  'ゼラニウム',
  'インパチェンス',
  'ランタナ',
  'ロベリア',
  'ミモザ',
  'ネメシア',
  'キョウチクトウ',
  'ペンタス',
  'フロックス',
  'マツバボタン',
  'サルビア',
  'スカビオサ',
  'メキシコマンネングサ',
  'スターチス',
  'ゴクライニチョウ',
  'トレニア',
  'キンレンカ',
  'モクショウ',
  'バーベイン',
  'ウォールフラワー',
  'ワックスフラワー',
  'トリツルソウ',
  'ユッカ',
  'シャコバサボテン',
  'アブチロン',
  'アマランサス',
  'アンジェロニア',
  'トウワタ',
  'バコパ',
  'フウセンカズラ',
  'ボリジ',
  'ブロワリア',
  'カリブラコア',
  'カタナンチェ',
  'クラーキア',
  'コレオプシス',
  'エキナセア',
  'マンネンアオイ',
  'ユーストマ',
  'フクシャ',
];

const highSchoolNames = flowerNames.map((flowerName) => `${flowerName}高校`);

const excludeRandomFromArray = (array: string[]) => {
  while (true) {
    const randomizedArray = array.filter(() => Math.random() > 0.5);
    if (randomizedArray.length > 0) {
      return randomizedArray;
    }
  }
};

const main = async () => {
  for (const prefecture of prefectures) {
    await prisma.prefecture.create({
      data: {
        name: prefecture,
      },
    });
  }

  const deadLineStart = new Date(2025, 1, 1, 23, 59, 59);
  const deadLineDayRange = 30;

  for (const highSchoolName of highSchoolNames) {
    const highSchool = await prisma.highSchool.create({
      data: {
        name: highSchoolName,
        prefectureID: Math.floor(Math.random() * prefectures.length) + 1,
      },
    });

    const methodNum = Math.floor(Math.random() * 3) + 1;
    for (let i = 0; i < methodNum; i++) {
      const deadline = new Date(
        deadLineStart.getTime() +
          Math.floor(Math.random() * deadLineDayRange) * 24 * 60 * 60 * 1000
      );
      await prisma.application.create({
        data: {
          deadline,
          highSchoolID: highSchool.id,
          method: methods[i],
          document: excludeRandomFromArray(documentTypes).join(','),
          subject: excludeRandomFromArray(subjects).join(','),
        },
      });
    }
  }
};

main()
.catch((e) => {
  console.error(e);
})
.finally(async () => {
  await prisma.$disconnect();
})