extends Label

signal speaking_stopped()

var eulogy0 : String = "Its hard to understand loss before youve ever experienced it. Its hard to understand how a person, who in and of themselves are a whole universe, could just vanish in a moment. And sometimes it can be hard to understand quite how much someone means to you until they are gone. I believe it is important to treasure every moment you have with someone, because you never know when it could be your last. Thank you."
var eulogy1 : String = "A life long and well lived. Devoted wife, nuturing mother, and loving grandmother. These are all descriptors that easily bubble up to mind when you think of Mirium. Beyond her family, she was a pillar of her community. Many will feel her loss and absence in their lives. And now for a moment of silence. Would you join me in remembering the life of this woman. She will be missed dearly."
var eulogy2 : String = "Blah blah blah..."
var eulogy3 : String = "Crunchy Leaves... I love to hear them crunch crunch crunch. Oh yes, crunch crunch crunch. Thats a little song I wrote about my grandma. You can find it on soundcloud and spotify..."
var eulogy4 : String = "When I was a child, my mother would take me to the park in autumn and we would crunch on the leaves together. When I had kids, we continued this tradition together - every fall, going on a walk, and finding the cripsiest leaves we could stomp on. Ill treasure those memories and think of them every time the leaves fall."
var eulogy5 : String = "According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees dont care what humans think is impossible.Yellow, black. Yellow, black. Yellow, black. Yellow, black."

var eulogies : Array = [eulogy0, eulogy1, eulogy2, eulogy3, eulogy4, eulogy5]

func _start_typing():
	self.visible = true
	var x = randf_range(0, eulogies.size()-1)
	self.text = eulogies[x]
	
	# how long it takes them to say the speech
	var time = randf_range(2, 8)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, time).from(0.0)
	
	# wait until finished speaking
	await get_tree().create_timer(time).timeout # wait two seconds
	speaking_stopped.emit() # stopped speaking
