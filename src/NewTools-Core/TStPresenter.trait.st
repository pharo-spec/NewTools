"
I'm a trait that manages principally the automatic management of the application to new presenters used for the Pharo tools. 
"
Trait {
	#name : 'TStPresenter',
	#category : 'NewTools-Core-Presenters',
	#package : 'NewTools-Core',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
TStPresenter classSide >> currentApplication [

	^ SpToolCurrentApplication value ifNil: [ StPharoApplication current ]
]

{ #category : 'instance creation' }
TStPresenter classSide >> new [

	^ self newApplication: self currentApplication
]

{ #category : 'accessing' }
TStPresenter classSide >> owner: anOwningPresenter [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
]

{ #category : 'instance creation' }
TStPresenter classSide >> owner: anOwningPresenter on: aDomainObject [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
		model: aDomainObject
]

{ #category : 'accessing' }
TStPresenter classSide >> preferredExtent [

	^ 600@400
]

{ #category : 'initialization' }
TStPresenter >> initializeWindow: aWindowPresenter [
	"All tools should call its parent"

	self traversePresentersDo: [ :each |
		each addWindowShortcutsTo: aWindowPresenter ]
]

{ #category : 'accessing' }
TStPresenter >> preferredExtent [

	^ self class preferredExtent
]

{ #category : 'private' }
TStPresenter >> shortcutForPanel: aNumber [
	"This is a convenience method to assign shortcuts to panels. 
	 panels will be different areas of a tool: a package panel in a browser, an inspector in 
	 the debugger."
	| char |
	
	char := aNumber asString first.
	^ char command mac 
		| char control win 
		| char control unix
]
