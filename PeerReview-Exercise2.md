# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Nico Medina
* *email:* dwmedina@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The position lock camera works perfectly fine. You do have two fields exported, box_height and box_width that don't get used anywhere in that script file though, and the prompt does say to not have any other fields in the inspector.

___
### Stage 2 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
You're implementation works, it just took some fiddling around with the box corners to get it working right. All the initial values for the exported fields were the default of 0, so I had to play around to figure out what number made it work. You have it so that the top left corner has to be set to, lets use 5, x = -5 and y = 5, and the bottom right corner has to be set to x = 5 and y = -5. This doesn't logically make sense for the signs for the top left corner to be a positive y value, and same for having the bottom right have a negative x value. In the global position of the world, a negative x value should be to the left, and a negative y should be up. Conversely, a positive x should be right, and a positive y should be down. I am also assuming that the camera you are attempting to implement stage 2 is your PushBoxCamera2, and not PushBoxCamera4 despite both having autoscrolling features, and PushBoxCamera4 not working entirely correct for stage 2.

___
### Stage 3 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Again, since all the export fields are initialized to the default of 0, it took a lot of fiddling around with the values to get it working. It was very confusing because you have Box Width and Box Height export variables, which made it seem like this was a pushbox camera, but the camera works mostly right if the box dimensions are turned up really high. The leash does not seem to be implemented correctly, as no matter what I set it to, it will not limit the distance between the target and the camera. In your code you appear to just have the camera use lerp to calculate where the camera should go if the distance between the target and camera is greater than the leash, which does not really work to limit the distance. As well, the sign issues with the box corners from the previous stage apply here.
___
### Stage 4 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Again again, it was unclear at first if your PushBoxCamera4 was supposed to be your Stage 4 camera, because, again, it took a lot of fiddling with the export values to get it to work. This one was especially confusing because there are a lot of exports that are irrelevant to this camera: Top Left, Bottom Right, Autoscroll Speed, Box Width, and Box Height. But, once I got it all set right, your camera works pretty well, the only issue I could find with it is that the catchup delay doesn't seem to be working right, as the camera simply moves to the target right away. 

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

___
#### Justification ##### 
With the exported fields set to the default values, I again had to fiddle around to try to get the camera to work, but I could not get it working. It does appear that the speedup zone works, as you can notice that the camera is slow at first, but once the target hits the pushbox, the target goes outside of the bounds and the camera does not do a good job of keeping up. As well, the camera always moves towards the target, even when the target is within the speedup zone, or not moving outside of it.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
* [Spacing Between Functions](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box.gd#L22) - there are not 2 blank lines between these functions. This occurs across all the script files you created.

#### Style Guide Exemplars ####
* [Member Order](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box4.gd#L4) - I want to commend you on how well you maintained the order of your member variables across all your files, with proper typing too, especially in this linked file where there are a lot of member variables.
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
 * [Class Naming](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box.gd#L1) - Having all your cameras named so similarly and not having them being according to their functionallity makes it extremely confusing to read.
 * [Poor Sign Convention](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box2.gd#L35) - The incorrect sign usage on your y values for Top Left and Bottom Right make difficult for others to use.
 * [Excess Exports](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box4.gd#L6) - The excess exports in this camera that don't provide meaningful debugging info or just aren't relevant make the camera hard to use.
#### Best Practices Exemplars ####
* [Commenting](https://github.com/ensemble-ai/exercise-2-camera-control-BrianTinNguyen/blob/103f15342d0ee8c8c2962dfa3aa69ba7bdd050cd/Obscura/scripts/camera_controllers/push_box4.gd#L35) - The comments, across most of your files but most notably here, do a great job of breaking your code into sections and tell what the section does.
