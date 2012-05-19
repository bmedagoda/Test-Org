public class popup 
{     
  public boolean displayPopup {get; set;}    
  public String amar {get; set;}      public String HiddenVal {get;set;}       
  public void closePopup() 
  {        
    displayPopup = false;        
     amar = HiddenVal;    
  }     
  public void showPopup()
  {         
    HiddenVal ='';         
    displayPopup = true;    
  } 
}