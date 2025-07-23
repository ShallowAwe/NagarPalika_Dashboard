import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/data/dummyuser.dart';
import 'package:smart_nagarpalika_dashboard/model/userModel.dart';
import 'package:smart_nagarpalika_dashboard/utils/button.dart';
import 'package:smart_nagarpalika_dashboard/utils/searchBar.dart';
// import 'package:smart_nagarpalika_dashboard/widgets/userTable/user_table.dart';
import 'package:smart_nagarpalika_dashboard/widgets/userTable.dart';


class Usermanagementscreen extends StatelessWidget {
  const Usermanagementscreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = dummyUsers; // This should be replaced with actual user data

    return Scaffold(
      backgroundColor: Color(0xFFECF6FE),
    body: Column( 
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20,20,20,10),
          child: Row(mainAxisAlignment: 
          MainAxisAlignment.spaceBetween,
            children: [
             CustomButton(icon: Icons.add, label: 'add user', onPressed: (){}, color: const Color.fromARGB(255, 55, 156, 238)),
              const SizedBox(width: 10),
              const Searchbar(),
              const SizedBox(width: 10),
              CustomButton(icon: Icons.filter_alt_outlined, label: 'filter', onPressed: (){}, color: Colors.lightGreen)
              
            ],
          ),
        ),

        const SizedBox(height: 20),

        // user Table 
        Expanded(child: UserTable(users: users))
        // Expanded(child: UserTable(users: users,)), // Assuming you have a userTable widget to display the user data
      ],
    )

      

    );
  }
}