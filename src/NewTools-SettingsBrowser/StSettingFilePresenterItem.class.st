"
Wrapper for settings containing a file `FileReference` type.
"
Class {
	#name : 'StSettingFilePresenterItem',
	#superclass : 'StSettingDirectoryPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingFilePresenterItem >> labeledPresenterClass [

	^ StLabeledSettingFileSelectionPresenter

]
