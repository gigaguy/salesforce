//
// Developer: Chris Alley
// Purpose: TQB CP Wizard Attachments Page
//

//
// Purpose: File upload controller helper.
//
    ({
    MAX_FILE_SIZE: 4 500 000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 450 000, /* Use a multiple of 4 */

    save : function(component, event) {
        console.log("INFO - TQBCPWizardAddAttachmentController : helper.save : START");

        var pkg = component.get("v.candPackage");
        var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];

        var selectedContentType = component.find("InputSelectDynamic").get("v.value");

        if(selectedContentType == 'None') {
         alert('Please select correct content type in the drop down field');
         return;
       }

        if (typeof file === 'undefined' ||  file === null) {
        alert('TQBCPWizardAddAttachmentHelper: Save Function: Please choose a file before attempting to save.');
        return;
        }

         if (file.size > this.MAX_FILE_SIZE) {
            alert('TQBCPWizardAddAttachmentHelper: Save Function:File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file.size);
            return;
        }

 		//console.log('TQBCPWizardAddAttachmentHelper: Save Function:blob of file' + JSON.stringify(file));
        var fr = new FileReader();

        var self = this;
        fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);

    	    self.upload(component, file, fileContents);
        });

        fr.readAsDataURL(file);
    },


    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);

        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');
    },


    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        var action = component.get("c.saveTheChunk");
        var chunk = fileContents.substring(fromPos, toPos);
        var selectedContentType = component.find("InputSelectDynamic").get("v.value");
 		console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: component.get("v.candPackage.Id"): ' + component.get("v.candPackage.Id"));
        console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: file : ' + file);
        console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: fileContents : ' + fileContents);
		console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: fromPos: ' + fromPos);
        console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: toPos : ' + toPos);
		console.log('TQBCPWizardAddAttachmentHelper: uploadChunk Function: attachId: ' + attachId);


        action.setParams({
            "candPkgId": component.get("v.candPackage.Id"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk),
            contentType: selectedContentType,
            fileId: attachId
        });

        var self = this;
        action.setCallback(this, function(response) {
           	var state = response.getState();
			if (state === "SUCCESS") {
				attachId = response.getReturnValue();
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
                if (fromPos < toPos) {
                    self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);
                }
			    var evt = $A.get("e.c:TQBCPAttachNavigator");
				evt.setParams({ "candpkg": component.get("v.candPackage")});
				evt.fire();
            }

        });

       $A.enqueueAction(action);
       //clear the file name after upload completes
       component.find("file").getElement().value='';

             console.log("INFO - TQBCPWizardAddAttachmentController : helper.save : firing TQBCPAttachNavigator event");

         var evt = $A.get("e.c:TQBCPAttachNavigator");
         evt.setParams({ "candpkg": component.get("v.candPackage")});
         evt.fire();
		//document.location.reload();
    },

	populateCandidatePackage : function(component, event) {
       var action = component.get("c.getCandidatePackage");
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS") {
               component.set("v.candPackage", response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
	},

    populateCandidateLOI : function(component, event) {
       var action = component.get("c.getCandidateLOI");
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS") {
               component.set("v.candLOI", response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
	},

     populatePackageAttachmentTypes : function(component, event) {
        var action = component.get("c.getCPAttachTypePickListValues");
        action.setParams({
            "role" : "candidate"
        });
        var inputsel = component.find("InputSelectDynamic");
        var opts=[];
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                        var returnVal = response.getReturnValue();
                        console.log('TQBCPWizardAddAttachmentHelper: populatePackageAttachmentTypes: returnVal = ' + returnVal);
                        for(var i = 0; i< returnVal.length; i++){
                                opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
                        }
                }
                inputsel.set("v.options", opts);
        });
             $A.enqueueAction(action);
	},

        hideSupComments : function(component, event) {

            var toggleText = component.find("1stLineSupComment");
            $A.util.addClass(toggleText,'toggle');
            var toggleText = component.find("2ndLineSupComment");
            $A.util.addClass(toggleText,'toggle');
        }

})