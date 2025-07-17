import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/userModel.dart';
import 'package:smart_nagarpalika_dashboard/widgets/userTable/user_table_pagination.dart';
import 'package:smart_nagarpalika_dashboard/widgets/userTable/user_tables_utils.dart';


DataRow buildUserRow(
  BuildContext context, {
  required UserModel user,
  required int index,
  Function(UserModel)? onEdit,
  Function(UserModel)? onDelete,
}) {
  return DataRow(
    color: WidgetStateProperty.all(index % 2 == 0 ? Colors.white : Colors.grey.shade50),
    cells: [
      DataCell(Text(user.id.toString())),
      DataCell(Text(user.name)),
      DataCell(Text(user.username)),
      DataCell(Text(user.mobile)),
      DataCell(Text(user.email)),
      DataCell(buildComplaintBadge(user.complaints)),
      DataCell(buildStatusBadge(user.isActive)),
      DataCell(Text(user.address ?? 'null')),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit' && onEdit != null) onEdit(user);
            if (value == 'delete' && onDelete != null) _confirmDelete(context, user, onDelete);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    ],
  );
}

void _confirmDelete(BuildContext context, UserModel user, Function(UserModel) onDelete) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete ${user.name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete(user);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
