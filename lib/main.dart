import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ValueNotifier<bool> isEnglishNotifier = ValueNotifier<bool>(false);
final ValueNotifier<int> userExpNotifier = ValueNotifier<int>(120);
final ValueNotifier<int> completedCountNotifier = ValueNotifier<int>(0);
final ValueNotifier<bool> isUnlockedNotifier = ValueNotifier<bool>(false);

void main() => runApp(const MathHeroApp());

class Question {
  final String id, titleZh, titleEn, categoryZh, categoryEn, questionZh, questionEn;
  final List<String> optionsZh, optionsEn;
  final int correctIndex;
  final String hintZh, hintEn, explanationZh, explanationEn;

  Question({
    required this.id,
    required this.titleZh,
    required this.titleEn,
    required this.categoryZh,
    required this.categoryEn,
    required this.questionZh,
    required this.questionEn,
    required this.optionsZh,
    required this.optionsEn,
    required this.correctIndex,
    required this.hintZh,
    required this.hintEn,
    required this.explanationZh,
    required this.explanationEn,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    id: j['id'] ?? '',
    titleZh: j['titleZh'] ?? '',
    titleEn: j['titleEn'] ?? '',
    categoryZh: j['categoryZh'] ?? '',
    categoryEn: j['categoryEn'] ?? '',
    questionZh: j['questionZh'] ?? '',
    questionEn: j['questionEn'] ?? '',
    optionsZh: List<String>.from(j['optionsZh'] ?? []),
    optionsEn: List<String>.from(j['optionsEn'] ?? []),
    correctIndex: j['correctIndex'] ?? 0,
    hintZh: j['hintZh'] ?? '',
    hintEn: j['hintEn'] ?? '',
    explanationZh: j['explanationZh'] ?? '',
    explanationEn: j['explanationEn'] ?? '',
  );
}

class DynamicQuestionFactory {
  static final Random _rng = Random();

