import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

Future<String?> showRejectionDialog(BuildContext context) {
  final res = Responsive(context);
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: res.wp(5), // 5% of screen width
          vertical: 20,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: res.width * 0.9, // 90% of screen width
            minWidth: res.width * 0.5, // minimum 50% width
          ),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red[400], size: res.sp(28)),
                      SizedBox(width: res.wp(2)),
                      Text(
                        "Reject Pitch",
                        style: TextStyle(
                          fontSize: res.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(2)),
                  Text(
                    "Please provide a reason for rejection:",
                    style: TextStyle(
                      fontSize: res.sp(15),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: res.hp(1.5)),
                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: "Reason",
                      hintText: "Enter detailed reason...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    maxLines: 4,
                    minLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: res.hp(2)),
                  // Responsive button row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // For small screens, stack buttons vertically
                      if (constraints.maxWidth < 400) {
                        return Column(
                          children: [
                            _buildRejectButton(ctx, reasonController, res, formKey),
                            SizedBox(height: res.hp(1)),
                            _buildCancelButton(ctx, res),
                          ],
                        );
                      }
                      // For larger screens, keep buttons in a row
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildCancelButton(ctx, res),
                          SizedBox(width: res.wp(2)),
                          _buildRejectButton(ctx, reasonController, res, formKey),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildCancelButton(BuildContext ctx, Responsive res) {
  return SizedBox(
    width: res.width > 400 ? null : double.infinity, // Full width on small screens
    child: TextButton(
      onPressed: () => Navigator.pop(ctx),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[600],
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(4),
          vertical: res.hp(1.5),
        ),
      ),
      child: Text("CANCEL", style: TextStyle(fontSize: res.sp(14))),
    ),
  );
}

Widget _buildRejectButton(BuildContext ctx, TextEditingController controller, Responsive res, GlobalKey<FormState> formKey) {
  return SizedBox(
    width: res.width > 400 ? null : double.infinity, // Full width on small screens
    child: ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          Navigator.pop(ctx, controller.text.trim());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(4),
          vertical: res.hp(1.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        "SUBMIT REJECTION",
        style: TextStyle(fontSize: res.sp(14)),
      ),
    ),
  );
}