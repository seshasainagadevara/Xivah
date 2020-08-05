class ConfigurationStructure {
  final String token;
  final String apiUrl;
  final String serverUrl;
  final int port;
  final String HOST;
  final int DBport;
  final String dataB;

  ConfigurationStructure(
      {this.HOST,
      this.DBport,
      this.dataB,
      this.token,
      this.apiUrl,
      this.serverUrl,
      this.port});
}
