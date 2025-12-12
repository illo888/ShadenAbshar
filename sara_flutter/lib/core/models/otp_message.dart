class OtpMessage {
  final int id;
  final String sender;
  final String senderIcon;
  final String code;
  final String purpose;
  final String time;
  final String date;

  OtpMessage({
    required this.id,
    required this.sender,
    required this.senderIcon,
    required this.code,
    required this.purpose,
    required this.time,
    required this.date,
  });
}
