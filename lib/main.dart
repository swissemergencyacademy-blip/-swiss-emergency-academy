
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SwissEmergencyAcademyApp());

class FavoritesStore {
  static const key = 'favorite_topics';

  static Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(key) ?? <String>[]).toSet();
  }

  static Future<void> toggle(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final items = (prefs.getStringList(key) ?? <String>[]).toSet();
    items.contains(topic) ? items.remove(topic) : items.add(topic);
    await prefs.setStringList(key, items.toList()..sort());
  }
}

Future<void> callNumber(BuildContext context, String number) async {
  bool opened = false;
  try {
    opened = await launchUrl(Uri(scheme: 'tel', path: number));
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Telefonfunktion nicht verfügbar. Bitte $number manuell in der Telefon-App wählen.'),
      duration: const Duration(seconds: 8),
    ));
  }
}

const red = Color(0xFFD71920);
const navy = Color(0xFF102A43);

class SwissEmergencyAcademyApp extends StatelessWidget {
  const SwissEmergencyAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swiss Emergency Academy by Courvoisier',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: red),
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          centerTitle: false,
        ),
      ),
      home: const SplashPage(),
    );
  }
}


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: navy,
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.health_and_safety, size: 62, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Swiss Emergency Academy',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('by Courvoisier',
              style: TextStyle(color: Colors.white70, fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.white),
          ]),
        ),
      ),
    ),
  );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  final pages = const [
    HomePage(),
    KnowledgePage(),
    EmergencyNumbersPage(),
    FavoritesPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Start'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Wissen'),
          NavigationDestination(icon: Icon(Icons.phone_outlined), selectedIcon: Icon(Icons.phone), label: 'Notruf'),
          NavigationDestination(icon: Icon(Icons.star_outline), selectedIcon: Icon(Icons.star), label: 'Favoriten'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Mehr'),
        ],
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  final String? subtitle;
  const BrandHeader({super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 18),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Swiss Emergency Academy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: navy)),
              const Text('by Courvoisier', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: red)),
            ]),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void open(BuildContext c, Widget page) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const BrandHeader(subtitle: 'by Courvoisier'),
        Container(
          padding: const EdgeInsets.all(22),
          color: navy,
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Erste Hilfe.', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Einfach. Klar. Jederzeit.', style: TextStyle(color: Colors.white70, fontSize: 18)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 24)),
                onPressed: () => open(context, const GuidedEmergencyPage()),
                icon: const Icon(Icons.emergency, size: 30),
                label: const Text('NOTFALL – JETZT HELFEN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.35,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                ActionCard(Icons.favorite, 'Reanimation & AED', () => open(context, const CprPage())),
                ActionCard(Icons.medical_services, 'Notfälle', () => open(context, const TopicsPage())),
                ActionCard(Icons.menu_book, 'Wissen A–Z', () => open(context, const KnowledgePage())),
                ActionCard(Icons.checklist, 'Checklisten', () => open(context, const ChecklistPage())),
              ],
            ),
            const SizedBox(height: 12),
            const InfoBox('Kerninhalte werden lokal in der App gespeichert und stehen dadurch grundsätzlich auch ohne Internetverbindung zur Verfügung.'),
          ]),
        )
      ],
    );
  }
}

class EmergencyModePage extends StatelessWidget {
  const EmergencyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Notfallmodus',
      children: [
        const AlertBox('Bei unmittelbarer Gefahr zuerst Eigenschutz beachten und professionelle Hilfe alarmieren.'),
        const StepTile('1', 'Umgebung prüfen', 'Bestehen Gefahren für dich, die betroffene Person oder andere?'),
        const StepTile('2', 'Reaktion prüfen', 'Person ansprechen und Reaktion beurteilen.'),
        const StepTile('3', 'Atmung beurteilen', 'Prüfen, ob eine normale Atmung vorhanden ist.'),
        const SizedBox(height: 12),
        BigButton('NOTRUF ÖFFNEN', Icons.phone, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbersPage()));
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CprPage())),
          icon: const Icon(Icons.favorite),
          label: const Text('Reanimation / AED'),
        ),
        const PrototypeNotice(),
      ],
    );
  }
}

class EmergencyNumbersPage extends StatelessWidget {
  const EmergencyNumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Notruf',
      children: [
        EmergencyNumber('144', 'Sanitätsnotruf'),
        EmergencyNumber('112', 'Europäische Notrufnummer'),
        EmergencyNumber('145', 'Tox Info Suisse'),
        SizedBox(height: 14),
        InfoBox('Für das Gespräch bereithalten: genauer Ort, was passiert ist, Anzahl Betroffener und Zustand. Auf Rückfragen der Leitstelle warten.'),
      ],
    );
  }
}

