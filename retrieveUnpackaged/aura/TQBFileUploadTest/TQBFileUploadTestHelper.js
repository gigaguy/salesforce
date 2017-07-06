// UPLOAD TESTING APP
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
        var pkg = component.get("v.candPackage");
        var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];
        var contentType = component.find("InputSelectDynamic").get("v.value");
        var message = 'Please select correct content type';

        if(contentType == "None") {
        alert('Please select correct content type.');
        return;
    }

        if (typeof file === 'undefined' ||  file === null) {
        alert('TQBCPWizardAttachHelper: Save Function: Please choose a file before attempting to save.');
        return;
    }

         if (file.size > this.MAX_FILE_SIZE) {
            alert('TQBCPWizardAttachHelper: Save Function:File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file.size);
            return;
        }

 		console.log('TQBCPWizardAttachHelper: Save Function:blob of file' + JSON.stringify(file));
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
 		//console.log('TQBCPWizardAttachHelper: uploadChunk Function: component.get("v.candPackage.Id"): ' + component.get("v.candPackage.Id"));
        console.log('TQBCPWizardAttachHelper: uploadChunk Function: file : ' + file);
        //console.log('TQBCPWizardAttachHelper: uploadChunk Function: fileContents : ' + fileContents);
		console.log('TQBCPWizardAttachHelper: uploadChunk Function: fromPos: ' + fromPos);
        console.log('TQBCPWizardAttachHelper: uploadChunk Function: toPos : ' + toPos);
		console.log('TQBCPWizardAttachHelper: uploadChunk Function: attachId: ' + attachId);


        action.setParams({
            "candPkgId": component.get("v.candPackage.Id"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk),
            contentType: selectedContentType,
            fileId: attachId
        });

        var self = this;
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
            if (fromPos < toPos) {
            	self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);
            }
        });

       $A.enqueueAction(action);
		document.location.reload();
    },


        // Chris Alley delete candidate attachment
        deleteAttachment: function(component, event) {
            var Id = event.target.id;
            var action = component.get("c.deleteCPAttachment");
            action.setParams({
                "candPkgId": component.get("v.candPackage.Id"),
              attachId : Id
            });

            $A.enqueueAction(action);
			document.location.reload();

        },

        /*
            // Chris Alley view candidate attachment
            viewAttachment: function(component, event, helper) {
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [component.get("v.candPackage.Id")]
                });
            },
          */




        // Chris Alley view candidate attachment
        viewAttachment: function(component, event) {
            var Id = event.target.id;
            var action = component.get("c.viewCPAttachment");
            action.setParams({
                "candPkgId": component.get("v.candPackage.Id"),
                 attachId : Id
            });

            $A.enqueueAction(action);

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
                        console.log('returnVal = ' + returnVal);
                        for(var i = 0; i< returnVal.length; i++){
                                opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
                        }
                }
                inputsel.set("v.options", opts);
        });
             $A.enqueueAction(action);
	},

})