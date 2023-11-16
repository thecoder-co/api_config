import 'package:api_config_riverpod/app_routes.dart';
import 'package:api_config_riverpod/dialogs/dialog.dart';
import 'package:api_config_riverpod/local_data/local_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'auth_repo.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthRepo>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthRepo> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthRepo());

  refreshAuth() {
    state.isLoggedIn = LocalData.instance.token != null;
    state = state;
  }

  addChanges({required AuthRepo repo}) {
    if (!mounted) return;
    state = state.copyWith(
      email: repo.email,
      password: repo.password,
      username: repo.username,
      firstName: repo.firstName,
      lastName: repo.lastName,
      phoneNumber: repo.phoneNumber,
      otp: repo.otp,
      forgotPasswordEmail: repo.forgotPasswordEmail,
      forgotPasswordOtp: repo.forgotPasswordOtp,
      newPassword: repo.newPassword,
    );
  }

  logout() {
    LocalData.instance.token = null;
    refreshAuth();
  }

  Future<void> registerUser(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.registerWithEmailAndPassword(
      email: state.email!,
      password: state.password!,
      username: state.username!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      // pushTo(context, const EmailVerification());
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> verifyUser(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.verifyAccount(
      email: state.email!,
      otp: state.otp!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      loginUser(context);
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> resendCode(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.resendOtp(
      email: state.email!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      Dialogs.showSuccessSnackbar(context, message: res.message!);
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> loginUser(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.loginWithEmailAndPassword(
      email: state.email!,
      password: state.password!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      LocalData.instance.token = res.data!.data!.authToken!;
      // pushToAndClearStack(context, const Home());
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
      if (res.statusCode == 401) {
        await resendCode(context);
        if (!mounted) return;
        // pushTo(context, const EmailVerification());
      }
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.forgotPassword(
      email: state.email!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      // pushTo(context, const ResetPasswordScreen());
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await state.resetPassword(
      email: state.email!,
      otp: state.otp!,
      password: state.password!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      loginUser(context);
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }
}
