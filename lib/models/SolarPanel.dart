class SolarPanel{
  final String panelType;
  final String panelModel;
  final String panelModelCode;
  final String panelWattage;
  final String noOfPanels;


  SolarPanel({
    required this.panelType,
    required this.panelModel,
    required this.panelModelCode,
    required this.panelWattage,
    required this.noOfPanels,
});

  factory SolarPanel.fromJson(Map<String,dynamic> json){
    return SolarPanel(
        panelType: json['solar_panel_type'],
        panelModel: json['solar_panel_model'],
        panelModelCode: json['panel_model_code'],
        panelWattage: json['panel_wattage'],
        noOfPanels: json['no_of_panels']
    );
  }
}