import 'package:flutter/material.dart';
import 'package:ordy/class/Order.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintScreen extends StatefulWidget {
  final Order order;
  const PrintScreen({Key? key, required this.order}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.order.tableName}")),
      body: PdfPreview(
        build: (format) => _generatePdf(format, "${widget.order.tableName}"),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: pw.TextStyle(
                  font: font, fontSize: 30)),
              for (var order in widget.order.allPlates)
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      if (order.quantity > 0)
                        pw.Text(order.name + " x${order.quantity}",
                            style: pw.TextStyle(font: font, fontSize: 20)),
                      if (order.quantity > 0)
                        pw.Text("${order.bill} EUR",
                            style: pw.TextStyle(font: font, fontSize: 20)),
                    ]
                ),
              pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text("\nTotale: ${widget.order.bill} EUR",
                      style: pw.TextStyle(font: font, fontSize: 30))
              )
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}



/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  var _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  void initPrinter() {
    print('init printer');

    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((event) {

      if (!mounted) return;
      setState(() => _devices = event);

      if (_devices.isEmpty)
        setState(() {
          _devicesMsg = 'No devices';
        });
    });
  }

  @override
  void initState() {
      bluetoothManager.state.listen((val) {
        print("state = $val");
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() {
            _devicesMsg = 'Please enable bluetooth to print';
          });
        }
        print('state is $val');
      });
    super.initState();
  }
  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final myTicket = await _ticket(PaperSize.mm58);
    final result = await _printerManager.printTicket(myTicket);
    print(result);
  }
  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    ticket.text("Hello, world");
    ticket.cut();
    return ticket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Printer page"),
        ),
        body: ListView.builder(
          itemBuilder: (context, position) =>
              ListTile(
                onTap: () {
                  _startPrint(_devices[position]);
                },
                leading: Icon(Icons.print),
                title: Text(_devices[position].name),
                subtitle: Text(_devices[position].address),
              ),
          itemCount: _devices.length,
        ));
  }
}
*/