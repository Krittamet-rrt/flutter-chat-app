import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/authentication_provider.dart';
import 'package:flutter_chat_app/utils/assets_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "66",
    countryCode: "TH",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Thailand",
    example: "Thailand",
    displayName: "Thailand",
    displayNameNoCountryCode: "TH",
    e164Key: "",
  );
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                      AssetsManager.chatBubble,
                      color: Colors.blue,
                    )),
              ),
              Text(
                "Chat App",
                style: GoogleFonts.prompt(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Add your phone number will send you a code to verify",
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    phoneNumberController.text = value;
                  });
                },
                decoration: InputDecoration(
                    counterText: '',
                    hintText: "Phone Number",
                    hintStyle: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: 500,
                                  textStyle: GoogleFonts.prompt(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              });
                        },
                        child: Text(
                          "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneNumberController.text.length > 9
                        ? authProvider.isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () {
                                  authProvider.signInWithPhoneNumber(
                                    phoneNumber:
                                        '+${selectedCountry.phoneCode}${phoneNumberController.text}',
                                    context: context,
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
