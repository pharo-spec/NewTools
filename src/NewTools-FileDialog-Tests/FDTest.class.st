Class {
	#name : #FDTest,
	#superclass : #TestCase,
	#instVars : [
		'filter',
		'root'
	],
	#category : #'NewTools-FileDialog-Tests'
}

{ #category : #accessing }
FDTest class >> resources [
	^ {FDFileSystemResource}
]

{ #category : #'instance creation' }
FDTest >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
FDTest >> setUp [
	super setUp.
	root := FDFileSystemResource current root
]
