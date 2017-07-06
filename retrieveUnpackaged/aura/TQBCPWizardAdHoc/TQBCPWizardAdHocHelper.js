({

//Developer: Chris Alley
// Gets the logged in users' role so that the comment boxes can be enabled or disabled based on role name.
  getloggedInUserRole : function(component, event) {
    var action = component.get("c.getUserRole"); // method in the apex class
    action.setCallback(this, function(a) {
      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
      // component.set("v.loggedInUserRole.UserRole.Name", "TQB 1st Line Supervisor Role"); // variable in the component



      console.log ("TQBCPWizardAdHocHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
    });


    $A.enqueueAction(action);
  },


  // Developer: Chris Alley
  // populate pre-existing comments on the CP wizard ad hoc screen
  populateAdHocComments : function(component, event, SupervisorType) {
    //var Id = event.target.id;
    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    var action = component.get("c.populateAdHocCommentsServer");
    console.log ("TQBCPWizardAdHocHelper : populateAdHocComments : TQB_Candidate_Package_ID = " + component.get("v.candPackage.Id"));
    console.log ("TQBCPWizardAdHocHelper : populateAdHocComments : SupervisorType = " + SupervisorType);
    action.setParams({
      //"TQB_Candidate_Package_ID" : 'a04r00000026nTAAAY',
     "candPkgId": component.get("v.candPackage.Id"),
      "SupervisorType" : SupervisorType
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        // component.find("firstLineSupComment");
        if ( SupervisorType == 'firstLineSupComment'){

          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.firstLineSupAdHocComment", div.innerText);
          console.log ("TQBCPWizardAdHocHelper : populateAdHocComments : firstLineSupComment=response.getReturnValue() = " + response.getReturnValue());
            }
        else {
          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.secondLineSupAdHocComment", div.innerText);
          console.log ("TQBCPWizardAdHocHelper : populateAdHocComments : secondLineSupComment=response.getReturnValue() = " + response.getReturnValue());

        }
      } else if (state === "ERROR") {
           alert('TQBCPWizardAdHocHelper : populateAdHocComments : ERROR getting response from populateAdHocCommentsServer cp Id = ' + component.get("v.candPackage.Id"));
         console.log ("TQBCPWizardAdHocHelper : populateAdHocComments :firstLineSupComment=  response.getReturnValue() after server call = " +  component.get("v.candPackage.Id"));
        console.log ("TQBCPWizardAdHocHelper : populateAdHocComments : SupervisorType after server call = " + SupervisorType);
      }
    });

    $A.enqueueAction(action);
  },

  populateCandidateLOI : function(component, event) {
      var selectedPackageId = component.get("v.candPackage.Id");
        var action = component.get("c.getCandidateLOI");
        action.setParams({
      "candPkgId" : selectedPackageId
    });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.candLOI", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

   validationMessageComment :function(component, event, state) {
      if (state === "SUCCESS") {
              $A.createComponents([
                ["ui:message",{
                  "title" : "Success :",
                  "severity" : "confirm",
                  "class" : "slds-size--1-of-2"
                }],
                ["ui:outputText",{
                  "value" : "Comment Saved Successfully."
                }]
              ],
              function(components) {
                var message = components[0];
                var outputText = components[1];
                // set the body of the ui:message to be the ui:outputText
                message.set("v.body", outputText);
                component.set("v.messages", message);
                document.body.scrollTop = document.documentElement.scrollTop = 0;
                window.setTimeout(
                  $A.getCallback(function() {
                    component.set("v.messages", []);
                  }), 5000
                );
              } )
        } else if (state === "ERROR") {
              var errors = response.getError();
              console.log(errors[0]);
              console.log(errors[0].message);
              if (errors[0] && errors[0].pageErrors) {
                $A.createComponents([
                  ["ui:message",{
                    "title" : "Error:",
                    "severity" : "error",
                    "class" : "slds-size--1-of-2"
                  }],
                  ["ui:outputText",{
                    "value" : errors[0].pageErrors[0].message
                  }]
                ],
                function(components) {
                  var message = components[0];
                  var outputText = components[1];
                  // set the body of the ui:message to be the ui:outputText
                  message.set("v.body", outputText);
                  component.set("v.messages", message);
                  document.body.scrollTop = document.documentElement.scrollTop = 0;
                } )
              } else if (errors[0] && errors[0].message) {
                    $A.createComponents([
                      ["ui:message",{
                        "title" : "Error:",
                        "severity" : "error",
                        "class" : "slds-size--1-of-2"
                      }],
                      ["ui:outputText",{
                        "value" : errors[0].message
                      }]
                    ],
                    function(components) {
                      var message = components[0];
                      var outputText = components[1];
                      // set the body of the ui:message to be the ui:outputText
                      message.set("v.body", outputText);
                      component.set("v.messages", message);
                      document.body.scrollTop = document.documentElement.scrollTop = 0;
                    } )
              }
        }
  }

})