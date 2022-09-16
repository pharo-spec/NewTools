"
Browse current selected object.
"
Class {
	#name : #StInspectorBrowseSelectedCommand,
	#superclass : #StInspectorCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #default }
StInspectorBrowseSelectedCommand class >> defaultDescription [

	^ 'Browse this instance class definition'
]

{ #category : #initialization }
StInspectorBrowseSelectedCommand class >> defaultIconName [

	^ #smallSystemBrowser
]

{ #category : #default }
StInspectorBrowseSelectedCommand class >> defaultName [
	<toolbarInspectCommand: 30>

	^ 'Browse'
]

{ #category : #documentation }
StInspectorBrowseSelectedCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : #execution }
StInspectorBrowseSelectedCommand >> execute [ 

	self context systemNavigation browse: self interestingObject
]

{ #category : #execution }
StInspectorBrowseSelectedCommand >> interestingObject [

	^ self context selectedObject
]
