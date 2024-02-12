import 'package:car_periodic_inspection_info/presentation/car_info_add_screen/car_info_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CarInfoAddScreen extends StatefulWidget {
  const CarInfoAddScreen({Key? key}) : super(key: key);

  @override
  State<CarInfoAddScreen> createState() => _CarInfoAddScreenState();
}

class _CarInfoAddScreenState extends State<CarInfoAddScreen> {
  final stream = supabase.from('CarPeriodicAdd').stream(primaryKey: ['id']);
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final viewModelNoti = context.read<CarInfoAddViewModel>();
      viewModelNoti.initializeUserInfoAndSubscribeToChanges();
    });

  }

  TextEditingController companyController = TextEditingController();
  TextEditingController carSelectController = TextEditingController();
  TextEditingController gasSelectController = TextEditingController();
  TextEditingController checkTypeController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  String? userUid;

  @override
  void dispose() {
    companyController.dispose();
    carSelectController.dispose();
    gasSelectController.dispose();
    checkTypeController.dispose();
    distanceController.dispose();
    dateController.dispose();
    carNumberController.dispose();
    super.dispose();
  }

//
  void validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {


      context.go('/mainScreen', extra: {
        'company': companyController.text,
        'car_select': carSelectController.text,
        'gas_select': gasSelectController.text,
        'check_type': checkTypeController.text,
        'car_number': carNumberController.text,
        'distance': distanceController.text,
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarInfoAddViewModel>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('차량 입력 정보 '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ],
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제조 회사를 입력 해 주세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      viewModel.setValue(companyString: value);
                    },
                    controller: companyController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '제조회사',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차량 선택하세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                     viewModel.setValue(carSelectString: value);
                    },
                    controller: carSelectController,
                    decoration: InputDecoration(
                      hintText: '차량선택',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차량 선택하세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      viewModel.setValue(gasSelectString: value);
                    },
                    controller: gasSelectController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '연료유형',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '점검유형을 입력해주세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      viewModel.setValue(checkTypeString: value);
                    },
                    controller: checkTypeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '점검유형',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차량 선택하세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      int changInt = int.tryParse(value) ?? 0;
                      viewModel.setValue(dinstanceInt: changInt);
                    },
                    controller: distanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '주행한 키로수',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차량 번호 입력해주세요';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      viewModel.setValue(carNumberString: value);
                    },
                    controller: carNumberController,
                    decoration: InputDecoration(
                      hintText: '차량 번호 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await viewModel.validateAndSubmit().then((value) {

                                if (value) {
                                  context.goNamed('/mainScreen', queryParameters: {
                                    'car_select': carSelectController.text,
                                    'car_number': carNumberController.text,
                                  });

                                }
                              });
                            }
                          },
                          child: Text('작성 완료'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
