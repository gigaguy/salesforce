({

  // Developer: Chris Alley
  // populate pre-existing comments on the CP wizard question screen
  populateQuestionsComments : function(component, event, SupervisorType) {
    //var Id = event.target.id;
    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    var action = component.get("c.populateQuestionCommentsServer");
    console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments : TQB_Candidate_Package_ID = " + component.get("v.candPackage.Id"));
    console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments : SupervisorType = " + SupervisorType);
    action.setParams({
      //"TQB_Candidate_Package_ID" : 'a04r00000026nTAAAY',
     "candPkgId": component.get("v.candPackage.Id"),
      "SupervisorType" : SupervisorType,
      "questionId": component.get("v.question.Id")
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
          component.set("v.firstLineSupQuestionComment", div.innerText); //set from attribute declarations in the component
          console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments : firstLineSupComment=response.getReturnValue() = " + response.getReturnValue());
            }
        else {
          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.secondLineSupQuestionComment", div.innerText); //set from attribute declarations in the component
          console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments : secondLineSupComment=response.getReturnValue() = " + response.getReturnValue());
                     
        }
        //component.set("v.firstLineSupComment.First_Line_Sup_Attach_Comment__c", "TESTING COMMENT PRE-POPULATION");
      } else if (state === "ERROR") {
           alert('TQBCPWizardQAViewHelper : populateQuestionsComments : ERROR getting response from populateQuestionCommentsServer cp Id = ' + component.get("v.candPackage.Id"));
         console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments :firstLineSupComment=  response.getReturnValue() after server call = " +  component.get("v.candPackage.Id"));
        console.log ("TQBCPWizardQAViewHelper : populateQuestionsComments : SupervisorType after server call = " + SupervisorType);
      }
    });

    $A.enqueueAction(action);
  },
  // end populateQuestionsComments 

  getloggedInUserRole : function(component, event) {
    var action = component.get("c.getUserRole"); // method in the apex class
    action.setCallback(this, function(a) {
      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
      console.log ("TQBCPWizardQAViewHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
    });

    $A.enqueueAction(action);
  },

  getQuestionCount : function(component, event) {
    var action = component.get("c.getCandidateQuestionsCount"); // method in the apex class
      action.setParams({
       "candPkgId": component.get("v.candPackage.Id")
      });
      action.setCallback(this, function(a) {
        component.set("v.questionCount",a.getReturnValue());
      });
    $A.enqueueAction(action);
  },

  getQuestionPagination : function(component, event, prevVar, nextVar){

    var question = component.get("v.questionIndex") || 1;    
    var action = component.get("c.getCandidateQuestionForPagination");
    action.setParams({
      "candPkg" : component.get("v.candPackage"),
      "candPkgId": component.get("v.candPackage.Id"),
      "prev": prevVar,
      "next" :nextVar, 
      "questionNumber" : question
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
          var result = response.getReturnValue();
          
          component.set("v.hasPrev",result.hasPrev);          
          component.set("v.hasNext",result.hasNext);
          
          var evt = $A.get("e.c:TQBCPViewQA");
          evt.setParams({ 
             "candpkg": result.candpackage,
             "question": result.question, 
             "questionIndex":result.questionNumber,
             "firstLineSupQuestionComment": result.firstLineComment ,
             "secondLineSupQuestionComment": result.secondLineComment
           });
          evt.fire();
      }
      else if (state === "ERROR") {
        console.log('calling the getQuestionPagination failed');
      }
    });
    $A.enqueueAction(action);
   },
  

  textCounterHelper : function(component, event) {
      var ans = component.get("v.question.Answer__c");
      var div = document.createElement("div");
      div.innerHTML = ans;
      var answerWithNoWhiteSpace = div.innerText.replace(/\s/g, "");
      component.set("v.answerLength", answerWithNoWhiteSpace.length);
  },

  getAnswer : function(component, event) {

    //Added by Naveen
    //Get the length of the answer field and alert the user if its more than 3840 characters
      var answer = component.get("v.question.Answer__c");
      var div = document.createElement("div");
      div.innerHTML = answer;
      component.set("v.answerWithoutTags",div.innerText);
      var answerWithNoWhiteSpaceNTags = div.innerText.replace(/\s/g, "");
      component.set("v.answerWithNoWhiteSpaceNTags", answerWithNoWhiteSpaceNTags);
      console.log('TQBCPWizardQAViewController:saveQuesAns answer without spaces ' + answerWithNoWhiteSpaceNTags.length); 
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