Class {
	#name : 'StMessageBrowserContributor',
	#superclass : 'StPharoStyleContributor',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'styles' }
StMessageBrowserContributor >> styleSheetContribution [
	
	^ SpStyle newApplication 
		addClass: 'stMessageBrowserScopeList' with: [ :class | class 
			addPropertyGeometryWith: [ :geo | geo width: 220 ] ]
]