class CprPage extends StatelessWidget {
  const CprPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Reanimation & AED',
      children: [
        AlertBox('Dieses Modul ist noch nicht medizinisch freigegeben.'),
        StepTile('1', 'Professionelle Hilfe', 'Notruf organisieren und AED holen lassen, sofern verfügbar.'),
        StepTile('2', 'Reanimation', 'Die finale Version erhält hier die fachlich freigegebene Schritt-für-Schritt-Anleitung.'),
        StepTile('3', 'AED', 'AED einschalten und den Anweisungen des Geräts folgen.'),
        PrototypeNotice(),
      ],
    );
  }
}

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});
  static const topics = [
    ['Starke Blutung', Icons.bloodtype],
    ['Verschlucken / Ersticken', Icons.air],
    ['Bewusstlosigkeit', Icons.accessibility_new],
    ['Verbrennungen', Icons.local_fire_department],
    ['Krampfanfall', Icons.monitor_heart],
    ['Vergiftung', Icons.warning_amber],
    ['Wunden', Icons.healing],
    ['Knochen / Gelenke', Icons.personal_injury],
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Notfallthemen',
      children: topics.map((t) => Card(
        child: ListTile(
          leading: Icon(t[1] as IconData, color: red),
          title: Text(t[0] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: const Text('Offline-Modul • medizinische Freigabe ausstehend'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => TopicDetail(title: t[0] as String),
          )),
        ),
      )).toList(),
    );
  }
}

class TopicDetail extends StatelessWidget {
  final String title;
  const TopicDetail({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      children: const [
        AlertBox('Prototyp-Modul – noch nicht für die Anwendung in einem realen medizinischen Notfall freigegeben.'),
        StepTile('1', 'Situation beurteilen', 'Eigenschutz und Zustand der betroffenen Person beurteilen.'),
        StepTile('2', 'Hilfe organisieren', 'Bei einem ernsten oder unklaren Zustand professionelle Hilfe alarmieren.'),
        StepTile('3', 'Fachinhalt folgt', 'Hier wird die medizinisch geprüfte Anleitung für dieses Notfallbild eingesetzt.'),
        PrototypeNotice(),
      ],
    );
  }
}

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});
  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  static const entries = ['AED', 'Bewusstlosigkeit', 'Blutungen', 'Reanimation', 'Verbrennungen', 'Vergiftungen', 'Verschlucken', 'Wunden'];
  Set<String> favorites = {};
  String query = "";
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    load();
  }
  Future<void> load() async {
    favorites = await FavoritesStore.load();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Wissen A–Z',
    children: [
      const InfoBox('Lernbereich mit lokal strukturierten Inhalten. Tippe auf den Stern, um ein Thema dauerhaft als Favorit zu speichern.'),
      TextField(
        controller: searchController,
        onChanged: (value) => setState(() => query = value.trim().toLowerCase()),
        decoration: InputDecoration(
          labelText: 'Thema suchen',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          suffixIcon: query.isEmpty ? null : IconButton(
            tooltip: 'Suche löschen',
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              setState(() => query = '');
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      if (!entries.any((e) => e.toLowerCase().contains(query)))
        const InfoBox('Kein Thema gefunden. Versuche einen anderen Suchbegriff.'),
      ...entries.where((e) => e.toLowerCase().contains(query)).map((e) => ListTile(
        leading: CircleAvatar(backgroundColor: navy, foregroundColor: Colors.white, child: Text(e[0])),
        title: Text(e),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TopicDetail(title: e))),
        trailing: IconButton(
          icon: Icon(favorites.contains(e) ? Icons.star : Icons.star_border, color: favorites.contains(e) ? red : null),
          onPressed: () async { await FavoritesStore.toggle(e); await load(); },
        ),
      )),
    ],
  );
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<String> items = {};
  @override
  void initState() {
    super.initState();
    refresh();
  }
  Future<void> refresh() async {
    items = await FavoritesStore.load();
    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Favoriten',
    children: items.isEmpty
      ? const [InfoBox('Noch keine Favoriten gespeichert. Im Wissen-A–Z-Bereich kannst du Themen markieren.')]
      : items.map((e) => ListTile(
          leading: const Icon(Icons.star, color: red),
          title: Text(e),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TopicDetail(title: e))),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async { await FavoritesStore.toggle(e); await refresh(); },
          ),
        )).toList(),
  );
}

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});
  @override
  Widget build(BuildContext context) => const AppScaffold(
    title: 'Checklisten',
    children: [
      CheckItem('Notrufnummern kennen'),
      CheckItem('Erste-Hilfe-Material prüfen'),
      CheckItem('AED-Standort kennen'),
      CheckItem('Erste-Hilfe-Wissen regelmässig auffrischen'),
    ],
  );
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Mehr',
    children: [
      const ListTile(leading: Icon(Icons.download), title: Text('Offline-Inhalte'), subtitle: Text('Kernmodule lokal verfügbar')),
      const ListTile(leading: Icon(Icons.video_library), title: Text('Videos'), subtitle: Text('Für spätere Lernvideos vorbereitet')),
      const ListTile(leading: Icon(Icons.location_on), title: Text('AED-Standorte'), subtitle: Text('Standortdienst wird später angebunden')),
      const ListTile(leading: Icon(Icons.settings), title: Text('Einstellungen')),
      ListTile(
        leading: const Icon(Icons.info),
        title: const Text('Über die Academy'),
        subtitle: const Text('Swiss Emergency Academy by Courvoisier'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAcademyPage())),
      ),
      const PrototypeNotice(),
    ],
  );
}

