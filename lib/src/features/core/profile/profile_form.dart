import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../constants/text_strings.dart';
import '../../authentication/controllers/profile_controller.dart';
import '../../authentication/models/user_model.dart';

class ProfileFormScreen extends StatelessWidget {
  ProfileFormScreen({
    Key? key,
    required this.user,
    required this.email,
    required this.phoneNo,
    required this.fullName,
    required this.password,
    // required this.cpf,
  }) : super(key: key);

  final UserModel user;
  final TextEditingController email;
  final TextEditingController phoneNo;
  final TextEditingController fullName;
  final TextEditingController password;
  // final TextEditingController cpf;

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: fullName,
            decoration: const InputDecoration(
              label: Text(tFullName),
              prefixIcon: Icon(LineAwesomeIcons.user),
            ),
          ),
          const Gap(10),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              label: Text(tEmail),
              prefixIcon: Icon(LineAwesomeIcons.envelope_1),
            ),
          ),
          const Gap(10),
          TextFormField(
            controller: phoneNo,
            inputFormatters: [phoneFormatter],
            decoration: const InputDecoration(
              label: Text(tPhoneNo),
              prefixIcon: Icon(LineAwesomeIcons.phone),
            ),
          ),
          // const Gap(10),
          // TextFormField(
          //   controller: cpf,
          //   inputFormatters: [cpfFormatter],
          //   decoration: const InputDecoration(
          //     label: Text('CPF'),
          //     prefixIcon: Icon(LineAwesomeIcons.phone),
          //   ),
          // ),
          const Gap(30),

          /// -- Form Submit Button
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final userData = UserModel(
                  id: user.id,
                  email: email.text.trim(),
                  fullName: fullName.text.trim(),
                  phoneNo: phoneNo.text.trim(),
                );

                await controller.updateRecord(userData);
              },
              child: Text(
                editProfile,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                    ),
              ),
            ),
          ),
          const Gap(30),

          /// -- Created Date and Delete Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    elevation: 0,
                    foregroundColor: Colors.red,
                    side: BorderSide.none,
                  ),
                  child: Text(
                    deleteAccount,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
