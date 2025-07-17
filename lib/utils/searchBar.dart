import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container( height: 50, width: 300, decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(50),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3), 
        ),
      ]
      
      ),
      child: Row(
        children: [

          const SizedBox(width: 10),
           Center(child: Icon(Icons.search, color: Colors.grey, size: 20)),
          const SizedBox(width: 8),
          VerticalDivider(
            color: Colors.grey[300],
            thickness: 1,
            width: 1,
          ),
          const SizedBox(width: 20),
          Center(
            child: Text(
              'Search...',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}