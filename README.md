# Avery Lamp's Portfolio App
==============================================

### _This app was made to demonstrate some of my development skills, projects,l and story behind me as an iOS Developer for the WWDC Scholarship_
##### Unfortunately, I was not awarded a scholarship, because my submission was faulty and was not submitted with the correct account
[_See the app in action_](https://www.youtube.com/watch?v=zIekBuRtOuA)

### How it was built

I built my portfolio app in a little over two weeks of solid deveopment time using Swift 2.3
When I built my portfolio app, I concentrated on a few aspects of the app that I wanted to make spectacular.  One of my biggest concentrations was with 
UI/UX and animations.  Inside the app I put together many custom animations to transition the user from screen to screen.  

## Animations

### Intro animation

![alt tag](https://raw.githubusercontent.com/Averylamp/Avery-Lamp-WWDC-2016/master/AnimationGifs/IntroAnimation.gif)

The first animation I use in the app is to tell the reviewer a little bit more about myself.  While implementing this animation, I spent a lot of time tuning how the blur gradually appears in the backround.  I had some difficulty making the blur keep the contrast that I wanted in the background picture, so to keep a lot of contrast I used multiple layers of images that fade in.  

The text writing animation is probably my proudest animation that I came up with for the submission.  In order to make this animation, I extended the UILabel class and read through a lot of old CoreText documentation.  It was incredibly difficult to figure out how to get CGPaths from UILabels, but after a lot of research I was able to return individual character CAShapeLayers, or a single CAShapeLayer of the whole text path. Some of the biggest issues I had with the text animations were the CPU usage/memory of the CALayer animations.  In order to reduce memory usage, I release the layers as soon as possible.  I also had a strange error where the last line in a multiline animation sometimes does not animate properly.  

#### In the future I hope to touch up the text animations and release it as a framework or my own custom ALLabel.

### Box Transition

![alt tag](https://raw.githubusercontent.com/Averylamp/Avery-Lamp-WWDC-2016/master/AnimationGifs/BoxDissappearingAnimation.gif)

The box transition animation was one of my favorite animations that I created for the app.  In order to accomplish the animation in code, when the user clicks an image of the current screen is stored.  The image is spiced into a number of small boxes of variable height and width that are placed directly over the screen and stiched together to make the resulting image.  Then I do a flood search from the location of the user's touch, scaling each box down individually and fading it to nothing.
