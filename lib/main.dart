import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Cupajis',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final items = [
    "Humidité",
    "Phosphore",
    "Kolt",
    "Or",
    "Argent",
  ];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "Attribut", border: OutlineInputBorder()),
                value: value,
                isExpanded: true,
                items: items.map(buildMenuitem).toList(),
                onChanged: (value) => setState(() => this.value = value),
              ),
              const TextField(
                decoration: InputDecoration(
                    labelText: "Value", border: OutlineInputBorder()),
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: true, paste: false, selectAll: true),
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "X :", border: OutlineInputBorder()),
                    ),
                    width: 60,
                  ),
                  Container(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Y :", border: OutlineInputBorder()),
                    ),
                    // ),
                    width: 60,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {},
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Icon(
                        Icons.add_location_alt_outlined,
                        size: 24,
                      ),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    // margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  )
                ],
              )
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
        ));
  }

  DropdownMenuItem<String> buildMenuitem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
