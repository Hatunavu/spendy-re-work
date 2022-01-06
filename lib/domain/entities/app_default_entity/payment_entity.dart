class PaymentEntity {
  final int? type;
  final String? name;
  final int? amount;
  final String? currency;
  final String? description;
  final String? hint;
  final bool? subscription;

  PaymentEntity(
      {this.type,
      this.name,
      this.amount,
      this.currency,
      this.description,
      this.hint,
      this.subscription});
}
