import 'package:flutter/material.dart';
import 'package:fredriex_uas/model/Karyawan.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class editkaryawan extends StatefulWidget {
  late final Karyawan karyawan;

  editkaryawan({required this.karyawan});

  @override
  State<editkaryawan> createState() => _EditKaryawanState();
}

class _EditKaryawanState extends State<editkaryawan> {
  late TextEditingController _kodeController;
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _hp1Controller;
  late TextEditingController _hp2Controller;
  late TextEditingController _alamatController;
  late TextEditingController _umurController;

  bool _validateKode = false;
  bool _validateNama = false;
  bool _validateEmail = false;
  bool _validateHp1 = false;
  bool _validateHp2 = false;
  bool _validateAlamat = false;
  bool _validateUmur = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    _kodeController = TextEditingController(text: widget.karyawan.kode);
    _namaController = TextEditingController(text: widget.karyawan.nama);
    _emailController = TextEditingController(text: widget.karyawan.email);
    _hp1Controller = TextEditingController(text: widget.karyawan.hp1);
    _hp2Controller = TextEditingController(text: widget.karyawan.hp2);
    _alamatController = TextEditingController(text: widget.karyawan.alamat);
    _umurController =
        TextEditingController(text: widget.karyawan.umur.toString());
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _hp1Controller.dispose();
    _hp2Controller.dispose();
    _alamatController.dispose();
    _umurController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('http://172.16.60.53/fredriex_uas/ubah_fredriex.php'));
      request.fields.addAll({
        'id': widget.karyawan.kode.toString(),
        'kode': _kodeController.text,
        'nama': _namaController.text,
        'email': _emailController.text,
        'hp1': _hp1Controller.text,
        'hp2': _hp2Controller.text,
        'alamat': _alamatController.text,
        'umur': _umurController.text,
        'update': 'ok'
      });

      log(request.fields.toString()); // Log the request fields to check them

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      log('Response status: ${response.statusCode}');
      log('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(responseBody);
        setState(() {
          result = 'Update successful';
        });
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to update data');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Edit Karyawan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Karyawan',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Nama',
                    labelText: 'Nama',
                    errorText:
                        _validateNama ? 'Nama Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Satuan',
                    labelText: 'email',
                    errorText:
                        _validateEmail ? 'Email Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _hp1Controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter HP 1',
                    labelText: 'HP 1',
                    errorText:
                        _validateHp1 ? 'HP1 Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _hp2Controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter HP 2',
                    labelText: 'HP 2',
                    errorText:
                        _validateHp2 ? 'HP 2 Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Alamat',
                    labelText: 'alamat',
                    errorText:
                        _validateAlamat ? 'Alamat Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _umurController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Umur',
                    labelText: 'Umur',
                    errorText:
                        _validateUmur ? 'Umur Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _kodeController.text.isEmpty
                              ? _validateKode = true
                              : _validateKode = false;
                          _namaController.text.isEmpty
                              ? _validateNama = true
                              : _validateNama = false;
                          _emailController.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          _hp1Controller.text.isEmpty
                              ? _validateHp1 = true
                              : _validateHp1 = false;
                          _hp2Controller.text.isEmpty
                              ? _validateHp2 = true
                              : _validateHp2 = false;
                          _alamatController.text.isEmpty
                              ? _validateAlamat = true
                              : _validateAlamat = false;
                          _umurController.text.isEmpty
                              ? _validateUmur = true
                              : _validateUmur = false;
                        });
                        if (!_validateKode &&
                            !_validateNama &&
                            !_validateEmail &&
                            !_validateHp1 &&
                            !_validateHp2 &&
                            !_validateAlamat &&
                            !_validateUmur) {
                          await _updateData();
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _kodeController.text = '';
                        _namaController.text = '';
                        _emailController.text = '';
                        _hp1Controller.text = '';
                        _hp2Controller.text = '';
                        _alamatController.text = '';
                        _umurController.text = '';
                      },
                      child: const Text('Cancel'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
