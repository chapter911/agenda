import 'package:agenda_pemprov_kalteng/helper/database_helper.dart';
import 'package:agenda_pemprov_kalteng/helper/format_changer.dart';
import 'package:agenda_pemprov_kalteng/style/style.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:downloadsfolder/downloadsfolder.dart' as dw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _asal = TextEditingController();
  final TextEditingController _kegiatan = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _lokasi = TextEditingController();
  final TextEditingController _pakaian = TextEditingController();

  final TextEditingController _cKegiatan = TextEditingController();
  final TextEditingController _cTanggal = TextEditingController();

  final List<Widget> _listAgenda = [];
  final List<pw.TableRow> _agenda = [];

  @override
  void initState() {
    super.initState();
    _cTanggal.text = FormatChanger().tanggalAPI(DateTime.now());
    getAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Kegiatan ${_cTanggal.text}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.redAccent,
                    child: const Center(
                      child: Text(
                        "Cari Agenda",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  titlePadding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: TextField(
                                controller: _cKegiatan,
                                decoration:
                                    Style().dekorasiInput(hint: "Kegiatan"),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  setState(() => _cKegiatan.clear());
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: TextField(
                                controller: _cTanggal,
                                readOnly: true,
                                decoration: Style().dekorasiInput(
                                  hint: "Tanggal",
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2099),
                                  ).then((val) {
                                    if (val != null) {
                                      _cTanggal.text =
                                          FormatChanger().tanggalAPI(val);
                                      setState(() {});
                                    }
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  setState(() => _cTanggal.clear());
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _cKegiatan.clear();
                        _cTanggal.text =
                            FormatChanger().tanggalAPI(DateTime.now());
                        getAgenda();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (_cKegiatan.text.isEmpty && _cTanggal.text.isEmpty) {
                          Get.snackbar("Maaf", "Kegiatan Atau Tanggal Kosong");
                        } else {
                          getAgenda();
                        }
                      },
                      child: const Text("Cari"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_listAgenda.isEmpty) {
                Get.snackbar("Maaf", "Tidak ada data untuk di export");
              } else {
                try {
                  Directory downloadDirectory = await dw.getDownloadDirectory();

                  final file =
                      File("${downloadDirectory.path}/${_cTanggal.text}.pdf");
                  final pdf = pw.Document();

                  pdf.addPage(
                    pw.Page(
                      orientation: pw.PageOrientation.landscape,
                      build: (context) {
                        return pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                            2: pw.FlexColumnWidth(3),
                            3: pw.FlexColumnWidth(2),
                            4: pw.FlexColumnWidth(2),
                            5: pw.FlexColumnWidth(2),
                            6: pw.FlexColumnWidth(2),
                          },
                          defaultVerticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          children: _agenda,
                        );
                      },
                    ),
                  );

                  await file.writeAsBytes(await pdf.save());
                  await dw.openDownloadFolder();
                } catch (e) {
                  print('Failed to retrieve downloads folder path $e');
                }
              }
            },
            icon: const Icon(
              Icons.picture_as_pdf,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: _listAgenda,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _asal.clear();
            _kegiatan.clear();
            _tanggal.clear();
            _lokasi.clear();
            _pakaian.clear();
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.redAccent,
                child: const Center(
                  child: Text(
                    "Buat Agenda",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              titlePadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _asal,
                    decoration: Style().dekorasiInput(hint: "Asal"),
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _kegiatan,
                    decoration: Style().dekorasiInput(hint: "Kegiatan"),
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _tanggal,
                    readOnly: true,
                    decoration: Style().dekorasiInput(hint: "Tanggal"),
                    onTap: () {
                      showBoardDateTimePicker(
                        context: context,
                        pickerType: DateTimePickerType.datetime,
                        onChanged: (val) {
                          _tanggal.text = FormatChanger().tanggalJamAPIString(
                            val.toString(),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _lokasi,
                    decoration: Style().dekorasiInput(hint: "Lokasi"),
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _pakaian,
                    decoration: Style().dekorasiInput(hint: "Pakaian"),
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_asal.text.isEmpty ||
                        _kegiatan.text.isEmpty ||
                        _tanggal.text.isEmpty ||
                        _lokasi.text.isEmpty ||
                        _pakaian.text.isEmpty) {
                      Get.snackbar("Maaf", "Anda Belum Melengkapi Data Anda");
                    } else {
                      DataBaseHelper.insert("agenda", {
                        "asal": _asal.text,
                        "kegiatan": _kegiatan.text,
                        "tanggal": _tanggal.text,
                        "lokasi": _lokasi.text,
                        "pakaian": _pakaian.text,
                      });
                      Get.back();
                      getAgenda();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getAgenda() {
    _listAgenda.clear();
    var where = "";
    if (_cKegiatan.text.isNotEmpty) {
      where += "kegiatan = '${_cKegiatan.text}'";
    }
    if (_cTanggal.text.isNotEmpty) {
      if (where.isNotEmpty) {
        where += " AND ";
      }
      where += "tanggal LIKE '${_cTanggal.text}%'";
    }
    DataBaseHelper.customQuery(
            "SELECT * FROM agenda WHERE $where ORDER BY tanggal")
        .then((val) {
      if (val.isEmpty) {
        Get.snackbar("Maaf", "Tidak ada Agenda pada tanggal yang dipilih");
      } else {
        _agenda.add(pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "#",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Asal Undangan",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Kegiatan",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Tanggal Jam",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Tempat",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Lokasi",
                style: const pw.TextStyle(),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                "Disposisi",
                style: const pw.TextStyle(),
              ),
            ),
          ],
        ));
        for (var i = 0; i < val.length; i++) {
          _agenda.add(
            pw.TableRow(
              children: [
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${i + 1}.", textAlign: pw.TextAlign.end)),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${val[i]['kegiatan']}")),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${val[i]['asal']}")),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${val[i]['tanggal']}")),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${val[i]['lokasi']}")),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text("${val[i]['pakaian']}")),
                pw.Container(
                    padding: const pw.EdgeInsets.all(3), child: pw.Text("")),
              ],
            ),
          );
          _listAgenda.add(
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.redAccent,
                        child: const Center(
                          child: Text(
                            "Hapus Agenda?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      titlePadding: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      content: Container(
                        height: double.minPositive,
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            DataBaseHelper.deleteWhere(
                              "agenda",
                              "id=?",
                              val[i]['id'],
                            );
                            getAgenda();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Hapus",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: Colors.redAccent,
                        padding: const EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            "${val[i]['kegiatan']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(6),
                          },
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.grey,
                            ),
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                const Text("Asal"),
                                const Text(":"),
                                Text("${val[i]['asal']}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Tanggal"),
                                const Text(":"),
                                Text("${val[i]['tanggal']}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Lokasi"),
                                const Text(":"),
                                Text("${val[i]['lokasi']}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Pakaian"),
                                const Text(":"),
                                Text("${val[i]['pakaian']}"),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
      setState(() {});
    });
  }
}
