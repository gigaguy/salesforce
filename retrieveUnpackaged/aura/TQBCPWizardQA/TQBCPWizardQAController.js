({
	selectQuestion : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var quest = component.get("v.question");
		var questionIndex = component.get("v.questionIndex");
		console.log('INFO - questionindex value in TQBCPWizardQAController : selectQuestion =' + questionIndex);
		var evt = $A.get("e.c:TQBCPViewQA");
		evt.setParams({ "candpkg": pkg, "question": quest, "questionIndex":questionIndex});
		evt.fire();
	},

	doInit : function(component, event, helper) {
      console.log('INFO - TQBCPWizardQAController : doInit START');
      var questAnswerHtmlComment = component.get("v.question.Answer__c");
	    var div = document.createElement("div");
			div.innerHTML = questAnswerHtmlComment;

	    if(div.innerText != "undefined") {
	      component.set("v.answerWithoutHtml", div.innerText);
	    }
	    else{
			  component.set("v.answerWithoutHtml", "Incomplete");
				var noText = component.find("answerDiv");
				$A.util.addClass(noText,'incompleteAnswer');
	    }
	}
}