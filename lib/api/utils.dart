import 'package:mango/api/models.dart';
import 'package:path/path.dart' as p;

const String thumbnailBaseUrl = "https://wp.youtube-anime.com/aln.youtube-anime.com/";
const String thumbnailBaseOther = "https://wp.youtube-anime.com"; 

// Url explanation
// https://wp.youtube-anime.com/aln.youtube-anime.com/mcovers/m_tbs/v9GG2hqJDaTA2HmmF/111.png?w=250 // this is adjustable size
// https://aln.youtube-anime.com/mcovers/m_tbs/v9GG2hqJDaTA2HmmF/111.png // this is full size

// https://wp.youtube-anime.com/s4.anilmvist.co/file/anilistcdn/media/manga/cover/medium/8305.jpg?w=250
// https://s4.anilist.co/file/anilistcdn/media/manga/cover/medium/8305.jpg

// https://wp.youtube-anime.com/cdn.mangaupdates.com/image/i361197.jpg?w=250
// http://cdn.mangaupdates.com/image/i361197.jpg

String createThumbnailUrl(String thumbnail, {int width = 250}) {
  String thumbnailUrl; 
  if (thumbnail.startsWith("https://s4") || thumbnail.startsWith("http://cdn")) {
    String thumnailRelative = thumbnail.replaceFirst(RegExp(r"^https?://"), "");
    thumbnailUrl = p.join(thumbnailBaseOther, thumnailRelative);
    return "$thumbnailUrl?w=$width";
  }

  thumbnailUrl = p.join(thumbnailBaseUrl, thumbnail);
  return "$thumbnailUrl?w=$width";
}

String getTimeAgo(LastChapterDate lastChapterDate) {
  LastChapterDateMeta dateObject = lastChapterDate.sub;
  DateTime inputDate = DateTime(dateObject.year, dateObject.month, dateObject.date, dateObject.hour, dateObject.minute);
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputDate);

  if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 21) {
    return "${(difference.inDays / 7).floor()} weeks ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} months ago";
  } else {
    return "${(difference.inDays / 365).floor()} years ago";
  }
}

// void main() {
//   LastChapterDate lastChapterDate = LastChapterDate(
//     sub: LastChapterDateMeta(year: 2025, month: 2, date: 22, hour: 11, minute: 41)
//   );
//   print(getTimeAgo(lastChapterDate));
// }
