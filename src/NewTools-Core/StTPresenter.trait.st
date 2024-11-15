"
I'm a trait that manages principally the automatic management of the application to new presenters used for the Pharo tools. 
"
Trait {
	#name : 'StTPresenter',
	#category : 'NewTools-Core-Presenters',
	#package : 'NewTools-Core',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
StTPresenter classSide >> currentApplication [

	^ SpToolCurrentApplication value ifNil: [ StPharoApplication current ]
]

{ #category : 'instance creation' }
StTPresenter classSide >> new [

	^ self newApplication: self currentApplication
]

{ #category : 'accessing' }
StTPresenter classSide >> owner: anOwningPresenter [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
]

{ #category : 'instance creation' }
StTPresenter classSide >> owner: anOwningPresenter on: aDomainObject [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
		model: aDomainObject
]

{ #category : 'accessing' }
StTPresenter classSide >> preferredExtent [

	^ 600@400
]

{ #category : 'initialization' }
StTPresenter >> initializeWindow: aWindowPresenter [
	"All tools should call its parent"

	self traversePresentersDo: [ :each |
		each addWindowShortcutsTo: aWindowPresenter ]
]

{ #category : 'accessing' }
StTPresenter >> preferredExtent [

	^ self class preferredExtent
]

{ #category : 'private' }
StTPresenter >> shortcutForPanel: aNumber [
	"This is a convenience method to assign shortcuts to panels. 
	 panels will be different areas of a tool: a package panel in a browser, an inspector in 
	 the debugger."
	| char |
	
	char := aNumber asString first.
	^ char command mac 
		| char control win 
		| char control unix
]
