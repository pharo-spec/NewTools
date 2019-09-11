Class {
	#name : #FDTestCase,
	#superclass : #TestCase,
	#instVars : [
		'root'
	],
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #testing }
FDTestCase class >> isAbstract [
	^ self = FDTestCase
]

{ #category : #accessing }
FDTestCase class >> resources [
	^ {FDFileSystemResource}
]

{ #category : #testing }
FDTestCase class >> shouldInheritSelectors [
	^ true
]

{ #category : #'instance creation' }
FDTestCase >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
FDTestCase >> setUp [
	super setUp.
	root := FDFileSystemResource current root
]
