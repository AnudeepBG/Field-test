    var MB = 1024 * 1024;
    var maxFileSize = setMaxFileSize();
        
    var pageNumber = 1;
    var pagesCount = 1;
    var filesForUpload = false;
        
    var fileTable;
    var arrayUploadFiles = [], addedFileNames = [], displayFileNames = [];
    var totalSize = 0;
    var arrayErrorFiles = [];
    var headerDel = 0;
    var filePathForSave = '';

    jq(document).ready(function() {
      var fileInput = jq('#file-field'); 

      fileInput.bind("change", function() {
        displayFiles(this.files);           
      });        
        
      document.onclick = function() { 
        var pn = document.getElementById('inpPageNumber');
        if (pn) pn.readOnly = false; 
        document.getElementById('txtSearch').readOnly = false;
      }; 
    
////////////////////////////////////////////////////////////////////////////////
      var dropZone = jq('#dropZone');
      var dragTable = jq('#tblFilesPanel');
                                  
      if (typeof (window.FileReader) == 'undefined') {
        dropZone.text("Drag & Drop not supported");
        dropZone.addClass('error');
      }
      dragTable[0].ondragover = dropZone[0].ondragover = function() {
        dropZone.addClass('hover');
        return false;
      };
      dragTable[0].ondragleave = dropZone[0].ondragleave = function() {
        dropZone.removeClass('hover');
        return false;
      };
                        
      dragTable[0].ondrop = dropZone[0].ondrop = function (event) {
        event.preventDefault();
        dropZone.removeClass('hover');
        displayFiles(event.dataTransfer.files);
      };
////////////////////////////////////////////////////////////////////////////////
        
      jq("#txtSearch").keydown(function(e) {
        if (e.keyCode == 13) return false;
      });
      
      createTable();
      createNavigation();
      
      enableButton(jq('#btnUpload'), false);
    });
    
    function setMaxFileSize() {
      var sizes = {
          'Firefox' : 5120,
          'Safari' : 5120,
          'Chrome' : 5120,
          'IE' : 100,
          'default' : 5120
      };

      var isFirefox = typeof InstallTrigger !== 'undefined';
      if (isFirefox) return sizes['Firefox'] * MB;
      
      var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
      if (isSafari) return sizes['Safari'] * MB;
      
      var isChrome = !!window.chrome;
      if (isChrome) return sizes['Chrome'] * MB;
      
      var isIE = !!document.documentMode;
      if (isIE) return sizes['IE'] * MB;
      
      return sizes['default'] * MB;
    }
    
    function blockUI(fileName) {
      var opt = { 
        message: '<div><span id="imgProgress"></span> Deleting ' + fileName + '....</div>',
        css: {
          border: '0 none',
          backgroundColor: 'transparent'
        },
        overlayCSS: {
          backgroundColor: '#fff' 
        }, 
        fadeIn:0,fadeOut:0  
      };
      jq.blockUI(opt);
    }

    function unblockUI() {
      jq.unblockUI({fadeIn:0,fadeOut:0}); 
    }    

    function enableButton(button, enable) {
      if (enable) {
        button.removeClass('btnDisabled');
        button.addClass('btn');
        button.removeAttr('disabled');
      } else {
        button.removeClass('btn');
        button.addClass('btnDisabled');
        button.attr('disabled', 'disabled');
      }
    }

    function displayFiles(files) {
      jq('[id$="thTableHeader"]').empty();
      headerDel = 1;
      displayFileNames = [];
      
      jq.each(files, function(i, file) {
        var displayName = file.name;
        
        if (file.name == 'image.jpg' && findByName(file.name) >= 0 ) {
          displayName = findNearestName();
        }
        file.displayName = displayName;
        
        var fileName = htmlEscape(encodeURIComponent(displayName).replace('\'',' ','g'));
        var fileSize = String(roundSize(file.size));
        var fileFound = 0;
        
        for (var i = 0; i < arrayUploadFiles.length; i++) {
          if (arrayUploadFiles[i] == fileName + fileSize) {
            fileFound = 1;
            break;
          }
        }
             
        if (fileFound == 0) {
          arrayUploadFiles.push(fileName + fileSize);
          addedFileNames.push(fileName);
         
          fileTable = jq('div[id$="tblFilesPanel"] tbody');
          var tr = jq('<tr id="\''+fileName+fileSize+'\'" class="dataRow even first last" onfocus="if (window.hiOn){hiOn(this);}" onblur="if (window.hiOff){hiOff(this);}" onmouseout="if (window.hiOff){hiOff(this);} " onmouseover="if (window.hiOn){hiOn(this);} "><td class="actionColumn" style="border-bottom: 1px solid #EAEAEA;"><a class="actionLink" onclick="deleteFile(\''+fileName+'\', \''+fileSize+'\', fileTable); return false;" href="">Del</a></td>').prependTo(fileTable);
          jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;">').text(fileName).appendTo(tr);
          jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;" width="250px">').text('').appendTo(tr);
          if (file.size <= maxFileSize) {
            jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;">').text(roundSize(file.size)).appendTo(tr); 
            var td = jq('<td colspan ="2" class="dataCell" style="border-bottom: 1px solid #EAEAEA;">').appendTo(tr);
            jq('<div>').addClass('progress').attr('rel', '0').attr('id', 'progressDiv').text('0%').appendTo(td);
            tr.get(0).file = file;  
          } else {
            jq('<td class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text(roundSize(file.size)).appendTo(tr); 
            jq('<td colspan ="2" class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text('File size should be less or equal ' + roundSize(maxFileSize,0)).appendTo(tr);
          }
        }      
      }); 

      jq('[id$="file-field"]').val('');  
                    
      if (headerDel == 1) {
        jq('[id$="thTableHeader"]').empty(); 
        var fileTable = jq('div[id$="tblFilesPanel"] tbody');
        var tr = jq('<tr class="headerRow" id="thTableHeader">').prependTo(fileTable);
        jq('<th class="actionColumn" scope="col" style="width:55px;">Action</th>').appendTo(tr);
        jq('<th class=" zen-deemphasize" scope="col">File Name</th>').appendTo(tr);
        jq('<th class=" zen-deemphasize" scope="col" width="250px">Description</th>').appendTo(tr);
        jq('<th class=" zen-deemphasize" scope="col">Size</th>').appendTo(tr);
        jq('<th class=" zen-deemphasize" scope="col">Uploaded By</th>').appendTo(tr);
        jq('<th class="DateElement zen-deemphasize" scope="col">Uploaded Date</th>').appendTo(tr);
        headerDel = 0;
      }
      enableButton(jq('#btnUpload'), true);
    }

    function findNearestName() {
      var i = 1;
      var newName = 'image001.jpg';
      while (findByName(newName) >= 0) {
          newName = 'image' + paddy(i++, 3) + '.jpg';
      }
      return newName;
    }
    
    function paddy(n, p, c) {
      var pad_char = typeof c !== 'undefined' ? c : '0';
      var pad = new Array(1 + p).join(pad_char);
      return (pad + n).slice(-pad.length);
    }
    
    function findByName(name) {
      for (var i = addedFileNames.length - 1; i >= 0; i--) {
        if (addedFileNames[i] == name)
          return i;
      }
      return i;
    }
    
    function createTimestamp(d) {
      return d.getFullYear().toString() + (d.getMonth() + 1).toString() + d.getDate().toString() + d.getHours().toString() + d.getMinutes().toString() + 
        d.getSeconds().toString() + Math.ceil(d.getMilliseconds()/10.).toString();
    }

    function deleteFile(fileName, fileSize, fileTable) { 
      for (var i = 0; i < arrayUploadFiles.length; i++) {
        if (arrayUploadFiles[i] == fileName + fileSize) {
          arrayUploadFiles.splice(i, 1);  
        }
      }
      
      for (var i = 0; i < arrayErrorFiles.length; i++) {
        if (arrayErrorFiles[i].name+arrayErrorFiles[i].size == fileName +fileSize) {
          arrayErrorFiles.splice(i, 1); 
        }  
      } 
      
      fileTable = jq('div[id$="tblFilesPanel"] tbody');
      for (var i = 0; i < fileTable.find('tr').length; i++) {
        if (fileTable.find('tr')[i].id == "'"+fileName+fileSize+"'") {  
          fileTable.find('tr')[i].remove();
        } 
      }
      
      if (filesToUpload().length == 0) {
        enableButton(jq('#btnUpload'), false);
      }
    }    
    
    Element.prototype.remove = function() {
      this.parentElement.removeChild(this);
    }
    
    NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
      for(var i = 0, len = this.length; i < len; i++) {
        if(this[i] && this[i].parentElement) {
          this[i].parentElement.removeChild(this[i]);
        }
      }
    }
    
    function roundSize(fileSize, numDigits) {
      var kilobyte = 1024;
      var megabyte = 1024 * kilobyte;
      var gigabyte = 1024 * megabyte;
      var metrics = new Array( gigabyte, megabyte, kilobyte);
      var correspond = new Array('GB', 'MB', 'KB');
      var size;
      for (var i = 0; i < metrics.length; i++) {
        if (fileSize >= metrics[i]) {
          size = fileSize/metrics[i];
          
          if (typeof numDigits === 'undefined') {
            numDigits = 2;
          }

          size = size.toFixed(numDigits);
          size += ' ' + correspond[i];
          return size;
        }
      }
      size = fileSize + ' Bytes';
      return size;
    }
    
    function filesToUpload() {
      var result = [];
      
      jq('#tblFilesPanel tr').each(function(i, file) {
        if (this.file)
          result.push(this.file);
      });
      return result;
    }

    function uploadFiles(disableBtn) {      
      if (disableBtn) {
        enableButton(jq('#btnUpload'), false);                           
        enableButton(jq('#btnBrowse'), false);
      }
               
      filesForUpload = false;  
      fileTable = jq('div[id$="tblFilesPanel"] tbody');          
      for (var i = 0; i < fileTable.find('tr').length; i++) {
        if (!fileTable.find('tr')[i].file) {
          continue;
        }
        filesForUpload = true;
        file = fileTable.find('tr')[i].file;
        var fileName = encodeURIComponent(file.displayName).replace('\'','%27','g');
        var pBar = jq(fileTable.find('tr')[i]).find('.progress');
                  
        if (file.size < 100 * MB) {
          Visualforce.remoting.Manager.invokeAction(
            'cps3.CloudpondS3ConnectorController.uploadFile', 
            fileName, file.type, objectName, objectId,'',
            function(result, event) {
              if(event.type != 'exception') {
                  if(event.status) {
                      if (result) {
                          var amazonCredentials = result;
                          var reader = new FileReader();
                          reader.readAsArrayBuffer(file);
                          reader.onload = function(e) {
                              var arrayBuffer = reader.result;
                              remoteFunctionPut(amazonCredentials, file, reader.result, pBar); 
                          };
                      }
                  }
              }   
            }, 
            {buffer: true, escape: true, timeout: 120000}
          );
        } else {
          Visualforce.remoting.Manager.invokeAction(
            'cps3.CloudpondS3ConnectorController.initMultiUploadFile', 
            fileName, file.type, objectName, objectId,
            function(result, event) {
              if (event.type != 'exception') {
                if (event.status) {
                  if (result) {
                    var amazonCredentials = result;
                    AWS.config.update({ accessKeyId: amazonCredentials.k1, secretAccessKey: amazonCredentials.k2 });
                    AWS.config.region = amazonCredentials.region;
                          
                    var upload = new AWS.S3.ManagedUpload({
                      partSize: 5 * 1024 * 1024, queueSize: 1,
                      params: {Bucket: amazonCredentials.bucketName, Body: file, Key: amazonCredentials.fullFileName}
                    });
        
                    upload.on('httpUploadProgress', function(e) {
                      //console.log(e);
                      var progress = e.loaded / e.total * 100;
                      progress = progress.toFixed(2);
                      progressUpload(progress, pBar);       
                    });
                                  
                    upload.send(function (err, data) {
                      console.log(err, data);
                      if (err) {
                        var message = 'Error code: '+err.codes+'. Error: '+ err.messaget; 
                        arrayErrorFiles.push({'name': file.name, 'size': file.size, 'message': message});
                        exitUpload(file, message);
                      } else {
                        progressUpload(100, pBar);
                        uploadFiles();
                      }
                    });
                  }
                }
              }
            }, 
            { buffer: true, escape: true, timeout: 120000 }
          );
        }

        delete fileTable.find('tr')[i].file;
        break;
      }   
      if (!filesForUpload) {
        totalSize = 0;
        updateFilesArray();                          
      } 
    } 
        
    function remoteFunctionPut(amazonCredentials, file, fileBody, pBar) {
      sforce.connection.sessionId = "{!$Api.Session_ID}";
      sforce.connection.init("{!$Api.Session_ID}", amazonCredentials.endpoint+'/'+amazonCredentials.bucketName+'/'+amazonCredentials.fullFileName);

      var progressBar = pBar;
      
      var xhr = new XMLHttpRequest();
      // salesforce overrides original XMLHttpRequest in IE
      if (!xhr.upload && window.Sarissa && window.Sarissa.originalXMLHttpRequest) {
        xhr = new Sarissa.originalXMLHttpRequest();
      }
      
      var progress_pred = 0;
      var count = 0;
        
      var progressHandler = function(e) {
        if (e.lengthComputable) {
          var progress = Math.floor( e.loaded / e.total * 100 );
          progressUpload(progress, progressBar);       
        }
      }

      xhr.upload.addEventListener("progress", function(e) {           
        if (e.lengthComputable) {
          var progress = (e.loaded * 100) / e.total;
          progress = progress.toFixed(2);
          if (progress != 100) {
            progressUpload(progress, progressBar); 
          } 
        }
      }, false);

      xhr.onreadystatechange = function () {
        if (this.readyState == 4) {
          var status = this.status;
          if (status == 200) { 
            progressUpload(100, this.progressBar);
            uploadFiles();
          } else {
            if (this.responseText) {
              getResponseFromXML(this.responseText); 
              uploadFiles();
            } else {
              var message = '';
              if (this.statusText) {
                message = 'Status: '+this.status+'. Error: '+this.statusText; 
              }
              else if (this.responseText) {
                message = 'Status: '+this.status+'. Error: '+this.responseText;
              }
              else {
                message = 'Status:'+this.status+'. Error: Unknown error.'; 
              }
              arrayErrorFiles.push({'name': file.name, 'size': file.size, 'message': message});
              exitUpload(file, message);
            }
          }
        }
      };      

      xhr.open("PUT", amazonCredentials.endpoint+'/'+amazonCredentials.bucketName+'/'+amazonCredentials.fullFileName);
      
      xhr.setRequestHeader("Cache-Control", "no-cache");
      xhr.setRequestHeader("Authorization",amazonCredentials.authorization);        
      xhr.setRequestHeader("X-Amz-Date",amazonCredentials.timestamp); 
      xhr.setRequestHeader("Content-Type",file.type+';charset=UTF-8');
      
      xhr.progressBar = progressBar;  
      xhr.send(fileBody);
    }
    
    function exitUpload(file, message) {
      var fileTable = jq('div[id$="tblFilesPanel"] tbody');
      for (var i=0; i<fileTable.find('tr').length; i++) {
        if (fileTable.find('tr')[i].id == "'"+file.name+roundSize(file.size)+"'") {
          fileTable.find('tr')[i].remove();
          jq('[id$="thTableHeader"]').empty();
          var tr = jq('<tr id="\''+file.name+file.size+'\'" class="dataRow even first last" onfocus="if (window.hiOn){hiOn(this);}" onblur="if (window.hiOff){hiOff(this);}" onmouseout="if (window.hiOff){hiOff(this);} " onmouseover="if (window.hiOn){hiOn(this);} "><td class="actionColumn" style="border-bottom: 1px solid #EAEAEA;"><a class="actionLink" onclick="deleteFile(\''+file.name+'\', \''+file.size+'\', fileTable); return false;" href="">Del</a></td>').prependTo(fileTable);
          jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;">').text(file.name).appendTo(tr);
          jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;" width="250px">').text('').appendTo(tr); 
          jq('<td class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text(roundSize(file.size)).appendTo(tr); 
          jq('<td colspan ="2" class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text(message).appendTo(tr);
          jq('[id$="file-field"]').val('');  
          fileTable = jq('div[id$="tblFilesPanel"] tbody');
          var tr = jq('<tr class="headerRow" id="thTableHeader">').prependTo(fileTable);
          jq('<th class="actionColumn" scope="col" style="width:55px;">Action</th>').appendTo(tr);
          jq('<th class=" zen-deemphasize" scope="col">File Name</th>').appendTo(tr);
          jq('<th class=" zen-deemphasize" scope="col" width="250px">Description</th>').appendTo(tr);
          jq('<th class=" zen-deemphasize" scope="col">Size</th>').appendTo(tr);
          jq('<th class=" zen-deemphasize" scope="col">Uploaded By</th>').appendTo(tr);
          jq('<th class="DateElement zen-deemphasize" scope="col">Uploaded Date</th>').appendTo(tr); 
          uploadFiles();
        }
      }      
    };
    
    function progressUpload(progress, progressBar) {
      var width = progressBar.width();
      var bgrValue = -width + (progress * (width / 100)); 
      progressBar.attr('rel', progress).css('background-position', bgrValue+'px center').text(progress+'%');
    }
    
    function getResponseFromXML(response) {
      parser = new DOMParser();
      var xmlDoc = parser.parseFromString(response, "text/xml");
      if (xmlDoc.getElementsByTagName("Message")[0].childNodes[0].nodeValue) {
        alert ('Error. Message from Amazon S3: '+xmlDoc.getElementsByTagName("Message")[0].childNodes[0].nodeValue);  
      } 
    }
    
    function htmlEscape(str) {
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;') 
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
    }
        
    function confirmDelete (linkForDel, fileForDel) {
      linkForDel  = unescape(linkForDel); 
      var question = 'Are you sure you want to delete file ' + fileForDel + '?';  
      if (confirm(question)) {              
        blockUI(htmlEscape(fileForDel));    
        deleteFileFromAmazon(linkForDel);
      }
    } 
            
    function moveToFirstPage() {    
      pageNumber = 1;
      refreshFileTable();                  
    }   
    
    function moveToPreviousPage() { 
      if (pageNumber > 1) {
        pageNumber = pageNumber - 1;
        refreshFileTable();
      }            
    }    
    
    function moveToNextPage() {
      if (pageNumber < pagesCount) {
        pageNumber = pageNumber + 1;
        refreshFileTable();    
      }  
    }   
    
    function moveToLastPage() { 
      pageNumber = pagesCount;
      refreshFileTable();                  
    }   
        
    function inputPageNumber() {
      var inputNum = parseInt(jq("[id$='inpPageNumber']").val(), 10);
      if (inputNum > 0 && inputNum <= pagesCount) {   
        jq("[id$='inpPageNumber']").val(inputNum);      
        pageNumber = inputNum; 
        refreshFileTable(); 
      } 
      else {
        jq("[id$='inpPageNumber']").val(pageNumber);
      }                 
    } 
        
    function searchInputText() {
      flist = flistDefault;
      if (jq("[id$='txtSearch']").val() != '') {
        var searchFlist = new Array();
        pageNumber = 1;
        jq("[id$='inpPageNumber']").val(1);
        var searchText = String(jq("[id$='txtSearch']").val());
        for (i = 0; i < flist.length; i++) {
          var fname = flist[i].nameDecode;    
          var fpath = flist[i].downloadPath;                      
          fname = fname.toUpperCase();
          if (fname.indexOf(searchText.toUpperCase()) >= 0) {
            searchFlist.push(flist[i]);             
          } else {
            for (j = 0; j < listDescription.length; j++) {
              if (fpath == listDescription[j].cutfilepath) {
                var fdescription = listDescription[j].description;
                if (fdescription != null) {
                  fdescription = fdescription.toUpperCase();
                  fdescription = fdescription.replace(/<ENTER>/g, '');
                  if (fdescription.indexOf(searchText.toUpperCase()) >= 0) {
                    searchFlist.push(flist[i]);
                  }
                }
              }
            }
          }           
        }    
        flist = searchFlist;    
      } 
      refreshFileTable();
    }
    
    function showAllFiles() {
      flist = flistDefault;
      pageNumber = 1;  
      jq("[id$='inpPageNumber']").val(1);
      jq("[id$='txtSearch']").val('');
      refreshFileTable();
    }
    
    function deleteFileInListAndTable() {
      unblockUI();
      var delFilePath = jq("[id$='hiddenDeleteFilePath']").val();     
      var delFileName = '';
      var delFileSize = '';
      
      for (i = 0; i < flist.length; i++) {  
        if (flist[i].downloadPath == delFilePath) {
          delFileName = flist[i].name;
          delFileSize = flist[i].size; 
          flist.splice(i, 1);
        }
      }   
      for (i = 0; i < flistDefault.length; i++) {  
        if (flistDefault[i].downloadPath == delFilePath) {
          flistDefault.splice(i, 1);
        }
      }   
      var fileTable = jq('div[id$="tblFilesPanel"] tbody');
      for (var i=0; i<fileTable.find('tr').length; i++) {
        if (fileTable.find('tr')[i].id == "'"+escape(delFilePath)+"'") {
          fileTable.find('tr')[i].remove();
        } 
      }   
      for (var i = 0; i < arrayUploadFiles.length; i++) {
        if (arrayUploadFiles[i] == delFileName + delFileSize) {
          arrayUploadFiles.splice(i, 1);  
        }  
      }   
      for ( i = 0; i < listDescription.length; i++) {
        if (listDescription[i].cutfilepath == delFilePath) {
          listDescription.splice(i, 1);
        }
      }                 
      refreshFileTable();   
    }
     
    function updateFilesArray() {
      Visualforce.remoting.Manager.invokeAction(
        'cps3.CloudpondS3ConnectorController.FilesArray',
        objectName, objectId,
        function(result, event) {
          var flistString =  result;
          flist = JSON.parse(flistString);
          flistDefault = flist;
          pageNumber = 1; 
          jq("[id$='inpPageNumber']").val(1);
          jq("[id$='txtSearch']").val('');
          refreshFileTable();
                      
          //enableButton(jq('#btnUpload'), true);
          enableButton(jq('#btnBrowse'), true);                        
        },  
        { buffer: true, escape: false, timeout: 120000 }
      ); 
    }  
      
    function browseFiles() {
      jq("[id$='file-field']").click();
    }   
        
    function showPopUp(filePath, fileName, fileSize){
      filePath = unescape(filePath);
      //jq("[id$='txtName']").val(String(fileName));
      var name = jq("label[id$='txtName']");
      jq("label[id$='txtName']").empty();
      jq('<label>').text(String(fileName)).appendTo(name);
      
      //jq("[id$='txtSize']").val(fileSize);
      var size = jq("label[id$='txtSize']");
      jq("label[id$='txtSize']").empty();
      jq('<label>').text(String(fileSize)).appendTo(size);
      
      jq("[id$='hiddenFilePathForCS3C']").val(String(filePath)); 
      filePathForSave = filePath;        
      getfileDescriptionForCS3C();           
    }
    
    function showPopUpAfterRerender() {
      if (!showAll) { 
        document.getElementById('divBottomNav').style.display = "none";
      } else {   
        jq("div[id$='popup']").removeClass('b-popup');
        jq("div[id$='popup']").addClass('b-popupShowAll');
        
        jq("div[id$='divPopUp']").removeClass('b-popup-content');
        jq("div[id$='divPopUp']").addClass('b-popup-contentShowAll');          
      }
      var fileDescription = jq("[id$='hiddenFileDescriptionForCS3C']").val();
      fileDescription = fileDescription.replace(/<enter>/g,'\n');
      jq("[id$='txtDescription']").val(fileDescription);   
      jq("#popup").show();
    }     

    function hidePopUp(){ 
      if (!showAll) { 
        document.getElementById('divBottomNav').style.display = "block";    
      }
      jq("#popup").hide();
    }
    
    function savePopUp(){
      var fileDescription = jq("#txtDescription").val();
      jq("[id$='hiddenFileDescriptionForCS3C']").val(String(fileDescription.replace(/[\n\r]/g,'<enter>')));   
      var descriptionExists = 0;
      
      for ( j = 0; j < listDescription.length; j ++) {
        if (listDescription[j].cutfilepath == filePathForSave) {
          listDescription[j].description = fileDescription.replace(/[\n\r]/g,'<enter>');
          descriptionExists = 1;  
        }
      }
      if (descriptionExists == 0) {
        listDescription.push({'cutfilepath': filePathForSave, 'description': fileDescription});
      }
      refreshFileTable();
      savefileDescriptionForCS3C();
      hidePopUp();    
    }        
    
    function createTable() {
      //var inputNum = parseInt(jq("[id$='inpPageNumber']").val(), 10);
      //pageNumber = inputNum;
      var recordCount = showAll ? flist.length : 5;

      pagesCount = flist.length/recordCount - (flist.length % recordCount)/recordCount;
      if ((flist.length % recordCount)/recordCount > 0) {
        pagesCount = pagesCount + 1;
      }                       
      arrayUploadFiles = [];
      addedFileNames = [];
      
      for (i = 0; i < flist.length; i++) {                            
        arrayUploadFiles.push(flist[i].name + flist[i].size);
        addedFileNames.push(flist[i].name);                        
      }                                                                                                   
      var fileTable = jq('div[id$="tblFilesPanel"] tbody');                                                                                           
      for (i = recordCount*(pageNumber-1); i < recordCount*pageNumber; i++) {
        var s = 'style="border-bottom: 1px solid #EAEAEA;"';
        if (i == recordCount*pageNumber - 1 || i == flist.length - 1) {
          s = ''; 
        } 
        if (i < flist.length) {
          var fileName = flist[i].name; 
          var linkForDownload = escape(flist[i].downloadPath);
          var fileNameDecode = flist[i].nameDecode.replace("\'","\\'");  
          var fileDescription = '';
          var arrayDescriptionWord = [];
          for (j = 0; j < listDescription.length; j++) {
            if (listDescription[j].cutfilepath == flist[i].downloadPath) {                                          
              fileDescription = listDescription[j].description;
              if (fileDescription != null) {
                fileDescription = fileDescription.replace(/<enter>/g,'<br> ');
                fileDescription = fileDescription.replace(/\n/g,'<br> ');
                arrayDescriptionWord = fileDescription.split(' ');

                if (arrayDescriptionWord.length > 0) {
                  for (k = 0; k < arrayDescriptionWord.length; k++) {
                    if (arrayDescriptionWord[k].length > 49) {
                      var count = arrayDescriptionWord[k].length / 49;
                      for (l = 1; l <= count; l++) {
                        arrayDescriptionWord[k] = arrayDescriptionWord[k].substring(0,l*49 + (l-1)*4) + '<br>' + arrayDescriptionWord[k].substring(l*49 + (l-1)*4);
                      }
                    }
                  }
                  fileDescription  = '';
                  for (k = 0; k < arrayDescriptionWord.length; k++) {
                    fileDescription = fileDescription + ' ' + arrayDescriptionWord[k];
                  }
                }
              } else {
                fileDescription = '';
              } 
            }
          }
          var uploadedByNameHref = '';
          for (j = 0; j < usersIdForUrl.length; j++) {                                    
            if (usersIdForUrl[j].name == flist[i].uploadedByName) {
              uploadedByNameHref = '/' + usersIdForUrl[j].id;
            }
          }   
                                                                                                  
          var tr = jq('<tr id="\'' + linkForDownload + '\'" class="dataRow even first last"><td class="actionColumn"' + s + '><a class="actionLink" onclick="showPopUp(\'' + linkForDownload + '\',\'' + htmlEscape(fileNameDecode) + '\',\'' + flist[i].size + '\'); return false;" href="">Edit</a> | <a class="actionLink" onclick="confirmDelete(\'' + linkForDownload + '\',\'' + htmlEscape(fileNameDecode) + '\'); return false;" href="">Del</a></td>').appendTo(fileTable);                         
          jq('<td class="dataCell" '+ s +'><a  target="_blank" href="'+flist[i].url+'">'+htmlEscape(flist[i].nameDecode)+'</a></td>').appendTo(tr);                           
          jq('<td class="dataCell" '+ s +' width="250px">'+fileDescription+'</td>').appendTo(tr);
          jq('<td class="dataCell" '+ s +'>').text(htmlEscape(flist[i].size)).appendTo(tr);
          jq('<td class="dataCell" '+ s +'><a target="_blank" href = "' + uploadedByNameHref + '">' + htmlEscape(flist[i].uploadedByName)+'</a></td>').appendTo(tr);
          jq('<td class="dataCell" '+ s +'>').text(htmlEscape(flist[i].uploadedDateFormat)).appendTo(tr);          
        } 
      } 
      
      for (i = 0; i < arrayErrorFiles.length; i++) {                        
        var file = arrayErrorFiles[i];
        var tr = jq('<tr id="\''+file.name+file.size+'\'" class="dataRow even first last" onfocus="if (window.hiOn){hiOn(this);}" onblur="if (window.hiOff){hiOff(this);}" onmouseout="if (window.hiOff){hiOff(this);} " onmouseover="if (window.hiOn){hiOn(this);} "><td class="actionColumn" style="border-bottom: 1px solid #EAEAEA;"><a class="actionLink" onclick="deleteFile(\''+file.name+'\', \''+file.size+'\', fileTable); return false;" href="">Del</a></td>').prependTo(fileTable);
        jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;">').text(file.name).appendTo(tr);
        jq('<td class="dataCell" style="border-bottom: 1px solid #EAEAEA;" width="250px">').text('').appendTo(tr); 
        jq('<td class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text(roundSize(file.size)).appendTo(tr); 
        jq('<td colspan ="2" class="dataCell" style="color: #FF0000; border-bottom: 1px solid #EAEAEA;">').text(file.message).appendTo(tr);
      }
      
      var tr = jq('<tr class="headerRow" id="thTableHeader">').prependTo(fileTable);
      jq('<th class="actionColumn" scope="col" style="width:55px;">Action</th>').appendTo(tr);
      jq('<th class=" zen-deemphasize" scope="col">File Name</th>').appendTo(tr);
      jq('<th class=" zen-deemphasize" scope="col" width="250px">Description</th>').appendTo(tr);
      jq('<th class=" zen-deemphasize" scope="col">Size</th>').appendTo(tr);
      jq('<th class=" zen-deemphasize" scope="col">Uploaded By</th>').appendTo(tr);
      jq('<th class="DateElement zen-deemphasize" scope="col">Uploaded Date</th>').appendTo(tr);
    }

    function createNavigation() {
      if (pagesCount == 0) {
        pagesCount = 1; 
      }               
      var paginator = jq('div[id$="paginatorId"]');                       
      var Nav = jq('<span style="display:inline-block;" />').appendTo(paginator);
      if (pageNumber == 1) {
        jq('<span class="prevNext"><img class="firstoff" alt="First Page" src="/s.gif" />&nbsp;</span>').appendTo(Nav);     
        jq('<span class="prevNext" style="color: #707070;"><img class="prevoff" alt="Previous" src="/s.gif" />&nbsp;Previous&nbsp;</span>').appendTo(Nav);
        if (pagesCount > 1) {
          jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToNextPage()" style="cursor: hand">&nbsp;Next&nbsp;<img class="next" alt="Next" src="/s.gif" /></a></span>').appendTo(Nav);
          jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToLastPage()" style="cursor: hand">&nbsp;<img class="last" alt="Last Page" src="/s.gif" /></a></span></span>').appendTo(Nav);             
        } else {
          jq('<span class="prevNext" style="color: #707070;">&nbsp;Next&nbsp;<img class="nextoff" alt="Next" src="/s.gif" /></span>').appendTo(Nav);
          jq('<span class="prevNext" >&nbsp;<img class="lastoff" alt="Last Page" src="/s.gif" /></span></span>').appendTo(Nav);                                   
        }
      } else {
        jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToFirstPage()" style="cursor: hand"><img class="first" alt="First Page" src="/s.gif" />&nbsp;</a></span>').appendTo(Nav);     
        jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToPreviousPage()" style="cursor: hand"><img class="prev" alt="Previous" src="/s.gif" />&nbsp;Previous&nbsp;</a></span>').appendTo(Nav);
        if (pageNumber < pagesCount) {
          jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToNextPage()" style="cursor: hand">&nbsp;Next&nbsp;<img class="next" alt="Next" src="/s.gif" /></a></span>').appendTo(Nav);
          jq('<span class="prevNext"><a style="text-decoration: none; color: #000000;" onclick="moveToLastPage()" style="cursor: hand">&nbsp;<img class="last" alt="Last Page" src="/s.gif" /></a></span></span>').appendTo(Nav);                             
        }
        else {
          jq('<span class="prevNext" style="color: #707070;">&nbsp;Next&nbsp;<img class="nextoff" alt="Next" src="/s.gif" /></span>').appendTo(Nav);
          jq('<span class="prevNext">&nbsp;<img class="lastoff" alt="Last Page" src="/s.gif" /></span></span>').appendTo(Nav);                                                        
        }
      }                
                                                                       
      var pageNumberInput = jq('<span class="right">Page<input class="pageInput" value='+String(pageNumber)+' maxlength="4" id="inpPageNumber" readonly="readonly"/>of '+ String(pagesCount) +'</span>').appendTo(paginator); 
      jq("#inpPageNumber").keydown(function(e) { if(e.keyCode == 13){inputPageNumber(); return false; }});
      
      var span = (paginator.width() - pageNumberInput.width() - jq('#capButton').width() - Nav.width()) / 2;
      span = Math.max(span, 2);
      Nav.css('margin-left', span);
    }                  
