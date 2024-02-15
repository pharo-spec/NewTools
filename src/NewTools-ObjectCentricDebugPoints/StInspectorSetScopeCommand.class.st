"
I am an inspector command allowing to set the scope of a debug point to the inspected object.
"
Class {
	#name : 'StInspectorSetScopeCommand',
	#superclass : 'StInspectorCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StInspectorSetScopeCommand class >> defaultDescription [ 
	^'Change the scope of a debug point to this object'
]

{ #category : 'initialization' }
StInspectorSetScopeCommand class >> defaultIconName [ 
	^#smallDebug
]

{ #category : 'default' }
StInspectorSetScopeCommand class >> defaultName [
	<toolbarInspectCommand: 1>
	
	^'Set Scope'
]

{ #category : 'documentation' }
StInspectorSetScopeCommand class >> documentContextRequiredSelectors [ 
	^super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : 'executing' }
StInspectorSetScopeCommand >> execute [

	| debugPoint |
	debugPoint := DebugPointSelectDialogPresenter new
		              scope: self interestingObject;
		              items: DebugPoint all asOrderedCollection;
		              label:
			              'The scope of the selected debug point will be set to the inspected object';
		              title: 'Select Debug Point';
		              openModal.

	debugPoint ifNotNil: [ :dp |
		dp targetInstance: self interestingObject ]
]
