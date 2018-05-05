/* Author: 			Trellis Sherman
 * Email:  			trellis.sherman@csra.com
 * 
 * Test Class:		timeEntryTriggerHelper_Test
 * 
 * Description: 	An Apex Class that is used in the timeEntryTrigger to help calculate the numeric representation of time
 * 
 */
public without sharing class lineEntryTctoTriggerHelper {
    
    public static List<Double> timeToNumber(Line_Item__c lineEntry)
    {
        //vars
        //e = end
        //s = start
        //h = hour
        //m = minute
        //t1 = the numeric representation of time
        //t2 = the numeric representation of time
        String endTime;
        String startTime;
        String tctoRequestType;
        Integer eH;
        Integer sH;
        Integer eM;
        Integer SM;
        Double t1;
        Double t2;
        List<Double> numResult = new List<Double>();
        
        
        tctoRequestType = lineEntry.Hidden_TCTO_Request_Type__c;
        
        //Execute this block of code if the normal work time picklists are not null
        if(lineEntry.Normal_Workday_Start_Time__c != null && lineEntry.Normal_Workday_End_Time__c != null)
        {
            endTime = lineEntry.Normal_Workday_End_Time__c;
            startTime = lineEntry.Normal_Workday_Start_Time__c;
            eM = Integer.valueOf(endTime.substring(3, 5));
            sM = Integer.valueOf(startTime.substring(3, 5));
            
            System.debug('starttime: '+starttime);
            System.debug('endtime: '+endtime);
            
            if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'AM')
                sH = 0;
            else if(startTime.substring(0, 2) != '12' && startTime.substring(6) == 'AM')
                sH = Integer.valueOf(startTime.substring(0, 2)); 
            else if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'PM')
                sH = 12; 
            else
                sH = Integer.valueOf(startTime.substring(0, 2)) + 12; 
            
            if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'AM')
                eH = 0;
            else if(endTime.substring(0, 2) != '12' && endTime.substring(6) == 'AM')
                eH = Integer.valueOf(endTime.substring(0, 2)); 
            else if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'PM')
                eH = 12; 
            else
                eH = Integer.valueOf(endTime.substring(0, 2)) + 12; 
            
            t1 = sH + (sM/60.00);
            t2 = eH + (eM/60.00); 
            system.debug('sH: '+sh);
            system.debug('sM: '+sM);
            system.debug('t1: '+t1);
            system.debug('eH: '+eh);
            system.debug('eM: '+eM);
            system.debug('t2: '+t2);
            system.debug('asd: '+(eH + (eM/60)));
            numResult.add(t1);
            numResult.add(t2);
            
        }
        else
        {
            numResult.add(0);
            numResult.add(0);  
        }
        
        //Execute this block if the Proposed Time picklists are not null and the Form is "proposed"
        if(tctoRequestType.containsIgnoreCase('proposed') && lineEntry.Travel_Time_Start_Picklist__c != null &&
          lineEntry.Travel_Time_End_Picklist__c != null)
        {
            System.debug('Proposed and not null');
            endTime = lineEntry.Travel_Time_End_Picklist__c;
            startTime = lineEntry.Travel_Time_Start_Picklist__c;
            eM = Integer.valueOf(endTime.substring(3, 5));
            sM = Integer.valueOf(startTime.substring(3, 5));
            
            if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'AM')
                sH = 0;
            else if(startTime.substring(0, 2) != '12' && startTime.substring(6) == 'AM')
                sH = Integer.valueOf(startTime.substring(0, 2)); 
            else if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'PM')
                sH = 12; 
            else
                sH = Integer.valueOf(startTime.substring(0, 2)) + 12; 
            
            if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'AM')
                eH = 0;
            else if(endTime.substring(0, 2) != '12' && endTime.substring(6) == 'AM')
                eH = Integer.valueOf(endTime.substring(0, 2)); 
            else if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'PM')
                eH = 12; 
            else
                eH = Integer.valueOf(endTime.substring(0, 2)) + 12; 
            
            t1 = sH + (sM/60.00);
            t2 = eH + (eM/60.00);
            
            numResult.add(t1);
            numResult.add(t2);
            
            
        }
        //Execute this block if the Actual Time picklists are not null and the Form is "earned"
        else if(tctoRequestType.containsIgnoreCase('earned') && lineEntry.Travel_Time_End_Actual__c != null &&
               lineEntry.Travel_Time_Start_Actual__c != null)
        {
            System.debug('Earned and not null');
            endTime = lineEntry.Travel_Time_End_Actual__c;
            startTime = lineEntry.Travel_Time_Start_Actual__c;
            eM = Integer.valueOf(endTime.substring(3, 5));
            sM = Integer.valueOf(startTime.substring(3, 5));
            
            if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'AM')
                sH = 0;
            else if(startTime.substring(0, 2) != '12' && startTime.substring(6) == 'AM')
                sH = Integer.valueOf(startTime.substring(0, 2)); 
            else if(startTime.substring(0, 2) == '12' && startTime.substring(6) == 'PM')
                sH = 12; 
            else
                sH = Integer.valueOf(startTime.substring(0, 2)) + 12; 
            
            if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'AM')
                eH = 0;
            else if(endTime.substring(0, 2) != '12' && endTime.substring(6) == 'AM')
                eH = Integer.valueOf(endTime.substring(0, 2)); 
            else if(endTime.substring(0, 2) == '12' && endTime.substring(6) == 'PM')
                eH = 12; 
            else
                eH = Integer.valueOf(endTime.substring(0, 2)) + 12; 
            
            t1 = sH + (sM/60.00);
            t2 = eH + (eM/60.00);
            
            numResult.add(t1);
            numResult.add(t2);
        }else
        {
            System.debug('Set to null');
            numResult.add(0);
            numResult.add(0);
        }
    
    System.debug('numList: '+numResult);
    return numResult;
    }
    
    //3-26-18
    //Added condition to SOQL to only lock forms related to TCTO Request
    //Also modify roll summary loop, for simplicity
    public static void calculateTravelComp(List<ID> formIds)
    { 
        Double tmpVal;
        Map<Id,Double> proposedHoursMap = new Map<Id,Double>();
        Map<Id,Double> earnedHoursMap = new Map<Id,Double>();
        ID formTctoID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeId();
        
        List<Forms__c> updateForms = [select id, recordTypeID, Proposed_Travel_Comp_Hours_Total__c,Earned_Travel_Comp_Hours_Total__c, TCTO_Request_Type__c
                                      FROM Forms__c where id IN: formIds AND recordTypeID =: formTctoID FOR UPDATE];
        
        List<Line_Item__c> lineItems = [select Travel_Comp_Hours__c, Travel_Comp_Hours_Earned__c, Related_Form__c
                                        from Line_Item__c where Related_Form__c IN: formIds Order By Related_Form__c];
        for(Line_Item__c line: lineItems)
        {
            if(proposedHoursMap.containsKey(line.Related_Form__c))
            {
                tmpVal = proposedHoursMap.get(line.Related_Form__c);
                tmpVal = tmpVal + line.Travel_Comp_Hours__c;
                proposedHoursMap.remove(line.Related_Form__c);
                proposedHoursMap.put(line.Related_Form__c, tmpVal);
            }
            else
            {
                proposedHoursMap.put(line.Related_Form__c, line.Travel_Comp_Hours__c);
            }
       
            if(earnedHoursMap.containsKey(line.Related_Form__c))
            {
                tmpVal = earnedHoursMap.get(line.Related_Form__c);
                tmpVal = tmpVal + line.Travel_Comp_Hours_Earned__c;
                earnedHoursMap.remove(line.Related_Form__c);
                earnedHoursMap.put(line.Related_Form__c, tmpVal);
            }
            else
            {
                earnedHoursMap.put(line.Related_Form__c, line.Travel_Comp_Hours_Earned__c);
            }
        }
        
        if(earnedHoursMap.size() > 0 || proposedHoursMap.size() > 0)
        {
            for(Forms__c form: updateForms)
            {
                if(proposedHoursMap.containsKey(form.id) && (form.TCTO_Request_Type__c == 'Proposed Hours Request' || 
                                                            form.TCTO_Request_Type__c ==  'Proposed Hours Approved'))
                {
                    form.Proposed_Travel_Comp_Hours_Total__c = proposedHoursMap.get(form.id);
                    form.Earned_Travel_Comp_Hours_Total__c = 0;
                }
                
                if(earnedHoursMap.containsKey(form.id) && (form.TCTO_Request_Type__c == 'Earned Hours Request' || 
                                                            form.TCTO_Request_Type__c ==  'Earned Hours Approved'))
                {
                    form.Earned_Travel_Comp_Hours_Total__c = earnedHoursMap.get(form.id);
                }
            }
            update updateForms;
        }
    }   
}