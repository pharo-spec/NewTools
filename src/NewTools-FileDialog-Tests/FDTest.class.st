Class {
	#name : #FDTest,
	#superclass : #TestCase,
	#instVars : [
		'filter',
		'root'
	],
	#category : #'NewTools-FileDialog-Tests'
}

{ #category : #'instance creation' }
FDTest >> createRoot [
	(root := (FileLocator imageDirectory / 'fd-test') asFileReference)
		ensureCreateDirectory.
	(root / 'dir') ensureCreateDirectory.
	(root / 'dir' / 'klm.png') ensureCreateFile.
	(root / 'dir' / 'klm.jpg') ensureCreateFile.
	(root / 'dir.ext') ensureCreateDirectory.
	(root / '.hidden-dir') ensureCreateDirectory.
	(root / '.hidden') ensureCreateFile.
	(root / 'sth.ext') ensureCreateFile.
	(root / 'sth.aaa') ensureCreateFile.
	(root / 'banana.jpg') ensureCreateFile.
	(root / 'patate.png') ensureCreateFile.
	^ root
]

{ #category : #'instance creation' }
FDTest >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
FDTest >> setUp [
	self createRoot
]
