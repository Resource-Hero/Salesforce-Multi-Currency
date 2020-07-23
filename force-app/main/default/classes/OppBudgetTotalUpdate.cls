public class OppBudgetTotalUpdate {
    public static void updateTotals() {
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, Name, Opp_Project_Budget_Total__c, OP_Budget_Number_Org__c FROM Opportunity]);
        
        //Iterate through as set starting value to 0
        Map<Id, Decimal> totals_budget = new Map<Id, Decimal>();
        Map<Id, Decimal> totals_budget_number_converted = new Map<Id, Decimal>();
        for(Opportunity opp : opps.values()) {
            totals_budget.put(opp.Id, 0);
            totals_budget_number_converted.put(opp.Id, 0);
        }
        
        //Query our list of opp projects
        List<Opp_Project__c> oppprojects = [SELECT Id, Name, Budget__c, Budget_Number_Converted__c, Opportunity__c
                                            FROM Opp_Project__c
                                            WHERE Opportunity__c IN :opps.keySet()];
        
        //Iterate through the opp projects and calculate the totals
        for(Opp_Project__c op : oppprojects) {
            totals_budget.put(op.Opportunity__c, totals_budget.get(op.Opportunity__c) + op.Budget__c);
            totals_budget_number_converted.put(op.Opportunity__c, totals_budget_number_converted.get(op.Opportunity__c) + op.Budget_Number_Converted__c);
        }
        
        for(Opportunity opp : opps.values()) {
            opp.Opp_Project_Budget_Total__c = totals_budget.get(opp.Id);
            opp.OP_Budget_Number_Org__c = totals_budget_number_converted.get(opp.Id);
        }
        
        update opps.values();
    }
}