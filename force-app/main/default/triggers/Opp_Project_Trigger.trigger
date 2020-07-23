trigger Opp_Project_Trigger on Opp_Project__c (before insert, before update) {
	//Create a set to hold opportunities ids related to the opp projects that execute this trigger
    Set<Id> oppids = new Set<Id>();
        
    //Iterate through each opp project and build our oppids set
    for(Opp_Project__c op : Trigger.new) {
        oppids.add(op.Opportunity__c);
    }
    
    //With our oppids set, get the related opportunity so that we can reference the opportunities iso code
    Map<Id, Opportunity> oppsmap = new Map<Id, Opportunity>([SELECT Id, Name, Amount, CurrencyIsoCode FROM Opportunity WHERE Id in :oppids]);
    
    //Finally, iterate through our opp projects and updated our field
    for(Opp_Project__c op : Trigger.new) {
        op.B_A_From_apex_trigger__c = op.Budget__c + oppsmap.get(op.Opportunity__c).Amount;
    }
}