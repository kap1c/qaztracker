// ignore_for_file: deprecated_member_use

import 'package:url_launcher/url_launcher.dart';

void openExternalLink(String link) async {
  if (await canLaunch(link)) {
    await launch(link, forceSafariVC: false);
  } else {}
}
