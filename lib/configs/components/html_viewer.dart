// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

class HtmlViewer extends StatelessWidget {
  final String htmlContent;
  Color? bodyColor;

  HtmlViewer({super.key, required this.htmlContent, this.bodyColor});

  @override
  Widget build(BuildContext context) {
    String htmlContent1 = """
<body>

${htmlContent.toString()}
</body>
""";

    // or use HTML.toRichText()
    final TextSpan textSpan = HTML.toTextSpan(
      context,
      htmlContent1,
      linksCallback: (dynamic link) {
        debugPrint('You clicked on $link');
      },
      // as name suggests, optionally set the default text style
      defaultTextStyle: TextStyle(color: Colors.grey[700]),
      overrideStyle: <String, TextStyle>{
        'p': TextStyle(fontSize: 12, color: bodyColor ?? Colors.grey[700]),
        // 'a': const TextStyle(wordSpacing: 2),
      },
    );
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(child: RichText(text: textSpan)),
    );
  }
}
