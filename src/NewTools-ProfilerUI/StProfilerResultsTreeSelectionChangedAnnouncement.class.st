"
I prevent my subscribers that the selected node in the results tree has changed
"
Class {
	#name : 'StProfilerResultsTreeSelectionChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'NewTools-ProfilerUI-Announcements',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
StProfilerResultsTreeSelectionChangedAnnouncement >> item [
	^ item
]

{ #category : 'accessing' }
StProfilerResultsTreeSelectionChangedAnnouncement >> item: aTallyModel [
	item := aTallyModel
]
