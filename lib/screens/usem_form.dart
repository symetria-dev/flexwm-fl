import 'package:flexwm/models/usem.dart';
import 'package:flutter/material.dart';

class UserEmailForm extends StatefulWidget {
  final SoUserEmail soUserEmail;
  const UserEmailForm({Key? key, required this.soUserEmail}) : super(key: key);

  @override
  State<UserEmailForm> createState() => _UserEmailFormState();
}

class _UserEmailFormState extends State<UserEmailForm> {
  final textEmailontroller = TextEditingController();
  late String type;

  @override
  void initState() {
    if(widget.soUserEmail.id > 0) {
      textEmailontroller.text = widget.soUserEmail.email;
      type = widget.soUserEmail.type;
    }else{
      textEmailontroller.text = '';
      type = 'P';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        child: Column(
          children: [
            TextFormField(
              controller: textEmailontroller,
              decoration: const InputDecoration(
                labelText: 'Correo',
              ),
            ),
            Row(
              children: [
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: DropdownButton(
                      value: type,
                      items: SoUserEmail.getTypeOptions.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['label']),
                          value: e['value'],
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          type = '$value';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          if(widget.soUserEmail.id < 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  print('');
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
