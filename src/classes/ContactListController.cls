public class ContactListController {
    // Define the contact list
    
    
    public List<myWrap> myWraps{
        get
        {
            myWraps = new List<myWrap>();
            myWrap w1 = new myWrap();
            w1.name='ranga';
            w1.age = '25';
            myWraps.add(w1);
            myWrap w2 = new myWrap();
            w2.name='ranga';
            w2.age = '25';
            mywraps.add(w2);
            myWrap w3 = new myWrap();
            w3.name='ranga';
            w3.age = '25';
            myWraps.add(w3);
            myWrap w4 = new myWrap();
            w4.name='ranga';
            w4.age = '25';
            myWraps.add(w4);
            myWrap w5 = new myWrap();
            w5.name='ranga';
            w5.age = '25';
            myWraps.add(w5);
            myWrap w6 = new myWrap();
            w6.name='ranga';
            w6.age = '25';
            myWraps.add(w6);
            for(Integer i=7;i<30;i++)
            {
                myWrap w = new myWrap();
                w.name='ranga'+i;
                w.age = '25'+i;
                myWraps.add(w);
            }
            return myWraps;
            
        }
        set;
    }
    
    public class myWrap
    {
        public String name{get;set;}
        public String age {get;set;}
    }
}