class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AppScaffold({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(padding: const EdgeInsets.all(16), children: children),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionCard(this.icon, this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: red, size: 30),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      ),
    ),
  );
}

class StepTile extends StatelessWidget {
  final String n, title, body;
  const StepTile(this.n, this.title, this.body, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: red, foregroundColor: Colors.white, child: Text(n)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 4),
          Text(body),
        ])),
      ]),
    ),
  );
}

class EmergencyNumber extends StatelessWidget {
  final String number, label;
  const EmergencyNumber(this.number, this.label, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const CircleAvatar(backgroundColor: red, foregroundColor: Colors.white, child: Icon(Icons.phone)),
      title: Text(number, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 27, color: navy)),
      subtitle: Text(label),
      trailing: const Icon(Icons.call),
      onTap: () => callNumber(context, number),
    ),
  );
}

class InfoBox extends StatelessWidget {
  final String text;
  const InfoBox(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline, color: navy),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ]),
    ),
  );
}

class AlertBox extends StatelessWidget {
  final String text;
  const AlertBox(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: red.withValues(alpha: .08), borderRadius: BorderRadius.circular(12), border: Border.all(color: red)),
    child: Row(children: [const Icon(Icons.warning_amber, color: red), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)))]),
  );
}

class PrototypeNotice extends StatelessWidget {
  const PrototypeNotice({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 22),
    child: Text(
      'PROTOTYP • Medizinische Inhalte vor Veröffentlichung fachlich prüfen.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
    ),
  );
}

class BigButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const BigButton(this.text, this.icon, this.onPressed, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 18)),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}


class GuidedEmergencyPage extends StatefulWidget {
  const GuidedEmergencyPage({super.key});
  @override
  State<GuidedEmergencyPage> createState() => _GuidedEmergencyPageState();
}

class _GuidedEmergencyPageState extends State<GuidedEmergencyPage> {
  int stage = 0;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (stage == 0) {
      content = DecisionCard(
        title: 'Ist die Umgebung sicher?',
        text: 'Achte auf Gefahren für dich, die betroffene Person und andere.',
        yes: 'JA – WEITER',
        no: 'NEIN – GEFAHR',
        onYes: () => setState(() => stage = 1),
        onNo: () => setState(() => stage = 4),
      );
    } else if (stage == 1) {
      content = DecisionCard(
        title: 'Reagiert die Person?',
        text: 'Sprich die Person an und prüfe, ob sie reagiert.',
        yes: 'JA',
        no: 'NEIN',
        onYes: () => setState(() => stage = 5),
        onNo: () => setState(() => stage = 2),
      );
    } else if (stage == 2) {
      content = DecisionCard(
        title: 'Normale Atmung vorhanden?',
        text: 'Beurteile die Atmung. Bei Unsicherheit professionelle Hilfe alarmieren.',
        yes: 'JA',
        no: 'NEIN / UNSICHER',
        onYes: () => setState(() => stage = 6),
        onNo: () => setState(() => stage = 3),
      );
    } else if (stage == 3) {
      content = ResultCard(
        icon: Icons.favorite,
        title: 'Reanimation / AED',
        text: 'Öffne den Reanimationsbereich und organisiere professionelle Hilfe.',
        button: 'REANIMATION & AED',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CprPage())),
      );
    } else if (stage == 4) {
      content = ResultCard(
        icon: Icons.warning_amber,
        title: 'Eigenschutz zuerst',
        text: 'Begib dich nicht selbst in Gefahr. Alarmiere bei Bedarf professionelle Hilfe.',
        button: 'NOTRUF',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbersPage())),
      );
    } else if (stage == 5) {
      content = ResultCard(
        icon: Icons.medical_services,
        title: 'Notfallbild auswählen',
        text: 'Wähle das passende Notfallthema oder alarmiere bei einem ernsten Zustand professionelle Hilfe.',
        button: 'NOTFALLTHEMEN',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TopicsPage())),
      );
    } else {
      content = ResultCard(
        icon: Icons.accessibility_new,
        title: 'Keine Reaktion, normale Atmung',
        text: 'Die finale, fachlich geprüfte Anleitung wird in diesem Pfad ergänzt.',
        button: 'NOTRUF',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbersPage())),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geführter Notfall'),
        actions: [
          IconButton(icon: const Icon(Icons.restart_alt), onPressed: () => setState(() => stage = 0)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const AlertBox('Prototyp – medizinische Freigabe vor realem Einsatz erforderlich.'),
          content,
          const SizedBox(height: 14),
          if (stage != 0)
            TextButton.icon(
              onPressed: () => setState(() => stage = 0),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Notfallablauf neu starten'),
            ),
        ],
      ),
    );
  }
}

