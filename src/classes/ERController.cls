/*
Copyright (c) 2007 Appirio, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
public class ERController {

static String myLogoUrl = 'https://na1.salesforce.com/img/appExchange145x32.gif';

// Tag Cloud

public class Tag {
        Integer weight;
        String value;
        public Tag(Integer pct, String value) {
                if (pct < 13) { weight = 1; }
                else if (pct >= 13 && pct < 26) { weight = 2; }
                else if (pct >= 26 && pct < 38) { weight = 3; }
                else if (pct >= 38 && pct < 51) { weight = 4; }
                else if (pct >= 51 && pct < 63) { weight = 5; }
                else if (pct >= 63 && pct < 76) { weight = 6; }
                else if (pct >= 76 && pct < 88) { weight = 7; }
                else if (pct >= 88) { weight = 8; }
                this.value = value;
        }
        public Integer getWeight() { return weight; }
        public String getValue() { return value; }
}

public List<Tag> getTagCloud() {
        Map<String,Integer> data = new Map<String, Integer>();
        List<TagDefinition > tagDef= [ Select t.Type, t.Name, t.Id From TagDefinition t];
        System.debug('--------------0t09000000001ue--------------'+tagDef);
        Integer max = 0;
        List<String> tagNames = new List<String>();
        for (TagDefinition tg: tagDef) {
              
                        Integer count = 1;
                        if (data.containsKey(tg.name)) {
                                count = data.get(tg.name) + 1;
                        } else {
                                tagNames.add(tg.name);
                        }
                        data.put(tg.name, count);
                        if (count > max) {
                                max = count;
                        }       
             
        }
        
        // this is convoluted but we can't sort Lists of non-primitives
        tagNames.sort();
        System.debug('----------------------------tagNames-----------------------'+tagNames);
        List<Tag> result = new List<Tag>();
        for (String tag : tagNames) {
                result.add(new Tag( (100 * data.get(tag)) / max, tag));
        }
        return result;
}


}