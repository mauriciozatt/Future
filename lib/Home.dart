import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///função busca o preço do bitcoin e converte para um MAP (Conceito FUTURE - Dados futuros)
  Future<Map> _GetPrecoBitcoin() async {
    String vUrl = "https://blockchain.info/ticker";

    ///Busca os dados..
    http.Response vResponse = await http.get(Uri.parse(vUrl));

    /// Converte o meu retono para um objeto MAP<Chave/Valor>
    return json.decode(vResponse.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text("Future")),
      ),
      body: FutureBuilder<Map>(
        /// O FUTURE define os dados que são carregados... Por isso a minha função deve ser do tipo FUTURE..
        future: _GetPrecoBitcoin(),

        /// Metódo Builder recebe 2 parâmetros (Context e o snapshot) esse que o responsável por armazenar os dados recuperados atráves do metódo _GetPrecobitcoin..
        //builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:

            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando....", style: TextStyle(fontSize: 32)),
              );

            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: Text("Erro ao buscar info",
                        style: TextStyle(fontSize: 32)));
              } else {
                return Center(
                    child: Text(
                  snapshot.data!["BRL"]["buy"].toString(),
                  style: TextStyle(fontSize: 32),
                ));
              }
          }
        },
      ),
    );
  }
}
