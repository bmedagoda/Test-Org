public with sharing class LetterTemplateContr {

    public LetterTemplateContr(ApexPages.StandardController controller) {
        tamilText='ஐந ஐநபங சள';
        englishText='Hello World!';
        otherText='力のフィルタリング   这是一个测试';
    
        //sinhalaText = EncodingUtil.urlEncode('ිාධෛැඅයාිඓාි', 'ISO-8859-1');
        //sinhalaText =  EncodingUtil.urlDecode('ිාධෛැඅයාිඓාි', 'ISO-8859-1');

        sinhalaText = 'ිාධෛැඅයාිඓාි';
    }

        public String sinhalaText{get;set;}
        public String tamilText{get;set;}
        public String englishText{get;set;}
        public String otherText{get;set;}
        public String otherText1{get;set;}
        public boolean Isvisible{get;set;}

public void changeVisiblility(){
    Isvisible =false;

}
public LetterTemplateContr(){

    Isvisible = true;
   
   
}

}