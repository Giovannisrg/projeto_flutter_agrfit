import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const int _idLembreteDiario = 1;
  static const String _canalTreino   = 'agrfit_treino';

  // ── Inicializar ────────────────────────────────────────────────────────────
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, // usa o ícone padrão do app
      [
        NotificationChannel(
          channelKey:         _canalTreino,
          channelName:        'Lembrete de Treino',
          channelDescription: 'Lembrete diário para não esquecer o treino',
          importance:         NotificationImportance.High,
          defaultPrivacy:     NotificationPrivacy.Public,
        ),
      ],
    );

    // Solicita permissão
    final permitido = await AwesomeNotifications().isNotificationAllowed();
    if (!permitido) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ── Agendar lembrete diário ────────────────────────────────────────────────
  static Future<void> agendarLembreteDiario(int hora, int minuto) async {
    await cancelarLembreteDiario(); // cancela antes de reagendar

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id:          _idLembreteDiario,
        channelKey:  _canalTreino,
        title:       'AGR Fit 💪',
        body:        'Hora de treinar! Não perca seu treino de hoje.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour:        hora,
        minute:      minuto,
        second:      0,
        millisecond: 0,
        repeats:     true, // repete todo dia
        allowWhileIdle: true,
      ),
    );

    // Salva o horário nas prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hora',   hora);
    await prefs.setInt('notif_minuto', minuto);
  }

  // ── Cancelar lembrete diário ───────────────────────────────────────────────
  static Future<void> cancelarLembreteDiario() async {
    await AwesomeNotifications().cancel(_idLembreteDiario);
  }

  // ── Carregar horário salvo ─────────────────────────────────────────────────
  static Future<Map<String, int>?> horarioSalvo() async {
    final prefs  = await SharedPreferences.getInstance();
    final hora   = prefs.getInt('notif_hora');
    final minuto = prefs.getInt('notif_minuto');
    if (hora == null || minuto == null) return null;
    return {'hora': hora, 'minuto': minuto};
  }
}