import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/custom_form_field.dart';
import 'package:portal_jtv/features/auth/presentation/widgets/divider_widget.dart';
import 'package:portal_jtv/core/services/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portal_jtv/core/constants/api_constants.dart';

class TabSignin extends StatefulWidget {
  final bool fromGuard;

  const TabSignin({super.key, this.fromGuard = false});

  @override
  State<TabSignin> createState() => _TabSigninState();
}

class _TabSigninState extends State<TabSignin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _launchRegisterUrl() async {
    final Uri url = Uri.parse(ApiConstants.registerUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ToastService.showError(
          context,
          'Tidak dapat membuka halaman pendaftaran',
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Masuk',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text('Masuk dengan akun anda'),
        SizedBox(height: 16),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (widget.fromGuard) {
                context.pop();
              } else {
                context.pushNamed('home');
              }
            } else if (state is AuthError) {
              ToastService.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                spacing: 12,
                children: [
                  CustomFormField(
                    controller: _emailController,
                    label: 'Email',
                    placeholder: 'contoh: viranarita@gmail.com',
                  ),
                  CustomFormField(
                    controller: _passwordController,
                    label: 'Masukan password anda',
                    placeholder: 'Password',
                    isObsecure: true,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Lupa password?',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: PortalColors.jtvJingga),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                      child: state is AuthLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                  ),
                  SizedBox(height: 4),
                  divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tidak memiliki akun?'),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _launchRegisterUrl,
                        child: Text(
                          'Daftar sekarang',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: PortalColors.jtvJingga),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
