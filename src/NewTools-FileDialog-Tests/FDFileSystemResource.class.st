Class {
	#name : #FDFileSystemResource,
	#superclass : #TestResource,
	#instVars : [
		'root'
	],
	#category : #'NewTools-FileDialog-Tests-Utils'
}

{ #category : #accessing }
FDFileSystemResource >> root [
	^ root
]

{ #category : #running }
FDFileSystemResource >> setUp [
	super setUp.
	{(root := (FileLocator imageDirectory / 'fd-test') asFileReference) . (root / 'dir') . (root / 'dir.ext') . (root / '.hidden-dir')} do: #ensureCreateDirectory.

	{(root / 'dir' / 'klm.png') . (root / 'dir' / 'klm.jpg') . (root / '.hidden') . (root / 'sth.ext') . (root / 'sth.aaa') . (root / 'banana.jpg').
	(root / 'patate.png')} do: #ensureCreateFile
]

{ #category : #running }
FDFileSystemResource >> tearDown [
	root ensureDeleteAll.
	super tearDown
]
