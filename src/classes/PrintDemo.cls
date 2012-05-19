public with sharing class PrintDemo {

  public PrintDemo() {
        created = System.now();
    }
    
    public DateTime created { get; private set; }
    
    public boolean print { get; set; }
}