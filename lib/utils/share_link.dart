import 'package:share_plus/share_plus.dart';

shareLinks(String type, String url){
  return Share.share("Let's see our $type, click me $url !");
}