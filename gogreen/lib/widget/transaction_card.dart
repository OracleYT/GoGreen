import 'package:flutter/material.dart';
import 'package:gogreen/app_theme.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final snap;
  const TransactionCard({Key key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            // backgroundImage: NetworkImage(
            //   snap.data()['profilePic'],
            // ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap.data()['name'] + " ",
                            style: const TextStyle(
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: ' gifted ',
                            style: TextStyle(
                              color: AppTheme.lightText,
                            )),
                        TextSpan(
                            text: ' ${snap.data()['coins']} leafs',
                            style: TextStyle(
                              color: AppTheme.darkText,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset('images/gogreenlogo.png'),
            height: 50,
          )
        ],
      ),
    );
  }
}
