"
A source method converted to be used in version browser.
It can update the code panel through a double dispatch (see `DiffSourceMethodConverter>>#updateContent:on:`)
"
Class {
	#name : #DiffSourceMethodConverter,
	#superclass : #SourceMethodConverter,
	#category : #'NewTools-MethodBrowsers-Base'
}

{ #category : #updating }
DiffSourceMethodConverter >> updateContent: content on: aVersionBrowser [ 
	
	aVersionBrowser updateSource: content
]