class DecisionCard extends StatelessWidget {
  final String title, text, yes, no;
  final VoidCallback onYes, onNo;
  const DecisionCard({
    super.key, required this.title, required this.text, required this.yes,
    required this.no, required this.onYes, required this.onNo
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Icon(Icons.help_outline, size: 58, color: navy),
        const SizedBox(height: 16),
        Text(title, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: navy)),
        const SizedBox(height: 10),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 24),
        FilledButton(onPressed: onYes, child: Text(yes)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onNo, child: Text(no)),
      ]),
    ),
  );
}

class ResultCard extends StatelessWidget {
  final IconData icon;
  final String title, text, button;
  final VoidCallback onTap;
  const ResultCard({super.key, required this.icon, required this.title,
    required this.text, required this.button, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(icon, size: 64, color: red),
        const SizedBox(height: 14),
        Text(title, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
        const SizedBox(height: 10),
        Text(text, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        BigButton(button, Icons.arrow_forward, onTap),
      ]),
    ),
  );
}

class CprMetronomePage extends StatefulWidget {
  const CprMetronomePage({super.key});
  @override
  State<CprMetronomePage> createState() => _CprMetronomePageState();
}

class _CprMetronomePageState extends State<CprMetronomePage> {
  Timer? timer;
  int beats = 0;
  bool running = false;

  void toggle() {
    if (running) {
      timer?.cancel();
      setState(() => running = false);
    } else {
      setState(() { running = true; beats = 0; });
      // 110 BPM, within the commonly taught 100–120/min range.
      timer = Timer.periodic(const Duration(milliseconds: 545), (_) {
        if (mounted) setState(() => beats++);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CPR-Taktgeber')),
    body: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const AlertBox('Hilfsmittel-Prototyp. Die vollständige CPR-Anleitung wird vor Veröffentlichung fachlich freigegeben.'),
        const Spacer(),
        Icon(Icons.favorite, size: 90, color: running ? red : Colors.grey),
        const SizedBox(height: 20),
        Text('$beats', textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: navy)),
        const Text('Taktsignale • 110/min', textAlign: TextAlign.center),
        const Spacer(),
        BigButton(running ? 'STOPP' : 'START', running ? Icons.stop : Icons.play_arrow, toggle),
      ]),
    ),
  );
}

class AboutAcademyPage extends StatelessWidget {
  const AboutAcademyPage({super.key});
  @override
  Widget build(BuildContext context) => const AppScaffold(
    title: 'Über die Academy',
    children: [
      InfoBox('Swiss Emergency Academy by Courvoisier'),
      ListTile(leading: Icon(Icons.shield_outlined), title: Text('Ziel'),
        subtitle: Text('Erste-Hilfe-Wissen klar, schnell und mobil zugänglich machen.')),
      ListTile(leading: Icon(Icons.offline_bolt_outlined), title: Text('Offline zuerst'),
        subtitle: Text('Wesentliche Inhalte werden lokal in der App bereitgestellt.')),
      PrototypeNotice(),
    ],
  );
}

class CheckItem extends StatefulWidget {
  final String text;
  const CheckItem(this.text, {super.key});
  @override
  State<CheckItem> createState() => _CheckItemState();
}

class _CheckItemState extends State<CheckItem> {
  bool value = false;
  bool ready = false;
  String? error;
  String get storageKey => 'checklist_v1_${widget.text}';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        value = prefs.getBool(storageKey) ?? false;
        ready = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'Checkliste konnte nicht geladen werden.');
    }
  }

  Future<void> save(bool next) async {
    setState(() { ready = false; error = null; });
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await prefs.setBool(storageKey, next);
      if (!saved) throw StateError('Speichern fehlgeschlagen');
      if (!mounted) return;
      setState(() { value = next; ready = true; });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        ready = true;
        error = 'Nicht gespeichert. Bitte erneut versuchen.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CheckboxListTile(
        value: value,
        onChanged: ready ? (v) => save(v ?? false) : null,
        title: Text(widget.text),
        subtitle: error == null ? null : Text(error!),
      ),
      if (!ready && error != null)
        TextButton(onPressed: () { setState(() => error = null); load(); }, child: const Text('Erneut laden')),
    ],
  );
}
