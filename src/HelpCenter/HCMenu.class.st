Class {
	#name : 'HCMenu',
	#superclass : 'ComposablePresenter',
	#instVars : [
		'buttonManuals',
		'buttonTutorials',
		'buttonProfStef',
		'linkBooks',
		'hcbrowserComponent'
	],
	#category : 'HelpCenter',
	#package : 'HelpCenter'
}

{ #category : 'specs' }
HCMenu class >> defaultSpec [
	^SpecLayout composed
		newRow: [ :row | 
			row add: #buttonManuals; 
			add: #buttonTutorials;
			add: #buttonProfStef 
		] height: 35;

		yourself
		
]

{ #category : 'accessing' }
HCMenu >> buttonManuals [
	^ buttonManuals
]

{ #category : 'accessing' }
HCMenu >> buttonManuals: anObject [
	buttonManuals := anObject
]

{ #category : 'accessing' }
HCMenu >> buttonProfStef [
	^ buttonProfStef
]

{ #category : 'accessing' }
HCMenu >> buttonProfStef: anObject [
	buttonProfStef := anObject
]

{ #category : 'accessing' }
HCMenu >> buttonTutorials [
	^ buttonTutorials
]

{ #category : 'accessing' }
HCMenu >> buttonTutorials: anObject [
	buttonTutorials := anObject
]

{ #category : 'accessing' }
HCMenu >> hcbrowserComponent [
	^ hcbrowserComponent
]

{ #category : 'accessing' }
HCMenu >> hcbrowserComponent: anObject [
	hcbrowserComponent := anObject
]

{ #category : 'initialization' }
HCMenu >> initializePresenter [ 
	buttonProfStef action: [ ProfStef go ].
]

{ #category : 'initialization' }
HCMenu >> initializeWidgets [ 
	buttonManuals := self newButton 
		label: 'Manuals';
		icon: (self iconNamed: #smallOpen);
		help: 'How to use Pharo frameworks';
		yourself.
	buttonTutorials := self newButton 
		label: 'Tutorials';
		icon: (self iconNamed: #smallCopy);
		help: 'Some Pharo tutorials';
		yourself.
	buttonProfStef := self newButton 
		label: 'ProfStef';
		icon: (self iconNamed: #user);
		help: 'ProfStef is the Pharo teacher';
		yourself.
]

{ #category : 'accessing' }
HCMenu >> linkBooks [
	^ linkBooks
]

{ #category : 'accessing' }
HCMenu >> linkBooks: anObject [
	linkBooks := anObject
]

{ #category : 'api' }
HCMenu >> title [ 
	^'Menu'
]
