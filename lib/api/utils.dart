import 'package:karaage/api/constants.dart';
import 'package:karaage/api/models.dart';
import 'package:path/path.dart' as p;
import 'package:html_unescape/html_unescape.dart';

// Url explanation
// https://wp.youtube-anime.com/aln.youtube-anime.com/mcovers/m_tbs/v9GG2hqJDaTA2HmmF/111.png?w=250 // this is adjustable size
// https://aln.youtube-anime.com/mcovers/m_tbs/v9GG2hqJDaTA2HmmF/111.png // this is full size

// https://wp.youtube-anime.com/s4.anilmvist.co/file/anilistcdn/media/manga/cover/medium/8305.jpg?w=250
// https://s4.anilist.co/file/anilistcdn/media/manga/cover/medium/8305.jpg

// https://wp.youtube-anime.com/cdn.mangaupdates.com/image/i361197.jpg?w=250
// http://cdn.mangaupdates.com/image/i361197.jpg

String createThumbnailUrl(String thumbnail, {int width = 250}) {
  String thumbnailUrl;
  if (thumbnail.startsWith("https://s4") ||
      thumbnail.startsWith("http://cdn")) {
    String thumnailRelative = thumbnail.replaceFirst(RegExp(r"^https?://"), "");
    thumbnailUrl = p.join(thumbnailBaseOther, thumnailRelative);
    return "$thumbnailUrl?w=$width";
  }

  thumbnailUrl = p.join(thumbnailBaseUrl, thumbnail);
  return "$thumbnailUrl?w=$width";
}

String getTimeAgo(LastChapterDate lastChapterDate) {
  LastChapterDateMeta dateObject = lastChapterDate.sub;
  DateTime inputDate = DateTime(
    dateObject.year,
    dateObject.month + 1,
    dateObject.date,
    dateObject.hour,
    dateObject.minute,
  );
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputDate);

  if (difference.inMinutes < 60) {
    int minutes = difference.inMinutes;
    return "$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago";
  } else if (difference.inHours < 24) {
    int hours = difference.inHours;
    return "$hours ${hours == 1 ? 'hour' : 'hours'} ago";
  } else if (difference.inDays < 7) {
    int days = difference.inDays;
    return "$days ${days == 1 ? 'day' : 'days'} ago";
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return "$months ${months == 1 ? 'month' : 'months'} ago";
  } else {
    int years = (difference.inDays / 365).floor();
    return "$years ${years == 1 ? 'year' : 'years'} ago";
  }
}

String parseHtmlString(String? htmlString) {
  if (htmlString == null) {
    return "N/A";
  }

  // Decode HTML entities
  var unescape = HtmlUnescape();
  String decoded = unescape.convert(htmlString);

  // Remove <br> tags and newlines
  String cleaned = decoded.replaceAll(RegExp(r'<br\s*/?>|\n'), ' ');

  // Trim extra spaces and normalize multiple spaces to a single space
  return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
}

List<String> formatChapterDoubles(List<double> numbers) {
  return numbers.map((number) {
    return number % 1 == 0 ? number.toInt().toString() : number.toString();
  }).toList();
}
