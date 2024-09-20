"
## Example

```
StCritiqueClassRuleSelectorPresenter 
	openWithEnvironment: (RBClassEnvironment new classes: { ReClassForGeneratingEqualAndHashExistingImplementors }) 
	removeTestCase: false. 
```

"
Class {
	#name : 'StCritiqueClassRuleSelectorPresenter',
	#superclass : 'StCritiqueRuleSelectorPresenter',
	#category : 'NewTools-CodeCritiques-Applier',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Applier'
}

{ #category : 'adding' }
StCritiqueClassRuleSelectorPresenter >> nextAction [

	self delete.

	CBCritiqueWorkingConfiguration current
		rule: selectedRules;
		environment: environment;
		removeTestCase: removeTestCase.
	StClassCritiqueBrowserPresenter openOnWorkingConfiguration:
		CBCritiqueWorkingConfiguration current
]
