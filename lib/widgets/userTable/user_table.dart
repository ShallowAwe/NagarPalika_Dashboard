import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/userModel.dart';
import 'user_table_header.dart';
import 'user_table_row.dart';
import 'user_table_pagination.dart';


class UserTable extends StatefulWidget {
  final List<UserModel> users;
  final Function(UserModel)? onEdit;
  final Function(UserModel)? onDelete;
  final int itemsPerPage;

  const UserTable({
    super.key,
    required this.users,
    this.onEdit,
    this.onDelete,
    this.itemsPerPage = 5,
  });

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int currentPage = 0;

  int get totalPages => (widget.users.length / widget.itemsPerPage).ceil();

  List<UserModel> get currentPageUsers {
    final start = currentPage * widget.itemsPerPage;
    final end = (start + widget.itemsPerPage).clamp(0, widget.users.length);
    return widget.users.sublist(start, end);
  }

  void _goToPage(int page) => setState(() => currentPage = page.clamp(0, totalPages - 1));
  void _previousPage() => _goToPage(currentPage - 1);
  void _nextPage() => _goToPage(currentPage + 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserTableHeader(total: widget.users.length, currentPage: currentPage, totalPages: totalPages),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: buildDataColumns(),
                rows: List.generate(currentPageUsers.length, (index) {
                  return buildUserRow(
                    context,
                    user: currentPageUsers[index],
                    index: index,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                  );
                }),
              ),
            ),
          ),
        ),
        if (totalPages > 1)
          UserTablePagination(
            currentPage: currentPage,
            totalPages: totalPages,
            itemCount: widget.users.length,
            itemsPerPage: widget.itemsPerPage,
            onPageChanged: _goToPage,
            onNext: _nextPage,
            onPrev: _previousPage,
          ),
      ],
    );
  }
  List<DataColumn> buildDataColumns() {
  return const [
    DataColumn(label: Text("ID")),
    DataColumn(label: Text("Name")),
    DataColumn(label: Text("Username")),
    DataColumn(label: Text("Mobile")),
    DataColumn(label: Text("Email")),
    DataColumn(label: Text("Complaints")),
    DataColumn(label: Text("Status")),
    DataColumn(label: Text("Address")),
    DataColumn(label: Text("Actions")),
  ];
}

}
