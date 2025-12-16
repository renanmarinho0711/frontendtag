import 'package:intl/intl.dart';

/// Utilitários para manipulação de datas
class DateUtils {
  DateUtils._();

  // Formatos padrão
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _timeFormat = DateFormat('HH:mm');
  static final _monthYearFormat = DateFormat('MMMM yyyy', 'pt_BR');
  static final _weekdayFormat = DateFormat('EEEE', 'pt_BR');
  static final _shortDateFormat = DateFormat('dd/MM');
  static final _isoFormat = DateFormat('yyyy-MM-dd');

  // ==================== Formatação ====================

  /// Formata data como dd/MM/yyyy
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Formata data e hora como dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Formata hora como HH:mm
  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return _timeFormat.format(date);
  }

  /// Formata como mês e ano
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '-';
    return _monthYearFormat.format(date);
  }

  /// Formata como dia da semana
  static String formatWeekday(DateTime? date) {
    if (date == null) return '-';
    return _weekdayFormat.format(date);
  }

  /// Formata como dd/MM
  static String formatShortDate(DateTime? date) {
    if (date == null) return '-';
    return _shortDateFormat.format(date);
  }

  /// Formata como ISO (yyyy-MM-dd)
  static String formatIso(DateTime? date) {
    if (date == null) return '';
    return _isoFormat.format(date);
  }

  /// Formata data relativa (hoje, ontem, há X dias)
  static String formatRelative(DateTime? date) {
    if (date == null) return '-';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) return 'Hoje';
    if (difference == 1) return 'Ontem';
    if (difference == -1) return 'Amanhã';
    if (difference > 1 && difference <= 7) return 'Há $difference dias';
    if (difference < -1 && difference >= -7) return 'Em ${-difference} dias';
    if (difference > 7 && difference <= 30) {
      final weeks = (difference / 7).floor();
      return weeks == 1 ? 'Há 1 semana' : 'Há $weeks semanas';
    }
    if (difference > 30 && difference <= 365) {
      final months = (difference / 30).floor();
      return months == 1 ? 'Há 1 mês' : 'Há $months meses';
    }

    return formatDate(date);
  }

  /// Formata duração entre duas datas
  static String formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }

  // ==================== Parsing ====================

  /// Parse de string para DateTime
  static DateTime? parse(String? value) {
    if (value == null || value.isEmpty) return null;

    // Tenta formato ISO
    final isoResult = DateTime.tryParse(value);
    if (isoResult != null) return isoResult;

    // Tenta formato brasileiro
    try {
      return _dateFormat.parse(value);
    } catch (_) {}

    // Tenta formato brasileiro com hora
    try {
      return _dateTimeFormat.parse(value);
    } catch (_) {}

    return null;
  }

  // ==================== Comparações ====================

  /// Verifica se é hoje
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica se é ontem
  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Verifica se é amanhã
  static bool isTomorrow(DateTime? date) {
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Verifica se é esta semana
  static bool isThisWeek(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Verifica se é este mês
  static bool isThisMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Verifica se é este ano
  static bool isThisYear(DateTime? date) {
    if (date == null) return false;
    return date.year == DateTime.now().year;
  }

  /// Verifica se está no passado
  static bool isPast(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  /// Verifica se está no futuro
  static bool isFuture(DateTime? date) {
    if (date == null) return false;
    return date.isAfter(DateTime.now());
  }

  /// Verifica se está dentro de um range
  static bool isInRange(DateTime? date, DateTime start, DateTime end) {
    if (date == null) return false;
    return date.isAfter(start) && date.isBefore(end) ||
        date.isAtSameMomentAs(start) ||
        date.isAtSameMomentAs(end);
  }

  // ==================== Manipulação ====================

  /// Retorna início do dia (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retorna fim do dia (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Retorna início da semana (segunda-feira)
  static DateTime startOfWeek(DateTime date) {
    return startOfDay(date.subtract(Duration(days: date.weekday - 1)));
  }

  /// Retorna fim da semana (domingo)
  static DateTime endOfWeek(DateTime date) {
    return endOfDay(date.add(Duration(days: 7 - date.weekday)));
  }

  /// Retorna início do mês
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retorna fim do mês
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Retorna início do ano
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Retorna fim do ano
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  /// Adiciona dias úteis
  static DateTime addBusinessDays(DateTime date, int days) {
    int remaining = days;
    DateTime result = date;

    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }

    return result;
  }

  /// Calcula diferença em dias úteis
  static int businessDaysBetween(DateTime start, DateTime end) {
    int count = 0;
    DateTime current = start;

    while (current.isBefore(end)) {
      current = current.add(const Duration(days: 1));
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        count++;
      }
    }

    return count;
  }

  // ==================== Ranges ====================

  /// Retorna range de hoje
  static (DateTime, DateTime) todayRange() {
    final now = DateTime.now();
    return (startOfDay(now), endOfDay(now));
  }

  /// Retorna range desta semana
  static (DateTime, DateTime) thisWeekRange() {
    final now = DateTime.now();
    return (startOfWeek(now), endOfWeek(now));
  }

  /// Retorna range deste mês
  static (DateTime, DateTime) thisMonthRange() {
    final now = DateTime.now();
    return (startOfMonth(now), endOfMonth(now));
  }

  /// Retorna range dos últimos N dias
  static (DateTime, DateTime) lastDaysRange(int days) {
    final now = DateTime.now();
    return (startOfDay(now.subtract(Duration(days: days))), endOfDay(now));
  }

  /// Retorna lista de dias entre duas datas
  static List<DateTime> daysBetween(DateTime start, DateTime end) {
    final days = <DateTime>[];
    DateTime current = startOfDay(start);

    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  // ==================== Labels ====================

  /// Retorna saudação baseada na hora
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  /// Retorna label do período
  static String periodLabel(DateTime start, DateTime end) {
    if (isSameDay(start, end)) {
      return formatDate(start);
    }
    return '${formatShortDate(start)} - ${formatShortDate(end)}';
  }

  /// Verifica se sÃ£o o mesmo dia
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Retorna idade a partir de data de nascimento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}



