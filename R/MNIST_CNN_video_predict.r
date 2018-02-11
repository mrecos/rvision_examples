library("Rvision")
library("dplyr")
library("reticulate")

### Requires MNIST model trained on 28x28 grayscare MNIST dataset, see: KERAS_train_MNIST_CNN.r

my_vid <- video("./Video/videoplayback.mp4")
old <- Sys.time()

for(i in 1:nframes(my_vid)){
  
  img <- readNext(my_vid)
  new <- Sys.time()
  
  img32 <- resize(img, 28,28)
  img32_gray <- changeColorSpace(img32,"GRAY")
  img32_scale <- 1-(as.matrix(img32_gray)/255) # scale colors, still not 100%
  img32_array <- reticulate::array_reshape(img32_scale, c(1, 28, 28, 1))
  results <- model %>% predict(img32_array) %>%
    data.frame() %>%
    magrittr::set_colnames(seq(0,9,1))
  results$top <- as.numeric(colnames(results)[max.col(results,ties.method="first")])
  print(results[1,])
  
  drawText(img, paste0("pred: ", format(results$top[1], digits = 2, nsmall = 0)),
           x = 30, y = 30, font_face = 'plain', font_scale = 4,
           color = "red", thickness = 3)

  old <- new
  
  display(img, "Live test", 1, 144*4, 176*4)
}


