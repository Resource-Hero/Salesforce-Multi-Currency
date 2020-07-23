trigger Opp_Project_Trigger_fixed on Opp_Project__c (before insert, before update) {
	//Create a set to hold opportunities ids related to the opp projects that execute this trigger
    Set<Id> oppids = new Set<Id>();
        
    //Iterate through each opp project and build our oppids set
    for(Opp_Project__c op : Trigger.new) {
        oppids.add(op.Opportunity__c);
    }
    
    //With our oppids set, get the related opportunity so that we can reference the opportunities iso code
    Map<Id, Opportunity> oppsmap = new Map<Id, Opportunity>([SELECT Id, Name, Amount, CurrencyIsoCode FROM Opportunity WHERE Id in :oppids]);
    
    //Get our orgs currency information
    List<CurrencyType> currencylist = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType WHERE IsActive = TRUE];
    
    //Get the currencies in a format that is easier to reference
    public static Map<String, CurrencyType> currencymap = new Map<String, CurrencyType>();
    for(CurrencyType onecurrency : currencylist) {
        currencymap.put(onecurrency.IsoCode, onecurrency);
    }
    
    //Finally, iterate through our opp projects and updated our field
    for(Opp_Project__c op : Trigger.new) {
        //Not really needed but will make our formula below a bit more readable
        Opportunity currentopp = oppsmap.get(op.Opportunity__c);
        
        //Add the two converted values together
        Decimal budget_converted = op.Budget__c / currencymap.get(op.CurrencyIsoCode).ConversionRate;
        Decimal amount_converted = currentopp.Amount / currencymap.get(currentopp.CurrencyIsoCode).ConversionRate; 
        
		//Set the field value after converting the value back into the currency from the opp project       
        op.B_A_From_apex_trigger_fixed__c = (budget_converted + amount_converted) * currencymap.get(op.CurrencyIsoCode).ConversionRate;
    }
}