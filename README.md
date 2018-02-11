<img src="https://www.dropbox.com/s/m97zh7wtm2a1z4r/gidget.jpg??raw=1" width="100" height="200" />


# Examples of using the Rvision package
### This is a living repo and the examples are subject to change and sometimes not working

This repo is my stash of code examples using the R package [`Rvision`](https://github.com/swarm-lab/Rvision). `Rvision` is a really great package out of the [Swarm Lab](http://www.theswarmlab.com/) at the [New Jersey Institute of Technology](www.njit.edu). This package ports aspects of the massive [`OpenCV` Library](https://opencv.org/) for machine vision into R; a new and needed addition! I started experimenting with this package soon after its release and found it very fun to work with. This repo contains my code and examples of working with the `Rvision` package in conjunction with [`Tensorflow`](https://tensorflow.rstudio.com/) and [`Keras`](https://keras.rstudio.com/) machine learning libraries.

The basis for much of this code is a series of tweets and discussion with the Swarm Lab PI and primary package author [Simon Garnier](https://twitter.com/sjmgarnier). I am not affiliated with the Swarm Lab or the `Rvision` package. Also note, the examples here have a number of dependencies that require some attention. `Rvision` itself requires the `Rtools` tool-chain and `gmake`. The `Tensorflow` and `keras` installs range from pain-free to a total pain in the butt.  See the package links above for installation details.

There is still a ton of work to be done here and these examples are simplistic, but enjoyable to put together.

## Code in this repo


*   Video_balloon_blob.R - single object tracking example
*   MNIST_CNN_video_predict.r - use CNN trained on MNIST to classify numbers in video
*   LIVE_webcam_CNN_single_blob_prediction.r - NOT FINISHED - object tracking and CNN prediction with ResNet50
*   LIVE_webcam_CNN_prediction.r - ResNet50 CNN classification of video frames
*   LIVE_webcam_blob_detection.r - object tracking from webcam
*   KERAS_train_MNIST_CNN.r - script to train MNIST CNN with Keras (from Keras examples)


