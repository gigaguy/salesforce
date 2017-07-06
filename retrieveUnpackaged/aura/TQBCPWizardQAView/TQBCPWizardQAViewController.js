({
	
	populateQADetail : function(component, event, helper) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		selected = event.getParam("question");
		component.set("v.question",selected);
		selected = event.getParam("firstLineSupQuestionComment");
		component.set("v.firstLineSupQuestionComment",selected);
		selected = event.getParam("secondLineSupQuestionComment");
		component.set("v.secondLineSupQuestionComment",selected);
    selected = event.getParam("questionIndex");
    component.set("v.questionIndex",selected);
    console.log('question index value ='+ selected);
    
    helper.getloggedInUserRole(component, event);
    helper.getQuestionCount(component,event);
    helper.getAnswer(component, event);
    helper.textCounterHelper(component, event);
    helper.populateQuestionsComments(component, event, 'firstLineSupComment'); //populate pre-existing 1st line question comment
    helper.populateQuestionsComments(component, event, 'secondLineSupComment'); //populate pre-existing 2nd line question comment


	},

  next : function(component, event, helper) {
    var prevVar = false;
    var nextVar = true;
    helper.getQuestionPagination(component, event, prevVar, nextVar);             
  },
         
  prev : function(component, event, helper) {
    var prevVar = true;
    var nextVar = false;
    helper.getQuestionPagination(component, event, prevVar, nextVar);                
  },

	editQA : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var quest = component.get("v.question");
		var evt = $A.get("e.c:TQBCPEditQA");
		evt.setParams({ "candpkg": pkg, "question": quest });
		evt.fire();
	},
	backToQAList : function(component, event, helper) {
		//var pkg = component.get("v.candPackage");
		//var evt = $A.get("e.c:TQBCPBackToQAList");
		//evt.fire();
		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": component.get("v.candPackage") });
		evt.fire();
	},

   	// Developer: Chris Alley
	//save the first line sup comment from the questions detail screen
    saveQuestionCommentFirstLine : function(component, event, helper) {
      console.log('In TQBCPWizardQAViewController : saveQuestionCommentFirstLine START');
       var action = component.get("c.saveQuestionCommentServer");
       var firstCommentValue = component.get('v.firstLineSupQuestionComment');
       console.log("In TQBCPWizardQAViewController : saveQuestionCommentFirstLine : Comment= " + firstCommentValue);
       var questionId = component.get("v.question.Id");
       console.log("In TQBCPWizardQAViewController : saveQuestionCommentFirstLine : question ID = " + questionId);
       console.log("In TQBCPWizardQAViewController : saveQuestionCommentFirstLine : TQB_Candidate_Package_ID = " + component.get("v.candPackage.Id"));
        action.setParams({
            "Comment": firstCommentValue, 
            "Comment_Type" : "firstLineSupComment", //do not change, this is hard coded in apex server method
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id"),
            "questionId" : component.get("v.question.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            helper.validationMessageComment(component, event, state);
        });

        $A.enqueueAction(action);
    },


    // Developer: Chris Alley
    //save the second line sup comment from the questions detail screen
    saveQuestionCommentSecondLine : function(component, event, helper) {
      console.log('In TQBCPWizardQAViewController : saveQuestionCommentSecondLine START');
       var action = component.get("c.saveQuestionCommentServer");
       var secondCommentValue = component.get('v.secondLineSupQuestionComment');
       console.log("In TQBCPWizardQAViewController : saveQuestionCommentSecondLine : Comment= ");
       console.log(secondCommentValue);
        action.setParams({
            "Comment": secondCommentValue,
            "Comment_Type" : "secondLineSupComment", //do not change, this is hard coded in apex server method
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id"),
            "questionId" : component.get("v.question.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            helper.validationMessageComment(component, event, state);
      });

        $A.enqueueAction(action);
    },

    saveQuesAns : function(component, event, helper) {
    
    helper.getAnswer(component, event);

    var answerLength = component.get("v.answerWithNoWhiteSpaceNTags").length;

    if(answerLength > 3840) {    
         $A.createComponents([
            ["ui:message",{
              "title" : "Save Failed: :",
              "severity" : "error",
              "class" : "slds-size--1-of-2"
            }],
            ["ui:outputText",{
              "value" : "Your answer exceeds max no of characters allowed(3840)."
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
         return;
      }
     else{
          var action = component.get("c.saveQuest");
          action.setParams({
            "candidatePackageId": component.get("v.candPackage.Id"),
            "question": component.get("v.question")
          });
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              //var evt = $A.get("e.c:TQBCPBackToQAView");
              /*var evt = $A.get("e.c:TQBCPViewQA");
              evt.setParams({ "candpkg": component.get("v.candPackage"), "question": response.getReturnValue() });
              evt.fire();*/
              component.set("v.question", response.getReturnValue());
              console.log('TQBCPWizardQAViewController:saveQuesAns: question value =' + response.getReturnValue());
              $A.createComponents([
                ["ui:message",{
                  "title" : "Success :",
                  "severity" : "confirm",
                  "class" : "slds-size--1-of-2"
                }],
                ["ui:outputText",{
                  "value" : "Your answer has been saved successfully."
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
              if (errors[0] && errors[0].pageErrors) {
                console.log(errors[0].pageErrors);
                $A.createComponents([
                  ["ui:message",{
                    "title" : "Save Failed:",
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
                  /*window.setTimeout(
                    $A.getCallback(function() {
                      component.set("v.messages", []);
                    }), 5000
                  );*/
                } )
              } else {
                $A.error("Unknown error");
              }
            }
          });
          $A.enqueueAction(action);
        }
  },

  textCounter : function(component, event, helper) {
      
      helper.textCounterHelper(component, event);

    /*if (ans.length < 3840) {
      component.set("v.answerLength", 3840 - ans.length);
    } else {
      component.set("v.answerLength", 3840);
    }*/
  }
})