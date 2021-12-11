"
A method converter to be used in version browser to show a side by side diff.
It can update the code panel through a double dispatch (see `DiffSideBySideChangeRecordConverter>>#updateContent:on:`)

"
Class {
	#name : #DiffSideBySideChangeRecordConverter,
	#superclass : #DiffVersionChangeRecordConverter,
	#category : #'NewTools-MethodBrowsers-Base'
}

{ #category : #updating }
DiffSideBySideChangeRecordConverter >> updateContent: content on: aVersionBrowser [ 
	
	aVersionBrowser updateDiff: content
]
