chrome.extension.onRequest.addListener(function(request, sender, sendResponse){
    var docsToc = "http://docs.oracle.com/cd/E11882_01/server.112/e17766/toc.htm";//based on 11.2 docs
    
    jQuery.ajax({
        type: 'GET',
        url: docsToc,
        dataType: 'html',
        async: false,
        success: function(data){
            var toc = $(data);
            var chapts = toc.find('.tocheader');
            var errorData = "";
            var baseUrl = this.url.substr(0,this.url.lastIndexOf("/"));
            chapts.each(function(){
                var links = $(this).find('a:contains("ORA")');
                links.each(function(){
                    
                    jQuery.ajax({
                        type: 'GET',
                        url: baseUrl + "/" + $(this).attr('href'),
                        dataType: 'html',
                        async: false,
                        success: function(data){
                            var sUrl = this.url;
                            $(data).find('.msgentry dl').each(function(){
                                var insSt = "insert into TS_ERROR_CODE (ERROR_CODE_ID, DESCRIPTION, CAUSE, ACTION, SOURCE_URL) values ('#ERROR_CODE_ID#', '#DESCRIPTION#', '#CAUSE#', '#ACTION#', '#SOURCE_URL#');";
                                var errorDesc = $('dt span.msg', this).text().trim();
                                                                                                
                                var codeAndDesc = errorDesc.split(':');                            
                                var id = parseFloat(codeAndDesc[0].replace("ORA",""));                                    
                                var desc = codeAndDesc[1].trim().replace(/'/g, "''");
                                
                                insSt = insSt.replace("#ERROR_CODE_ID#", id);
                                insSt = insSt.replace("#DESCRIPTION#", desc);
                                
                                var dls = $('dd', this);
                                insSt =  insSt.replace("#CAUSE#", $(dls[0]).text().trim().replace("Cause: ", "").replace(/'/g, "''"));
                                insSt = insSt.replace("#ACTION#", $(dls[1]).text().trim().replace("Action: ", "").replace(/'/g, "''"));
                                insSt = insSt.replace("#SOURCE_URL#", sUrl);
                                
                                errorData += insSt + "\r";
                                
                            });
                        }                            
                    });
                    
                });
                
            });
            
            var bb = new BlobBuilder;
            bb.append(errorData);
            saveAs(bb.getBlob("text/plain;charset=utf-8"), "errorCodes.sql");
        }
    });
    
});