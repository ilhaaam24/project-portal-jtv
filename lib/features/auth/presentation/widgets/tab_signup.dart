import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/custom_form_field.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/divider_widget.dart';

class TabSignup extends StatefulWidget {
  const TabSignup({super.key});

  @override
  State<TabSignup> createState() => _TabSignupState();
}

class _TabSignupState extends State<TabSignup> {
  final formKey = GlobalKey<FormState>();
  bool _isAccepted = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 16),
            Text(
              'Daftar',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text('Daftarkan diri anda'),
            SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                spacing: 12,
                children: [
                  CustomFormField(
                    label: 'Nama Lengkap',
                    placeholder: 'contoh: Savira Narita',
                  ),
                  CustomFormField(
                    label: 'Nomor Telepon',
                    placeholder: 'contoh: 081234567890',
                  ),
                  CustomFormField(
                    label: 'Tanggal Lahir',
                    placeholder: '10/05/2005',
                  ),
                  CustomFormField(
                    label: 'Email',
                    placeholder: 'contoh: viranarita@gmail.com',
                  ),

                  CustomFormField(
                    label: 'Password',
                    placeholder: 'Masukan password anda',
                    isObsecure: true,
                  ),
                  CustomFormField(
                    label: 'Konfirmasi Password',
                    placeholder: 'Konfirmasi password anda',
                    isObsecure: true,
                  ),

                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.4, // ubah sesuai kebutuhan
                        child: Checkbox(
                          value: _isAccepted,
                          onChanged: (_) {
                            setState(() {
                              _isAccepted = !_isAccepted;
                            });
                          },
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {

                      //   },
                      //   child: Container(
                      //     height: 24,
                      //     width: 24,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(4),
                      //       color: Colors.transparent,
                      //       border: Border.all(color: PortalColors.grey500),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Text(
                          'Saya menyutujui Kebijakan Privasi serta Syarat dan Ketentuan oleh Tim PortalJTV.',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      child: Text('Daftar'),
                    ),
                  ),
                  SizedBox(height: 4),
                  divider(),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text('Tidak memiliki akun?'),
                      SizedBox(width: 8),
                      Text(
                        'Daftar sekarang',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: PortalColors.jtvJingga,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