  static Question process(Question q) {
    if (q.id == 'g1_01') {
      int t1 = (_rng.nextInt(4) + 2) * 10;
      int t2 = (_rng.nextInt(3) + 1) * 10;
      int u1 = _rng.nextInt(8) + 1;
      int u2 = 10 - u1;
      int n1 = t1 + u1;
      int n2 = t2 + u2;
      int ans = n1 + n2;

      Set<int> dist = {
        ans + 10,
        ans - 10 > 0 ? ans - 10 : ans + 8,
        ans + 2,
      };
      List<int> opts = [ans, ...dist]..shuffle();

      return Question(
        id: q.id,
        titleZh: q.titleZh,
        titleEn: q.titleEn,
        categoryZh: q.categoryZh,
        categoryEn: q.categoryEn,
        questionZh: '請算出正確答案：$n1 + $n2 = ？',
        questionEn: 'Calculate: $n1 + $n2 = ?',
        optionsZh: opts.map((e) => e.toString()).toList(),
        optionsEn: opts.map((e) => e.toString()).toList(),
        correctIndex: opts.indexOf(ans),
        hintZh: '湊十巧算：個位數的 $u1 與 $u2 正好能湊成 10！先將 10 加到十位數試試看。',
        hintEn: 'Look at the ones digits: $u1 + $u2 = 10! Group them into a ten first.',
        explanationZh: '解析：$t1 + $t2 = ${t1 + t2}，個位 $u1 + $u2 = 10，合起來為 $ans。',
        explanationEn: 'Explanation: $n1 + $n2 = $ans.',
      );
    } else if (q.id == 'g3_03') {
      int length = _rng.nextInt(10) + 6;
      int width = _rng.nextInt(6) + 4;
      int ansArea = length * width;

      Set<int> dist = {
        (length + width) * 2,
        ansArea + 10,
        ansArea - 10 > 0 ? ansArea - 10 : ansArea + 12,
      };
      List<int> opts = [ansArea, ...dist]..shuffle();

      return Question(
        id: q.id,
        titleZh: q.titleZh,
        titleEn: q.titleEn,
        categoryZh: q.categoryZh,
        categoryEn: q.categoryEn,
        questionZh: '一塊長方形花圃的長是 $length 公尺、寬是 $width 公尺，請問它的面積是多少平方公尺？',
        questionEn: 'A rectangular garden has a length of $length m and a width of $width m. What is its area?',
        optionsZh: opts.map((e) => '$e 平方公尺').toList(),
        optionsEn: opts.map((e) => '$e m²').toList(),
        correctIndex: opts.indexOf(ansArea),
        hintZh: '公式回顧：長方形的面積 = 長 × 寬。（即計算 $length × $width）',
        hintEn: 'Formula: Area of a rectangle = length × width ($length × $width).',
        explanationZh: '解析：面積 = 長 × 寬 = $length × $width = $ansArea 平方公尺。',
        explanationEn: 'Explanation: Area = length × width = $length × $width = $ansArea m².',
      );
    }
    return q;
  }
}

class MathHeroApp extends StatelessWidget {
  const MathHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEnglishNotifier,
      builder: (context, isEn, _) => MaterialApp(
        title: isEn ? 'Math Hero' : '數學小英雄',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            primary: const Color(0xFF2563EB),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEnglishNotifier,
      builder: (context, isEn, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton.icon(
                onPressed: () => isEnglishNotifier.value = !isEnglishNotifier.value,
                icon: const Icon(Icons.language, size: 18),
                label: Text(
                  isEn ? '中文' : 'English',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 28),
                Text(
                  isEn ? 'Math Hero' : '數學小英雄',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isEn
                      ? 'Concrete Thinking × Bilingual Number Sense\nAges 6–12'
                      : '專為 6 至 12 歲孩子打造\n具象思維 × 雙語數感啟蒙',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 16, color: Color(0xFF059669)),
                      const SizedBox(width: 6),
                      Text(
                        isEn ? '100% Ad-Free • Safe & Focused Learning' : '100% 零廣告干擾 • 專注無負擔學習',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GradeSelectionScreen(),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isEn ? 'Start Journey' : '開始探索之旅',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradeSelectionScreen extends StatelessWidget {
  const GradeSelectionScreen({super.key});

  String _getBadgeTitle(int exp, bool isEn) {
    if (exp >= 600) return isEn ? 'Ultimate Hero' : '終極小英雄';
    if (exp >= 301) return isEn ? 'Logic Master' : '邏輯小達人';
    if (exp >= 101) return isEn ? 'Math Scholar' : '數理小學者';
    return isEn ? 'Junior Explorer' : '初心探索者';
  }

  void _openPay(BuildContext context, bool isEn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          isEn ? 'Unlock All Grades' : '家長解鎖中心・暢享全題庫',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEn
                  ? '• Complete 1st to 6th Grade curricula\n• 60 carefully crafted visual prompts & hints\n• Dynamic value template for infinite practice\n• One-time purchase, lifetime access, no ads'
                  : '• 完整解鎖國小一至六年級核心概念題庫\n• 60 道情境題與引導式啟發提示\n• 動態題庫演算法：數值無限次自適應更新\n• 一次買斷・永久使用・全家共享・絕無廣告',
              style: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEn ? 'Lifetime Access' : '推廣優惠買斷價',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const Text(
                    'NT\$ 190 / \$5.99',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : '先看看'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              isUnlockedNotifier.value = true;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEn ? 'Full Version Unlocked!' : '已成功解鎖完整版！無限暢遊題庫！'),
                  backgroundColor: const Color(0xFF059669),
                ),
              );
            },
            child: Text(isEn ? 'Unlock Now' : '立即解鎖'),
          ),
        ],
      ),
    );
  }

  void _openInfoDialog(BuildContext context, bool isEn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_rounded, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Text(isEn ? 'EXP & Badge Guide' : '學習積分與徽章說明'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEn ? '⭐️ EXP Scoring Rules:' : '⭐️ 答題積分規則：',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                isEn
                    ? '• First try correct: ⭐️⭐️⭐️ (+10 EXP)\n• Second try correct: ⭐️⭐️ (+6 EXP)\n• Try & elimination reward: ⭐️ (+2 EXP)'
                    : '• 一次答對：⭐️⭐️⭐️ (+10 EXP)\n• 修正後答對：⭐️⭐️ (+6 EXP)\n• 排除錯誤勇於嘗試：⭐️ (+2 EXP 鼓勵分)',
                style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 14),
              Text(
                isEn ? '🎖 Badges Tier:' : '🎖 徽章榮譽階梯：',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                isEn
                    ? '• 0–100 EXP: Junior Explorer\n• 101–300 EXP: Math Scholar\n• 301–600 EXP: Logic Master\n• 600+ EXP: Ultimate Hero'
                    : '• 0–100 EXP: 初心探索者\n• 101–300 EXP: 數理小學者\n• 301–600 EXP: 邏輯小達人\n• 600+ EXP: 終極數學小英雄',
                style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Got it' : '了解'),
          ),
        ],
      ),
    );
  }

  Future<void> _start(BuildContext context, String path, {bool isDaily = false}) async {
    try {
      final str = await rootBundle.loadString(path);
      final List list = json.decode(str);
      List<Question> qs = list.map((e) => DynamicQuestionFactory.process(Question.fromJson(e))).toList();

      if (isDaily) {
        qs.shuffle();
        qs = qs.take(3).toList();
      }

      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(questions: qs)));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEnglishNotifier,
      builder: (context, isEn, _) => ValueListenableBuilder<bool>(
        valueListenable: isUnlockedNotifier,
        builder: (context, isUnlocked, _) => ValueListenableBuilder<int>(
          valueListenable: userExpNotifier,
          builder: (context, exp, _) => ValueListenableBuilder<int>(
            valueListenable: completedCountNotifier,
            builder: (context, count, _) => Scaffold(
              appBar: AppBar(
                title: Text(
                  isEn ? 'Math Hero Dashboard' : '數學小英雄大廳',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(
                      isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                      color: isUnlocked ? const Color(0xFF059669) : const Color(0xFF475569),
                    ),
                    tooltip: isEn ? 'Parents Unlock Center' : '家長解鎖中心',
                    onPressed: () => isUnlocked ? isUnlockedNotifier.value = false : _openPay(context, isEn),
                  ),
                  TextButton.icon(
                    onPressed: () => isEnglishNotifier.value = !isEnglishNotifier.value,
                    icon: const Icon(Icons.language, size: 18),
                    label: Text(isEn ? '中文' : 'English', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 26),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEn ? '5-Day Streak' : '連續學習 5 天',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      isEn ? 'EXP: $exp' : '經驗值: $exp',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEFCE8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.military_tech_rounded, color: Color(0xFFCA8A04), size: 26),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEn ? '$count Solved' : '已完成 $count 題',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      _getBadgeTitle(exp, isEn),
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => _openInfoDialog(context, isEn),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFBFDBFE)),
                                    ),
                                    child: const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF2563EB)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _start(context, 'assets/data/questions_grade1_2.json', isDaily: true),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.flag_rounded, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          isEn ? 'Today’s 3 Mini-Quests' : '今日 3 題思維挑戰',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFDE047),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'DAILY',
                                            style: TextStyle(
                                              color: Color(0xFF713F12),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isEn ? 'Quick 5-minute brain warmup!' : '隨機精選 3 題，動腦保持手感！',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _card(
                        title: isEn ? 'Grade 1–2: Concrete Math' : '一至二年級：具象數感與計算',
                        sub: isEn ? 'Making 10, Telling Time (Free)' : '湊十進位、生活時鐘（免費體驗）',
                        icon: Icons.school_rounded,
                        color: const Color(0xFF0284C7),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isEn ? 'Free' : '免費',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                          ),
                        ),
                        onTap: () => _start(context, 'assets/data/questions_grade1_2.json'),
                      ),
                      const SizedBox(height: 12),
                      _card(
                        title: isEn ? 'Grade 3–4: Area & Time' : '三至四年級：乘除與幾何面積',
                        sub: isEn ? 'Long Division, Rectangles' : '直式乘除、長方形面積計算',
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFFD97706),
                        trailing: Icon(
                          isUnlocked ? Icons.arrow_forward_ios_rounded : Icons.lock_rounded,
                          size: 16,
                          color: isUnlocked ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        onTap: () => isUnlocked ? _start(context, 'assets/data/questions_grade3_4.json') : _openPay(context, isEn),
                      ),
                      const SizedBox(height: 12),
                      _card(
                        title: isEn ? 'Grade 5–6: Pre-Algebra' : '五至六年級：代數小偵探與幾何',
                        sub: isEn ? 'Balance Scales & Equations' : '等量公理天平、純方程思維',
                        icon: Icons.psychology_rounded,
                        color: const Color(0xFF7C3AED),
                        trailing: Icon(
                          isUnlocked ? Icons.arrow_forward_ios_rounded : Icons.lock_rounded,
                          size: 16,
                          color: isUnlocked ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        onTap: () => isUnlocked ? _start(context, 'assets/data/questions_grade5_6.json') : _openPay(context, isEn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required String sub,
    required IconData icon,
    required Color color,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  final List<Question> questions;

  const QuestionScreen({
    super.key,
    required this.questions,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _idx = 0;
  int? _sel;
  bool _answered = false;
  bool _isAnswerCorrect = false;
  bool _showHint = false;
  final Set<int> _disabledOptionIndices = {};

  int _sessionStars = 0;
  int _sessionExp = 0;

  final List<String> _optionLabels = ['A', 'B', 'C', 'D'];

  void _checkAnswer(int i) {
    if (_answered && _isAnswerCorrect) return;

    final q = widget.questions[_idx];
    setState(() {
      _sel = i;
      _answered = true;
    });

    if (i == q.correctIndex) {
      int stars = _disabledOptionIndices.isEmpty ? 3 : 2;
      int exp = _disabledOptionIndices.isEmpty ? 10 : 6;
      setState(() {
        _isAnswerCorrect = true;
        _sessionStars += stars;
        _sessionExp += exp;
      });
      userExpNotifier.value += exp;
      completedCountNotifier.value += 1;
    } else {
      setState(() {
        _disabledOptionIndices.add(i);
        _isAnswerCorrect = false;
        _sessionExp += 2;
      });
      userExpNotifier.value += 2;
    }
  }

  void _showCompletionDialog(bool isEn) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              isEn ? 'Quest Completed!' : '恭喜完成挑戰！',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            Text(
              isEn ? 'You did an incredible job today!' : '今天表現超亮眼，邏輯力滿分！',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFEAB308), size: 22),
                          const SizedBox(width: 4),
                          Text(
                            '$_sessionStars',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn ? 'Stars Earned' : '獲得星星',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 32, color: const Color(0xFFCBD5E1)),
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, color: Color(0xFF2563EB), size: 22),
                          const SizedBox(width: 2),
                          Text(
                            '+$_sessionExp',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn ? 'EXP Gained' : '增加經驗值',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text(
                  isEn ? 'Back to Dashboard' : '返回大廳領取榮譽',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_idx];

    return ValueListenableBuilder<bool>(
      valueListenable: isEnglishNotifier,
      builder: (context, isEn, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            isEn ? 'Level ${_idx + 1} of ${widget.questions.length}' : '第 ${_idx + 1} / ${widget.questions.length} 關',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            TextButton.icon(
              onPressed: () => isEnglishNotifier.value = !isEnglishNotifier.value,
              icon: const Icon(Icons.language, size: 18),
              label: Text(isEn ? '中文' : 'English', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (_idx + 1) / widget.questions.length,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isEn ? q.categoryEn : q.categoryZh,
                          style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => setState(() => _showHint = !_showHint),
                        icon: Icon(
                          _showHint ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                          color: const Color(0xFFD97706),
                          size: 18,
                        ),
                        label: Text(
                          isEn ? 'Hint' : '引導提示',
                          style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (_showHint) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFD97706), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isEn ? q.hintEn : q.hintZh,
                              style: const TextStyle(color: Color(0xFF78350F), fontSize: 13, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? q.titleEn : q.titleZh,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEn ? q.questionEn : q.questionZh,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  ...List.generate(
                    isEn ? q.optionsEn.length : q.optionsZh.length,
                    (i) {
                      bool isCorrect = i == q.correctIndex;
                      bool isSelected = _sel == i;
                      bool isDisabled = _disabledOptionIndices.contains(i);

                      Color bg = Colors.white;
                      Color borderColor = const Color(0xFFE2E8F0);
                      Color textColor = const Color(0xFF1E293B);

                      if (_isAnswerCorrect && isCorrect) {
                        bg = const Color(0xFFECFDF5);
                        borderColor = const Color(0xFF10B981);
                        textColor = const Color(0xFF065F46);
                      } else if (isDisabled) {
                        bg = const Color(0xFFF1F5F9);
                        textColor = const Color(0xFF94A3B8);
                        borderColor = Colors.transparent;
                      }

                      String label = i < _optionLabels.length ? _optionLabels[i] : '${i + 1}';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: bg,
                            side: BorderSide(color: borderColor, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: isDisabled || (_answered && _isAnswerCorrect) ? null : () => _checkAnswer(i),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDisabled ? const Color(0xFFCBD5E1) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDisabled ? Colors.white : const Color(0xFF1D4ED8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  isEn ? q.optionsEn[i] : q.optionsZh[i],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: (_isAnswerCorrect && isCorrect) || isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  if (_answered) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isAnswerCorrect ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isAnswerCorrect ? const Color(0xFFA7F3D0) : const Color(0xFFFED7AA),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isAnswerCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                                color: _isAnswerCorrect ? const Color(0xFF059669) : const Color(0xFFEA580C),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _isAnswerCorrect
                                      ? (_disabledOptionIndices.isEmpty
                                          ? (isEn ? 'Awesome! ⭐️⭐️⭐️ (+10 EXP)' : '太棒了！一次答對 ⭐️⭐️⭐️ (+10 EXP)')
                                          : (isEn ? 'Great Persistence! ⭐️⭐️ (+6 EXP)' : '答對了！堅持就是勝利 ⭐️⭐️ (+6 EXP)'))
                                      : (isEn ? 'Keep trying! ⭐️ (+2 EXP encouragement)' : '再想一想！已排除錯誤選項 ⭐️ (+2 EXP 鼓勵)'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: _isAnswerCorrect ? const Color(0xFF065F46) : const Color(0xFF9A3412),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_isAnswerCorrect) ...[
                            const SizedBox(height: 8),
                            Text(
                              isEn ? q.explanationEn : q.explanationZh,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.5),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isAnswerCorrect)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (_idx < widget.questions.length - 1) {
                            setState(() {
                              _idx++;
                              _sel = null;
                              _answered = false;
                              _isAnswerCorrect = false;
                              _showHint = false;
                              _disabledOptionIndices.clear();
                            });
                          } else {
                            _showCompletionDialog(isEn);
                          }
                        },
                        child: Text(
                          _idx < widget.questions.length - 1
                              ? (isEn ? 'Next Question →' : '下一題挑戰 →')
                              : (isEn ? 'Complete Quest 🎉' : '完成挑戰 🎉'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}