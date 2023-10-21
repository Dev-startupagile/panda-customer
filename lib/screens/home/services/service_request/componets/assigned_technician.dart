import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../util/ui_constant.dart';

class AssignedTechnician extends StatelessWidget {
  const AssignedTechnician({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(2022,12,24,2,30);

    return  Card(
      elevation: 2,
      child: ListTile(
        title: const Text("Mobile Technician", style: KAppTitleTextStyle,),
        subtitle: Row(
          children: [
            const Icon(Icons.circle,color: kPrimaryColorSecondary,),
            Text("Technician Assigned",style: KLatoRegularTextStyle,)
          ],
        ),
        trailing: Column(
          children: [
            Text("Now", style: KLatoRegularTextStyle,),
            Text(DateFormat('MM/dd/yyyy').format(dateTime), style: KLatoRegularTextStyle,)
          ],
        ),
      ),
    );
  }
}
