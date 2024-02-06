Class {
	#name : 'StFileSystemResource',
	#superclass : 'TestResource',
	#instVars : [
		'root'
	],
	#category : 'NewTools-FileBrowser-Tests-Utils',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Utils'
}

{ #category : 'accessing' }
StFileSystemResource >> bananaJpg [

	^ '/9j/4AAQSkZJRgABAQEAYABgAAD/4QBaRXhpZgAATU0AKgAAAAgABQMBAAUAAAABAAAASgMDAAEAAAABAAAAAFEQAAEAAAABAQAAAFERAAQAAAABAAAOw1ESAAQAAAABAAAOwwAAAAAAAYagAACxj//bAEMAAgEBAgEBAgICAgICAgIDBQMDAwMDBgQEAwUHBgcHBwYHBwgJCwkICAoIBwcKDQoKCwwMDAwHCQ4PDQwOCwwMDP/bAEMBAgICAwMDBgMDBgwIBwgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDP/AABEIABAAEAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/AP38rmfGGs3MvirRNKsLya0nkuFurkxhCJIFDExNvRuHwfu4YbR8wzmofEVj4m0u7uZdJnS+t7jO2GYqHt2PdScAgdsnvjHGaTwN4EutP1ebV9Xljn1KcEKF5EQIGecdeMccAZ5OePx3OOLM/wAxzGjkOV4CvQftYutXnGKpxowleXs6iclOVVR5UkrxUm5KLWnq0cPRpwdepOMtHZdbtdV5fof/2Q=='
]

{ #category : 'accessing' }
StFileSystemResource >> patatePng [

	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAECSURBVDhPY/z//z8DKYAJShMNaK8Bnx927fVkY+WXFHZU106HCuHScHhP4r9/v998PaUgEfLl80MJaTu4HixOAqv++fbbOWZGTqBqoMiLp4cgUkCArgGs+tfbbxdYmDgEuXSAIowMjExMLBBZIEDR8OfPN7Dq83/+ffv55yMHpyhQ8D/DfyYmNogCIIBr+AvEF0+3gFj/vjL8/y/GY8HCwgWWYrB2mg1hAAFcAzMQA1387vtFYCgwMoLcAPEAXBsEYHr6HxDLifoyMoKkgKqRjQcCJA3/PwKlhTgNgUwg4///f8zMHNZOUyCScIAeD0f3pb74eFCC3x7NYDigdWplYAAAtuxmjgEpJ3EAAAAASUVORK5CYII='
]

{ #category : 'accessing' }
StFileSystemResource >> root [
	^ root
]

{ #category : 'running' }
StFileSystemResource >> setUp [

	super setUp.
	{ 
		(root := (FileLocator imageDirectory / 'fd-test') asFileReference).
		(root / 'dir').
		(root / 'dir.ext').
		(root / '.hidden-dir') } do: #ensureCreateDirectory.

	{ 
		(root / 'dir' / 'klm.png').
		(root / 'dir' / 'klm.jpg').
		(root / '.hidden').
		(root / 'sth.ext').
		(root / 'sth.aaa') } do: #ensureCreateFile.

	"root / 'wrong-banana.jpg' writeStreamDo: [ :s | 
		s << 'This image does not work. This is its base64, enjoy: '.
		s << self bananaJpg ]."

	(Form fromBase64String: self bananaJpg) writeJPEGfileNamed:
		root / 'banana.jpg'.

	(Form fromBase64String: self patatePng) writePNGFileNamed:
		root / 'patate.png'
]

{ #category : 'running' }
StFileSystemResource >> tearDown [
	root ensureDeleteAll.
	super tearDown
]
