import 'package:flutter/material.dart';
import 'package:receiving_books/data/google_sheeet_api.dart';
import 'package:receiving_books/domain/model/user.dart';
import 'package:receiving_books/presentation/qr_scan/qr_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrScanScreen()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('주문 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: () async{
              final user = {
                UserFields.id:'1',
                UserFields.name:'namjinwoo',
                UserFields.email:'njw9108@naver.com',
              };
              await GoogleSheetApi.getByIsbn('9791157676637');
            }, child: Text('push')),
            Row(
              children: [
                Text('ISBN'),
                Text(''),
              ],
            ),
            Row(
              children: [
                Text('책 제목'),
                Text(''),
              ],
            ),
            Row(
              children: [
                Text('출판사명'),
                Text(''),
              ],
            ),
            Divider(
              height: 2,
              thickness: 1.5,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
