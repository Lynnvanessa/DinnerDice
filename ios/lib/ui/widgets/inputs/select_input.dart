import 'package:flutter/material.dart';

class InputOption {
  final String label;
  final dynamic value;

  const InputOption(this.label, this.value);
}

class SelectInput extends StatelessWidget {
  const SelectInput({
    Key? key,
    required this.options,
    required this.onChanged,
    this.value,
  }) : super(key: key);
  final List<InputOption> options;
  final ValueChanged<InputOption?> onChanged;
  final InputOption? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<InputOption>(
      alignment: Alignment.center,
      value: value,
      items: options
          .map((option) => DropdownMenuItem<InputOption>(
                alignment: Alignment.center,
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                ),
                value: option,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
