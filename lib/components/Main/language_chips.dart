import 'package:flutter/material.dart';
import 'package:heretaunga/components/keys.dart';

class LanguageChips extends StatefulWidget {
  final ValueChanged onChanged;

  LanguageChips({Key key, @required this.onChanged}) : super(key: key);

  @override
  _LanguageChipsState createState() => _LanguageChipsState();
}

class _LanguageChipsState extends State<LanguageChips> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: getLanguages(),
    );
  }

  List<Widget> getLanguages() {
    List<Widget> output = [];
    for (MapEntry<String, String> entry
        in Keys.accessGlobalData.currentState.availableLanguages.entries) {
      output.add(_LanguageChip(
        title: entry.key,
        selected: Keys.accessGlobalData.currentState.getActiveLanguage() ==
            entry.value,
        callback: (_) {
          widget.onChanged(entry.value);
        },
      ));
    }
    return output;
  }
}

class _LanguageChip extends StatefulWidget {
  final String title;
  final bool selected;
  final Function callback;

  _LanguageChip({Key key, this.title, this.selected, this.callback})
      : super(key: key);

  @override
  _LanguageChipState createState() => _LanguageChipState();
}

class _LanguageChipState extends State<_LanguageChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        selectedColor: Theme.of(context)
            .bottomNavigationBarTheme
            .selectedItemColor
            .withOpacity(0.2),
        label: Text(
          widget.title,
          style: TextStyle(
            color: widget.selected
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                : Theme.of(context).textTheme.bodyText1.color,
            fontSize: 16,
          ),
        ),
        selected: widget.selected,
        onSelected: widget.callback,
      ),
    );
  }
}
