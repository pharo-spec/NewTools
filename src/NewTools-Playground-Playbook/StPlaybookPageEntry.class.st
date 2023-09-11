"
An entry for playbook processor.
"
Class {
	#name : #StPlaybookPageEntry,
	#superclass : #StEntry,
	#instVars : [
		'page',
		'playbook'
	],
	#category : #'NewTools-Playground-Playbook-Processor'
}

{ #category : #'instance creation' }
StPlaybookPageEntry class >> newPlaybook: aPlaybook page: aPage [

	^ self new 
		playbook: aPlaybook;
		page: aPage;
		yourself
]

{ #category : #converting }
StPlaybookPageEntry >> asString [ 

	^ page title
]

{ #category : #evaluating }
StPlaybookPageEntry >> doEvaluate [ 

	playbook window activate.
	playbook activatePage: page
]

{ #category : #accessing }
StPlaybookPageEntry >> iconName [
	
	^ StPlaybook systemIconName 
]

{ #category : #initialization }
StPlaybookPageEntry >> page: aPage [

	page := aPage.
	self content: page contents
]

{ #category : #initialization }
StPlaybookPageEntry >> playbook: aPlaybook [

	playbook := aPlaybook
]
