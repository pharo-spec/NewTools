Class {
	#name : #FDOpenDirectoryDialogTest,
	#superclass : #FDFileDialogTest,
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #accessing }
FDOpenDirectoryDialogTest >> dialogClass [
	^ FDOpenDirectoryDialog
]

{ #category : #tests }
FDOpenDirectoryDialogTest >> testSelectDirectory [
	| selectedDirectory |
	dialog okAction: [ :dir | selectedDirectory := dir ].
	window := dialog openDialogWithSpec.
	self assert: dialog fileNavigationSystem currentDirectory equals: root.
	dialog selectFile: root / 'dir'.
	self assert: dialog selectedEntry equals: root / dialog fileNavigationSystem selectedEntry basename.
	window triggerOkAction.
	self assert: selectedDirectory equals: root / 'dir'
]
