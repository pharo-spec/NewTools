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
FDTest >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
FDTest >> setUp [
	super setUp.
	(root := (FileLocator imageDirectory / 'fd-test') asFileReference) ensureCreateDirectory.
	{(root / 'dir') . (root / 'dir' / 'klm.png') . (root / 'dir' / 'klm.jpg') . (root / 'dir.ext') . (root / '.hidden-dir') . (root / '.hidden').
	(root / 'sth.ext') . (root / 'sth.aaa') . (root / 'banana.jpg') . (root / 'patate.png')} do: #ensureCreateFile
]
