/// Build-time environment, selected with `--dart-define FLAVOR=<name>`.
enum Flavor {
  dev,
  preprod,
  prod;

  static Flavor fromName(String name) => Flavor.values.firstWhere(
    (flavor) => flavor.name == name.toLowerCase(),
    orElse: () => Flavor.dev,
  );

  String get label => switch (this) {
    Flavor.dev => 'DEV',
    Flavor.preprod => 'PREPROD',
    Flavor.prod => 'PROD',
  };
}
