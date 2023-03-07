
import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

   @override
   void dispose() {
    super.dispose();
    cepEC.dispose();
   }

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(
            title: const Text('Buscar CEP'),
            ),
           body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cepEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP obrigatório';
                      }
                      return null;
                    },

                  ),
                  ElevatedButton(onPressed:() async {
                    final valid = formKey.currentState?.validate() ?? false;
                    if(valid){
                      try {
                        final endereco = await cepRepository.getCep(cepEC.text);
                        setState(() {
                          enderecoModel = endereco;
                        }); 
                      } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content:Text('Erro ao buscar endereço'), 
                         ));
                      }
                    }
                  }, child: const Text('Buscar'),
                  ),
                  Text(
                    '${enderecoModel?.localidade} ${enderecoModel?.complemento} ${enderecoModel?.logradouro} ${enderecoModel?.cep}'),
                ],
              ),
            )
           ),
       );
  }
}