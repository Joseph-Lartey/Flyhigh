
import 'package:email_otp/email_otp.dart';

class OTPService {
  static void configure() {
    // Basic configuration
    EmailOTP.config(
      appName: 'Flyhigh',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v1,
      appEmail: 'josephlartey414@gmail.com',
      otpLength: 6,
    );

    // Optional SMTP configuration if you have a custom SMTP server
    EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'josephlartey414@gmail.com',
      password: 'tlza csic mpxh cvll',
    );

    // Custom email template with your specified colors
    EmailOTP.setTemplate(
      template: '''
      <div style="background-color: #C63659; padding: 20px; font-family: Arial, sans-serif;">
        <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
          <h1 style="color: #C63659;">{{appName}}</h1>
          <p style="color: #C63659;">Your OTP is <strong>{{otp}}</strong></p>
          <p style="color: #C63659;">This OTP is valid for 5 minutes.</p>
          <p style="color: #C63659;">Thank you for using our service.</p>
        </div>
      </div>
      ''',
    );
  }

  static void sendOTP(String email) {
    EmailOTP.sendOTP(email: email);
  }

  static bool verifyOTP(String otp) {
    return EmailOTP.verifyOTP(otp: otp);
  }
}
