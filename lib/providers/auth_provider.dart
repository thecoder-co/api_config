import 'package:my_attorney/features/auth/presentation/email_verification.dart';
import 'package:my_attorney/features/auth/presentation/reset_password_screen.dart';
import 'package:my_attorney/features/home/presentation/home.dart';
import 'package:my_attorney/packages/packages.dart';

import 'auth_repo.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthRepo>((ref) {
  return AuthNotifier(ref, AuthRepo());
});

class AuthNotifier extends StateNotifier<AuthRepo> {
  final Ref ref;
  final AuthRepo repo;
  AuthNotifier(this.ref, this.repo) : super(AuthRepo());

  refreshAuth() {
    state.isLoggedIn = LocalData.token != null;
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
    LocalData.removeToken();
    refreshAuth();
    ref.refresh(authProvider);
  }

  Future<void> registerUser(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await repo.registerWithEmailAndPassword(
      email: state.email!,
      password: state.password!,
      username: state.username!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      pushTo(context, const EmailVerification());
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> verifyUser(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await repo.verifyAccount(
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
    final res = await repo.resendOtp(
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
    final res = await repo.loginWithEmailAndPassword(
      email: state.email!,
      password: state.password!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      LocalData.setToken(res.data!.data!.authToken!);
      pushToAndClearStack(context, const Home());
      // if (ViewedItem.item != null) {
      //   pushTo(
      //     context,
      //     ViewProductScreen(item: ViewedItem.item!),
      //   );
      // }
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
      if (res.statusCode == 401) {
        await resendCode(context);
        if (!mounted) return;
        pushTo(context, const EmailVerification());
      }
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await repo.forgotPassword(
      email: state.email!,
    );
    if (!mounted) return;
    pop(context);
    if (res.valid) {
      pushTo(context, const ResetPasswordScreen());
    } else {
      Dialogs.showErrorSnackbar(context, message: res.error!.message!);
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    final res = await repo.resetPassword(
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
