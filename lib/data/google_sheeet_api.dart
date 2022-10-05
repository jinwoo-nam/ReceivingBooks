import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:receiving_books/domain/model/receiving_status_data/receiving_status_data.dart';
import 'package:receiving_books/domain/model/user.dart';

class GoogleSheetApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "receiving-books",
  "private_key_id": "c9b288e13482af0bf7f985118da10c82314ff34b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDxBa7m3y2O8AoH\nYKh/ucMPlMKeALDy3GwkT1jz6U2n52TBoV9xRzdUvCODVKrProJyFr0buTaOvxzs\nyTb6kF11F3nTE7OedWDyjfYuirJJlksMsVESIklYBBzCB7Fem1rjNorui3k1d3vW\nYD6ufeQF/6M8UICwV3dIFyqeZBYlJhUbSO6TbR2gTdUko8ICId+jDa/k07UCx3+6\nYCUbeFL6XcEuOnyETecJt+7riWOJEOyju6n/2xq7Yb9Bc5n8vUyJY0QR33lNcvbp\nuCJWQgEvj+4g7ijTcr/B4iGZO8picMt8UqEw8DOeoLX0OD2Cc8uBcDxyOPUstdRH\nSgzMkJPBAgMBAAECggEACL3lBxinJV0NcBEQa3mIWqNRn7t0r4pRHcwG9OnMWD+r\nRt6cgJZNqnQccaH7hAbXUl4Cw+Om1+yUlv4BUXs0+I8+aup3BFNLjeCaQjvjlYmu\n9SnlP9wgfuG/TUZMJ5tI457R0S8b2VWZF0BsZZXJVHJeMEzXLg4uFF5KvG3y46v4\n6C8MgXZOxZZCZ/nRXQOQCLWLHWW/kHbbxGfVT2vmByA5C3n/5XZRS7vSu0ZmP/y2\nK1cRL0zuNBFs5enTg8z7xNkZAJ+00BEFMCYRxxtqvUvC/HaUcJmGf6U8DeeDgR9Y\nu0T2QxnQ2mIw5fb5HKT4yvg0B98cuwoQcgPOpVOHMQKBgQD9mG7KA0X9QJaN9n6H\nc7I2q85IKPnjVkQYk8RWyBVoDlx9FlJBvS05dMGJi01PDesMNPWpjCNPDsJNNd3c\nvQh4chd5ElvgvRdDrjMOvQe4wj601BCGZB7/BGIuOPjqSte2lbrdsXIjVROxhbKN\nxZkzrrTbpBn6ThuQToWBhJy0PQKBgQDzTrsNIy6IUIbsCrA7OIAh/W6YoqoBQPwA\nKY88Xc+Jjz/SEqAIAIIQVg23botlwIKWp0ozB+Yo1XsMBJ07Z4BRXOJDppYSuAJj\n8rAOaPUoJfd6+OhOoDnlBC3PEQqc0dNBNNCt2AMvLOXyNr+DMQ1Fp8KznhJsC21p\nHor2Ninh1QKBgA1MqjrD8y617W9ihv45jhYZ6oaUR46pnoafcUOP2LeNUUJqIkQ6\nVJ3XxrKc8J/9vd71BBExPUTPJFeCRLFn5ILUkPCTiuf9YrP09c6HEVmaLkmzeW5i\n39FF/JQp/rvi0u9LaPJpdO/vbUn5FgUjYMZ6GhgOwiIDaKSnyY6iUsmNAoGAOed5\n0sWVtHFdut1MVbu7mttCr+a+iO/bSXqakSZOVxGVgbxXA7CDQ7oHJ6mSWVP4gDwu\nB3kQyJUN5K1QcivOuQ5e9vS1cJ0ETJ8cUUGfXr+yZzzHpLazMJLPCCGpIes52KHm\nLAllsJuB2iQ3bdSFsRcc2jx7a+VIU6UmMzRuwUUCgYEA/PhZcGuzieDdGr5fQIhA\nM/ae4yl6G4VRkUekJfUNkKvRnDD6eJVXMApOGGD/VMO9YcCnPxFCs7rDTDISg7Pm\nuutUZlu/kukdGIUAunIwjkJhZwYmgUHDCPXtcfvbtDSaTndmRLsmUHIMbNDruWAT\ngP7KY/NPXi3FujZcZRyyx6E=\n-----END PRIVATE KEY-----\n",
  "client_email": "receiving-books@receiving-books.iam.gserviceaccount.com",
  "client_id": "107187732338465937906",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/receiving-books%40receiving-books.iam.gserviceaccount.com"
}
''';
  static final _spreadsheetId = '1mzZB6bIsbjn9m0e_TKhaQTaxnifMBnE6eknId8xTAXI';
  static final _gsheet = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');

      final firstRow = UserFields.getFields();
      //_userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('init error $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<void> insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;

    await _userSheet!.values.map.appendRows(rowList);
  }

  static Future<List<ReceivingStatusData>> getBookData() async {
    if (_userSheet == null) return <ReceivingStatusData>[];
    final book = await _userSheet!.values.map.allRows();
    final List<ReceivingStatusData> data = book == null
        ? <ReceivingStatusData>[]
        : book.map(ReceivingStatusData.fromJson).toList();
    return data;
  }

  static Future<List<ReceivingStatusData>?> getByIsbn(String isbn) async {
    if (_userSheet == null) return null;

    print(isbn);
    final json = await _userSheet!.values.map.rowByKey('박은수', fromColumn: 13);
    print(json);
    //json == null ? print('null') : print(ReceivingStatusData.fromJson(json));

    final json1 = await _userSheet!.values.map.columnByKey('박은수',fromRow: 1);
    print(json1);
    //json1 == null ? print('null') : print(ReceivingStatusData.fromJson(json1));

    final json2 = await _userSheet!.values.map.rowByKey(isbn, fromColumn: 14);
    print(json2);
    //json2 == null ? print('null') : print(ReceivingStatusData.fromJson(json2));

    return null;
  }
}
