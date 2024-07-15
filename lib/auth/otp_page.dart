import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/providers/authentication_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? otpCode;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final verificationId = args[Constants.verificationId] as String;
    final phoneNumber = args[Constants.phoneNumber] as String;

    final authProvider = context.watch<AuthenticationProvider>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.prompt(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 120,
          ),
          Text(
            'Verification',
            style: GoogleFonts.prompt(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            'Enter the 6-digit code sent the number ',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            phoneNumber,
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 68,
            child: Pinput(
              length: 6,
              controller: controller,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (pin) {
                setState(() {
                  otpCode = pin;
                });
                verifyOTPCode(
                  verificationId: verificationId,
                  otpCode: otpCode!,
                );
              },
              focusedPinTheme: defaultPinTheme.copyWith(
                height: 68,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                height: 68,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          authProvider.isLoading
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),
          authProvider.isSuccessful
              ? Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : const SizedBox.shrink(),
          authProvider.isLoading
              ? const SizedBox.shrink()
              : Text(
                  'Didn\'t receive the code?',
                  style: GoogleFonts.prompt(
                    fontSize: 16,
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          authProvider.isLoading
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    "Resend Code",
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ]),
      ),
    );
  }

  Future<void> verifyOTPCode({
    required String verificationId,
    required String otpCode,
  }) async {
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.verifyOTPCode(
      verificationId: verificationId,
      otpCode: otpCode,
      context: context,
      onSuccess: () async {
        bool userExists = await authProvider.checkUserExists();

        if (userExists) {
          await authProvider.getUserDataFromFirestore();

          await authProvider.saveUserDatatoSharedPreferences();

          navigate(userExits: true);
        } else {
          navigate(userExits: false);
        }
      },
    );
  }

  void navigate({required bool userExits}) {
    if (userExits) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.homePage,
        (route) => false,
      );
    } else {
      Navigator.pushNamed(
        context,
        Constants.userInformationPage,
      );
    }
  }
}
