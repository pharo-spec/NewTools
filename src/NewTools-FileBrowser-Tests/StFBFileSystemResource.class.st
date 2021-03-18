Class {
	#name : #StFBFileSystemResource,
	#superclass : #TestResource,
	#instVars : [
		'root'
	],
	#category : #'NewTools-FileBrowser-Tests-Utils'
}

{ #category : #accessing }
StFBFileSystemResource >> root [
	^ root
]

{ #category : #running }
StFBFileSystemResource >> setUp [
	super setUp.
	{(root := (FileLocator imageDirectory / 'fd-test') asFileReference) . (root / 'dir') . (root / 'dir.ext') . (root / '.hidden-dir')} do: #ensureCreateDirectory.

	{(root / 'dir' / 'klm.png') . (root / 'dir' / 'klm.jpg') . (root / '.hidden') . (root / 'sth.ext') . (root / 'sth.aaa') . (root / 'banana.jpg').
	(root / 'patate.png')} do: #ensureCreateFile
]

{ #category : #running }
StFBFileSystemResource >> tearDown [
	root ensureDeleteAll.
	super tearDown
]
