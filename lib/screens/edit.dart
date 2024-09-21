import 'package:flutter/material.dart';
import '/util/dbhelper.dart';
import '/model/shoppinglist.dart';
import 'listt.dart';

void main() {
  //runApp( Edit(item: ShoppingList('Title', 'Description', 'Measure', 2),));
  runApp( const Edit());
}

class Edit extends StatefulWidget {
  //final ShoppingList item;
  //const Edit({super.key, required this.item});
  const Edit({super.key});

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<Edit> {

  int id = 0;
  String title = "";
  String description = "";
  String measure = "";
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final items = ModalRoute.of(context)!.settings.arguments as ShoppingList;
    id = items.id!;
    title = items.title;
    description = items.description;
    measure = items.measure;
    quantity = items.quantity;

    return MaterialApp(
      title: 'Editar item',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editar item'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Item',
                  ),
                  onChanged: (text) {
                    setState(() {
                      title = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descrição',
                  ),
                  onChanged: (text) {
                    setState(() {
                      description = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Unidade de Medida',
                  ),
                  onChanged: (text) {
                    setState(() {
                      measure = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantidade',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    setState(() {
                      quantity = int.tryParse(text) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (title == "") {
                      showMessage('Item', "Para criar um novo registro, o campo ITEM deve ser preenchido!");
                    } else if (description == ""){
                      showMessage('Descrição', "Para criar um novo registro, o campo DESCRIÇÃO deve ser preenchido!");
                    } else if (measure == ""){
                      showMessage('Medida', "Para criar um novo registro, o campo MEDIDA deve ser preenchido!");
                    } else if (quantity == 0){
                      showMessage('Quantidade', "Para criar um novo registro, o campo QUANTIDADE deve ser um NÚMERO diferente de 0!");
                    } else {
                      DbHelper helper = DbHelper();
                      ShoppingList list = ShoppingList(title, description, measure, quantity);
                      Future id = helper.updateList(list);
                      id.then( (value) => debugPrint(value.toString()) );
                      title = "";
                      description = "";
                      measure = "";
                      quantity = 0;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ShoppingListApp()),
                      );
                    }
                  },
                  child: const Text('ATUALIZAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    DbHelper helper = DbHelper();
                    ShoppingList list = ShoppingList(title, description, measure, quantity);
                    Future id = helper.insertList(list);
                    id.then( (value) => debugPrint(value.toString()) );
                    title = "";
                    description = "";
                    measure = "";
                    quantity = 0;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ShoppingListApp()),
                    );
                  },
                  child: const Text('DELETAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String titleText, String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(titleText),
          content: Text(text),
        )
    );
  }
}
