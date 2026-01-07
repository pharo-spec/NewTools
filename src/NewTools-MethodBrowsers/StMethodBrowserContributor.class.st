"
I'm a style contributor
"
Class {
	#name : 'StMethodBrowserContributor',
	#superclass : 'StPharoStyleContributor',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'styles' }
StMethodBrowserContributor >> styleSheetContribution [
	
	^ SpStyle newApplication 
		addClass: 'stMessageBrowserScopeList' with: [ :class | class 
			addPropertyGeometryWith: [ :geo | geo width: 220 ] ]
]
