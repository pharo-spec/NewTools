"
A method converter to be used in version browser to show a line diff (a traditional diff).
It can update the code panel through a double dispatch (see `DiffLineChangeRecordConverter>>#updateContent:on:`)

"
Class {
	#name : 'DiffLineChangeRecordConverter',
	#superclass : 'DiffVersionChangeRecordConverter',
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'updating' }
DiffLineChangeRecordConverter >> updateContent: content on: aVersionBrowser [
	
	aVersionBrowser updateDiffLine: content
]
