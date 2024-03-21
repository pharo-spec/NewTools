"
I am the breakpoint-specific UI element.
"
Class {
	#name : 'BreakPresenter',
	#superclass : 'DebugPointPresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'layout' }
BreakPresenter >> defaultLayout [ 
	
	^SpBoxLayout newTopToBottom 
		add: (self newLabel label: 'Break') expand: false ;
		yourself.
		

]
