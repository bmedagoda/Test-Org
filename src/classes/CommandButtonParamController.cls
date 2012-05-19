public with sharing class CommandButtonParamController {
 
    // an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // the object being referenced via url
    private Contact contact {get;set;}
    // the variable being set from the commandbutton
    public String nickName {
    	get;
    	// *** setter is NOT being called ***
    	set {
    		nickName = value;
    		System.debug('value: '+value);
    	}
    }
 
    // initialize the controller
    public CommandButtonParamController(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        this.contact = (Contact)controller.getRecord();
 
    }
 
    // handle the action of the commandButton
    public PageReference processButtonClick() {
    	System.debug('nickName: '+nickName);
    	// now process the variable by doing something...
    	return null;
    }
 
}