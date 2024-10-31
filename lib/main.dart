import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fredriex_uas/model/Karyawan.dart';
import 'model/Karyawan.dart' as prefix;
import 'dart:convert';
import 'dart:developer' as log;
import 'package:http/http.dart' as http;
import 'view/viewkaryawan.dart';
import 'view/addkaryawan.dart';
import 'view/editkaryawan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Karyawan> _karyawanList = <Karyawan>[];
  var response;
  var panjang = 0;
  String result = '';

  bacaKaryawan() async {
    try {
      var result = await http.get(
          Uri.parse("http://172.16.60.53/fredriex_uas/membaca_fredriex.php"));
      log.log(result.body.toString());

      setState(() {
        _karyawanList = <Karyawan>[];
        var hasil = jsonDecode(result.body)['data'];
        hasil.forEach((karyawan) {
          var x = Karyawan(
            karyawan['kode'] ?? '',
            karyawan['nama'] ?? '',
            karyawan['email'] ?? '',
            karyawan['hp1'] ?? '',
            karyawan['hp2'] ?? '',
            karyawan['alamat'] ?? '',
            int.tryParse(karyawan['umur'].toString()) ?? 0,
          );
          _karyawanList.add(x);
        });
      });
    } catch (e) {
      log.log('Error Fetching Data: $e');
    }
  }

  baca2() async {
    try {
      var result = await http.get(
          Uri.parse("http://172.16.60.53/fredriex_uas/membaca_fredriex.php"));
      log.log(result.body.toString());

      setState(() {
        _karyawanList = <Karyawan>[];
        var hasil = jsonDecode(result.body)['data'];
        hasil.forEach((karyawan) {
          if(karyawan['kode'] == 'K003'){
          var x = Karyawan(
            karyawan['kode'] ?? '',
            karyawan['nama'] ?? '',
            karyawan['email'] ?? '',
            karyawan['hp1'] ?? '',
            karyawan['hp2'] ?? '',
            karyawan['alamat'] ?? '',
            int.tryParse(karyawan['umur'].toString()) ?? 0,
          );
          _karyawanList.add(x);
        }});
      });
    } catch (e) {
      log.log('Error Fetching Data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    bacaKaryawan();
  }

  _deleteFormDialog(BuildContext context, String kode) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Kamu Yakin Menghapus',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    try {
                      var request = http.MultipartRequest(
                          'POST',
                          Uri.parse(
                              'http://172.16.60.53/fredriex_uas/hapus_fredriex.php'));
                      request.fields.addAll({'kode': kode, 'save': 'ok'});
                      http.StreamedResponse response = await request.send();
                      var responseData = await response.stream.bytesToString();
                      log.log(responseData);
                      if (response.statusCode == 201) {
                        setState(() {
                          result = responseData.toString();
                        });
                      } else {
                        throw Exception('Failed to delete data');
                      }
                    } catch (e) {
                      setState(() {
                        result = 'Error: $e';
                      });
                    }
                    if (result.isNotEmpty) {
                      bacaKaryawan();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karyawan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              baca2();
            },
            child: Text("Tombol Baru"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Warna tombol
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _karyawanList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => viewkaryawan(
                                karyawan: _karyawanList[index],
                              ))).then((data) {
                        if (data != null) {
                          bacaKaryawan();
                        }
                      });
                    },
                    leading: const Icon(Icons.person),
                    iconColor: Colors.purple,
                    title: Text(_karyawanList[index].kode ?? ''),
                    subtitle: Text(_karyawanList[index].nama ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => editkaryawan(
                                        karyawan: _karyawanList[index],
                                      ))).then((data) {
                                if (data != null) {
                                  bacaKaryawan();
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.teal,
                            )),
                        IconButton(
                            onPressed: () {
                              _deleteFormDialog(
                                  context, _karyawanList[index].kode!);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => addkaryawan()))
              .then((data) {
            if (data == true) {
              bacaKaryawan();
            }
          });
        },
        tooltip: 'Increment',
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
