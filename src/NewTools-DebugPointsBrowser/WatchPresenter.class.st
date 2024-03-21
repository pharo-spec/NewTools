"
I a the watchpoint-specific UI element.
"
Class {
	#name : 'WatchPresenter',
	#superclass : 'DebugPointPresenter',
	#instVars : [
		'historyList',
		'textInput'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
WatchPresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	
	textInput number: (self debugPoint limit ifNil:[''] ifNotNil: [:s|s]).
	historyList items: self debugPoint history.
]

{ #category : 'layout' }
WatchPresenter >> defaultLayout [ 
	
	^SpBoxLayout newTopToBottom 
		add: (self newLabel label: 'Watch') expand: false ;
		add: ( SpBoxLayout newTopToBottom  borderWidth: 5;
			add: ( SpBoxLayout newLeftToRight
				add: (self newLabel label: 'History:') expand: true;
				add: (self newLabel label: 'Limit:   ' ) expand: false;
				add: textInput width: 50; 
				yourself) expand: false ;	
			add: historyList expand: true fill: true padding: 1;
			yourself) expand: true;
		yourself.
		

]

{ #category : 'initialization' }
WatchPresenter >> initializePresenters [ 
	
	historyList := self newList 
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | selection selectedItem inspect ].
	textInput := self newNumberInput beInteger; minimum: 0.
	textInput whenNumberChangedDo: [ :a | self debugPoint limit: (textInput number ). ].
]
