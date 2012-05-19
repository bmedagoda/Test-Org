public class tagTest {
private Integer counter;
private Boolean clicked = false;

public TagTest() {
counter = 0;
}
 
public String getTable () { return '<h3>Click on one of the contacts below</h3>';}
public PageReference poller() {
counter++;
return null;
}

public String getStatus() {
return 'Hello World (' + counter +')';
}

public List<Lead> getLeads() {
return new List<Lead>([Select Id, Name, Company, Status, Owner.Name From Lead Limit 3]);
}

public List<Integer> getNumbers() {
List<Integer> numbers = new Integer[] {1,2,3,4,5,6,7,8,9};
return numbers;
}

public void setDate() {
} 

public Date getDate() {
return System.today();
}

public void setOpp() {}
public Opportunity getOpp() {
return new Opportunity();
}

public PageReference test(){
this.clicked = true;
return null;

}

public Boolean getClicked() {
return this.clicked;
}


static testMethod void testThese() { 
        TagTest t = new tagTest();

        Boolean b = t.getClicked();
        t.test();
        t.setOpp();     t.getOpp();
        t.getStatus();
        t.setDate();t.getDate();
        t.getLeads();
        t.getTable(); 
        t.poller();
        t.getNumbers();
 }
}